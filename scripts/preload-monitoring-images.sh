#!/usr/bin/env bash
set -euo pipefail

# Pre-pull lab platform images on the host, then load them into kind.
# Use when kind nodes fail registry pulls because of local network or IPv6 issues.
#
# Covers kube-prometheus-stack, Loki, Promtail, Postgres, Adminer, and Vault.
# Local app images (sample-backend, sample-frontend, support-exporter) are built
# and loaded by `make apps-up` / `make *-load`, not pulled from a registry.
#
# kind load docker-image uses `ctr import --all-platforms`. With Docker's
# containerd image store, docker save can emit a multi-arch index without all
# platform layers, which fails with "content digest ...: not found".
# Work around by saving a single-platform archive and using kind load image-archive.
#
# Some manifests label ARM as linux/arm64/v8 instead of linux/arm64. Docker save
# --platform matching is strict, so we try platform candidates and fall back to a
# buildx single-platform re-export when needed.

KIND_CLUSTER_NAME="${KIND_CLUSTER_NAME:-platform-engineering}"
PULL_RETRIES="${PULL_RETRIES:-8}"
PULL_RETRY_SLEEP_SECONDS="${PULL_RETRY_SLEEP_SECONDS:-5}"
# Archives that are only an index/manifest (no layers) are typically a few KB.
MIN_ARCHIVE_BYTES="${MIN_ARCHIVE_BYTES:-1048576}"

detect_image_platform() {
  local os arch machine

  if [ -n "${IMAGE_PLATFORM:-}" ]; then
    printf '%s\n' "${IMAGE_PLATFORM}"
    return 0
  fi

  os="$(docker version -f '{{.Server.Os}}' 2>/dev/null || true)"
  arch="$(docker version -f '{{.Server.Arch}}' 2>/dev/null || true)"
  if [ -n "${os}" ] && [ -n "${arch}" ]; then
    case "${arch}" in
      aarch64|arm64) printf '%s/arm64\n' "${os}" ;;
      x86_64|amd64) printf '%s/amd64\n' "${os}" ;;
      *) printf '%s/%s\n' "${os}" "${arch}" ;;
    esac
    return 0
  fi

  machine="$(uname -m)"
  case "${machine}" in
    aarch64|arm64) printf 'linux/arm64\n' ;;
    x86_64|amd64) printf 'linux/amd64\n' ;;
    *)
      echo "Error: unable to detect IMAGE_PLATFORM from uname -m=${machine}." >&2
      echo "Set IMAGE_PLATFORM explicitly (for example linux/arm64 or linux/amd64)." >&2
      return 1
      ;;
  esac
}

platform_candidates() {
  local base_platform="$1"

  case "${base_platform}" in
    linux/arm64|linux/arm64/v8)
      printf '%s\n' "linux/arm64" "linux/arm64/v8"
      ;;
    linux/amd64)
      printf '%s\n' "linux/amd64"
      ;;
    *)
      printf '%s\n' "${base_platform}"
      ;;
  esac
}

archive_looks_valid() {
  local archive="$1"
  local size

  size="$(wc -c < "${archive}" | tr -d ' ')"
  if [ "${size}" -lt "${MIN_ARCHIVE_BYTES}" ]; then
    echo "Warning: archive ${archive} is only ${size} bytes (expected >= ${MIN_ARCHIVE_BYTES}); treating as incomplete." >&2
    return 1
  fi
  return 0
}

pull_with_retry() {
  local image="$1"
  local candidate attempt

  for candidate in "${PLATFORM_CANDIDATES[@]}"; do
    for attempt in $(seq 1 "${PULL_RETRIES}"); do
      echo "Pulling ${image} for ${candidate} (attempt ${attempt}/${PULL_RETRIES})"
      if docker pull --platform "${candidate}" "${image}"; then
        return 0
      fi
      if [ "${attempt}" -eq "${PULL_RETRIES}" ]; then
        echo "Warning: failed to pull ${image} for ${candidate} after ${PULL_RETRIES} attempts."
        break
      fi
      echo "Retrying in ${PULL_RETRY_SLEEP_SECONDS}s..."
      sleep "${PULL_RETRY_SLEEP_SECONDS}"
    done
  done

  echo "Error: failed to pull ${image} for platforms: ${PLATFORM_CANDIDATES[*]}"
  return 1
}

save_single_platform_archive() {
  local image="$1"
  local archive="$2"
  local candidate

  for candidate in "${PLATFORM_CANDIDATES[@]}"; do
    echo "Trying docker save --platform ${candidate} for ${image}"
    rm -f "${archive}"
    if docker save --platform "${candidate}" -o "${archive}" "${image}" \
      && archive_looks_valid "${archive}"; then
      return 0
    fi
  done

  echo "Falling back to buildx single-platform re-export for ${image}"
  rm -f "${archive}"
  if ! printf 'FROM %s\n' "${image}" \
    | docker buildx build --platform "${IMAGE_PLATFORM}" -t "${image}" --load -; then
    echo "Error: buildx re-export failed for ${image}"
    return 1
  fi

  # After --load, the local tag should be a single-platform image.
  if docker save --platform "${IMAGE_PLATFORM}" -o "${archive}" "${image}" \
    && archive_looks_valid "${archive}"; then
    return 0
  fi
  if docker save -o "${archive}" "${image}" \
    && archive_looks_valid "${archive}"; then
    return 0
  fi

  echo "Error: unable to produce a valid single-platform archive for ${image}"
  return 1
}

load_into_kind() {
  local image="$1"
  local archive
  local status=0

  archive="$(mktemp)"
  echo "Saving ${image} and loading into kind/${KIND_CLUSTER_NAME}"
  if ! save_single_platform_archive "${image}" "${archive}"; then
    status=1
  elif ! kind load image-archive "${archive}" --name "${KIND_CLUSTER_NAME}"; then
    status=1
  fi
  rm -f "${archive}"
  return "${status}"
}

IMAGE_PLATFORM="$(detect_image_platform)"
PLATFORM_CANDIDATES=()
while IFS= read -r candidate; do
  PLATFORM_CANDIDATES+=("${candidate}")
done < <(platform_candidates "${IMAGE_PLATFORM}")

images=(
  # kube-prometheus-stack (chart 87.10.1)
  quay.io/prometheus/node-exporter:v1.11.1-distroless
  quay.io/prometheus-operator/prometheus-operator:v0.92.1
  quay.io/prometheus-operator/prometheus-config-reloader:v0.92.1
  quay.io/prometheus/alertmanager:v0.33.1
  quay.io/prometheus/prometheus:v3.13.0-distroless
  registry.k8s.io/kube-state-metrics/kube-state-metrics:v2.19.1
  quay.io/kiwigrid/k8s-sidecar:2.8.1
  docker.io/grafana/grafana:13.1.0
  # Loki (chart 6.55.0) + Promtail (chart 6.16.6 / appVersion 3.0.0)
  docker.io/grafana/loki:3.6.7
  docker.io/grafana/promtail:3.0.0
  # Lab data charts
  docker.io/postgres:17-alpine
  docker.io/adminer:5-standalone
  # Vault helm chart 0.29.1 (server + injector; CSI disabled in values)
  docker.io/hashicorp/vault:1.18.1
  docker.io/hashicorp/vault-k8s:1.5.0
)

if ! kind get clusters | grep -xq "${KIND_CLUSTER_NAME}"; then
  echo "Error: kind cluster ${KIND_CLUSTER_NAME} is not running."
  exit 1
fi

echo "Using IMAGE_PLATFORM=${IMAGE_PLATFORM}"
echo "Platform candidates: ${PLATFORM_CANDIDATES[*]}"

for image in "${images[@]}"; do
  pull_with_retry "${image}"
done

for image in "${images[@]}"; do
  load_into_kind "${image}"
done

echo "All platform lab images are loaded into kind/${KIND_CLUSTER_NAME}."
echo "Build and load local app images separately with: make apps-up"
