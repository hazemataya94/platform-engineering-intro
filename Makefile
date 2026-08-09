override KIND_CLUSTER_NAME := platform-engineering
override KIND_CONTEXT := kind-platform-engineering
KIND_CONFIG_PATH ?= infrastructure/kubernetes/kind/cluster-config.yaml
HELMFILE_PATH ?= infrastructure/kubernetes/helmfile.yaml
override KUBECTL := kubectl --context "$(KIND_CONTEXT)"
GRAFANA_PORT ?= 3000
PROMETHEUS_PORT ?= 9090
ALERTMANAGER_PORT ?= 9093
ADMINER_PORT ?= 8081
VAULT_PORT ?= 8200
BACKEND_IMAGE ?= platform-engineering-sample-backend:local
FRONTEND_IMAGE ?= platform-engineering-sample-frontend:local
EXPORTER_IMAGE ?= platform-engineering-support-metrics-exporter:local
APPS_NAMESPACE ?= platform-apps
DATA_NAMESPACE ?= platform-data

.PHONY: help install-prereqs check-prereqs ensure-kind-context kind-up kind-down monitoring-up monitoring-down monitoring-preload-images logging-up logging-down data-up data-down postgres-up postgres-down adminer-up adminer-down vault-up vault-down vault-configure vault-seed-demo-secrets demo-db-credentials backend-build backend-load backend-up backend-down frontend-build frontend-load frontend-up frontend-down exporter-build exporter-load exporter-up exporter-down apps-build apps-load apps-up apps-down dashboard-up dashboard-down alerts-up alerts-down grafana-port-forward prometheus-port-forward alertmanager-port-forward adminer-port-forward vault-ui status clean

help: ## Show available commands.
	@grep -E '^[a-zA-Z_-]+:.*?## ' Makefile | \
	awk -F ':.*?## ' '{printf "%-28s %s\n", $$1, $$2}' | \
	sort

check-prereqs: ## Check required local tools.
	./scripts/check-prereqs.sh

install-prereqs: ## Install required local tools for supported OSes.
	./scripts/install-prereqs.sh

ensure-kind-context: ## Fail unless kubectl points at this lab's kind context.
	@current_context=$$(kubectl config current-context 2>/dev/null || true); \
	if [ "$$current_context" != "$(KIND_CONTEXT)" ]; then \
		echo "Error: current kubectl context is '$$current_context', expected '$(KIND_CONTEXT)'."; \
		echo "Run: kubectl config use-context $(KIND_CONTEXT)"; \
		exit 1; \
	fi

kind-up: ## Create the local kind cluster.
	@if kind get clusters | grep -xq "$(KIND_CLUSTER_NAME)"; then \
		echo "kind cluster $(KIND_CLUSTER_NAME) is already running"; \
	else \
		kind create cluster --name "$(KIND_CLUSTER_NAME)" --config "$(KIND_CONFIG_PATH)"; \
	fi

kind-down: ## Delete the local kind cluster.
	@if kind get clusters | grep -xq "$(KIND_CLUSTER_NAME)"; then \
		kind delete cluster --name "$(KIND_CLUSTER_NAME)"; \
	else \
		echo "kind cluster $(KIND_CLUSTER_NAME) is not running"; \
	fi

monitoring-preload-images: ## Host-pull platform lab images and kind-load them (IPv6 pull workaround).
	./scripts/preload-monitoring-images.sh

monitoring-up: ensure-kind-context ## Install kube-prometheus-stack.
	helmfile --kube-context "$(KIND_CONTEXT)" -f "$(HELMFILE_PATH)" --selector stack=monitoring sync

monitoring-down: ensure-kind-context ## Remove kube-prometheus-stack.
	@if helm --kube-context "$(KIND_CONTEXT)" -n monitoring status kube-prometheus-stack >/dev/null 2>&1; then \
		helmfile --kube-context "$(KIND_CONTEXT)" -f "$(HELMFILE_PATH)" --selector stack=monitoring destroy; \
	else \
		echo "kube-prometheus-stack release is already absent"; \
	fi

logging-up: ensure-kind-context ## Install Loki and cluster-wide Promtail.
	helmfile --kube-context "$(KIND_CONTEXT)" -f "$(HELMFILE_PATH)" --selector stack=logging sync

logging-down: ensure-kind-context ## Remove Loki and Promtail.
	@if helm --kube-context "$(KIND_CONTEXT)" -n logging status promtail >/dev/null 2>&1 || helm --kube-context "$(KIND_CONTEXT)" -n logging status loki >/dev/null 2>&1; then \
		helmfile --kube-context "$(KIND_CONTEXT)" -f "$(HELMFILE_PATH)" --selector stack=logging destroy; \
	else \
		echo "logging stack releases are already absent"; \
	fi

data-up: ensure-kind-context ## Install PostgreSQL and Adminer.
	helmfile --kube-context "$(KIND_CONTEXT)" -f "$(HELMFILE_PATH)" --selector stack=data sync

data-down: ensure-kind-context ## Remove PostgreSQL and Adminer.
	@if helm --kube-context "$(KIND_CONTEXT)" -n "$(DATA_NAMESPACE)" status adminer >/dev/null 2>&1 || helm --kube-context "$(KIND_CONTEXT)" -n "$(DATA_NAMESPACE)" status postgres >/dev/null 2>&1; then \
		helmfile --kube-context "$(KIND_CONTEXT)" -f "$(HELMFILE_PATH)" --selector stack=data destroy; \
	else \
		echo "data stack releases are already absent"; \
	fi

postgres-up: data-up ## Alias for data-up (PostgreSQL + Adminer).

postgres-down: data-down ## Alias for data-down.

adminer-up: data-up ## Alias for data-up (PostgreSQL + Adminer).

adminer-down: data-down ## Alias for data-down.

vault-up: ensure-kind-context ## Install Vault (simplified standalone/dev lab mode) with injector.
	helmfile --kube-context "$(KIND_CONTEXT)" -f "$(HELMFILE_PATH)" --selector stack=security sync

vault-down: ensure-kind-context ## Remove Vault.
	@if helm --kube-context "$(KIND_CONTEXT)" -n vault status vault >/dev/null 2>&1; then \
		helmfile --kube-context "$(KIND_CONTEXT)" -f "$(HELMFILE_PATH)" --selector stack=security destroy; \
	else \
		echo "vault release is already absent"; \
	fi

vault-configure: ## Apply Terraform Vault configuration (requires vault port-forward + token).
	./scripts/vault-configure.sh

vault-seed-demo-secrets: ## Seed local-lab KV demo secret into Vault (runtime only).
	./scripts/seed-vault-demo-secrets.sh

demo-db-credentials: ## Request dynamic PostgreSQL credentials (1h TTL role).
	./scripts/demo-db-credentials.sh

backend-build: ## Build the sample backend image.
	docker build -t "$(BACKEND_IMAGE)" ./apps/sample-backend

backend-load: ## Load the sample backend image into kind.
	kind load docker-image "$(BACKEND_IMAGE)" --name "$(KIND_CLUSTER_NAME)"

backend-up: ensure-kind-context backend-build backend-load ## Deploy sample backend through the backend Helm chart.
	helm --kube-context "$(KIND_CONTEXT)" upgrade --install sample-backend ./charts/backend --namespace "$(APPS_NAMESPACE)" --create-namespace

backend-down: ensure-kind-context ## Remove the sample backend release.
	@if helm --kube-context "$(KIND_CONTEXT)" -n "$(APPS_NAMESPACE)" status sample-backend >/dev/null 2>&1; then \
		helm --kube-context "$(KIND_CONTEXT)" -n "$(APPS_NAMESPACE)" uninstall sample-backend; \
	else \
		echo "sample-backend release is already absent"; \
	fi

frontend-build: ## Build the sample frontend image.
	docker build -t "$(FRONTEND_IMAGE)" ./apps/sample-frontend

frontend-load: ## Load the sample frontend image into kind.
	kind load docker-image "$(FRONTEND_IMAGE)" --name "$(KIND_CLUSTER_NAME)"

frontend-up: ensure-kind-context frontend-build frontend-load ## Deploy sample frontend through the frontend Helm chart.
	helm --kube-context "$(KIND_CONTEXT)" upgrade --install sample-frontend ./charts/frontend --namespace "$(APPS_NAMESPACE)" --create-namespace

frontend-down: ensure-kind-context ## Remove the sample frontend release.
	@if helm --kube-context "$(KIND_CONTEXT)" -n "$(APPS_NAMESPACE)" status sample-frontend >/dev/null 2>&1; then \
		helm --kube-context "$(KIND_CONTEXT)" -n "$(APPS_NAMESPACE)" uninstall sample-frontend; \
	else \
		echo "sample-frontend release is already absent"; \
	fi

exporter-build: ## Build the support metrics exporter image.
	docker build -t "$(EXPORTER_IMAGE)" ./apps/support-metrics-exporter

exporter-load: ## Load the support metrics exporter image into kind.
	kind load docker-image "$(EXPORTER_IMAGE)" --name "$(KIND_CLUSTER_NAME)"

exporter-up: ensure-kind-context exporter-build exporter-load ## Deploy support metrics exporter through Helm.
	helm --kube-context "$(KIND_CONTEXT)" upgrade --install support-exporter ./charts/support-exporter --namespace "$(APPS_NAMESPACE)" --create-namespace

exporter-down: ensure-kind-context ## Remove the support metrics exporter release.
	@if helm --kube-context "$(KIND_CONTEXT)" -n "$(APPS_NAMESPACE)" status support-exporter >/dev/null 2>&1; then \
		helm --kube-context "$(KIND_CONTEXT)" -n "$(APPS_NAMESPACE)" uninstall support-exporter; \
	else \
		echo "support-exporter release is already absent"; \
	fi

apps-build: backend-build frontend-build exporter-build ## Build all application images.

apps-load: backend-load frontend-load exporter-load ## Load all application images into kind.

apps-up: backend-up frontend-up exporter-up ## Deploy all application Helm releases.

apps-down: backend-down frontend-down exporter-down ## Remove all application Helm releases.

dashboard-up: ensure-kind-context ## Apply Grafana dashboards and Loki datasource ConfigMaps.
	kubectl kustomize --load-restrictor=LoadRestrictionsNone infrastructure/kubernetes/dashboards | $(KUBECTL) apply -f -

dashboard-down: ensure-kind-context ## Remove Grafana dashboards and Loki datasource ConfigMaps.
	kubectl kustomize --load-restrictor=LoadRestrictionsNone infrastructure/kubernetes/dashboards | $(KUBECTL) delete --ignore-not-found=true -f -

alerts-up: ensure-kind-context ## Apply sample PrometheusRule alerts for teaching.
	kubectl kustomize infrastructure/kubernetes/alerts | $(KUBECTL) apply -f -

alerts-down: ensure-kind-context ## Remove sample PrometheusRule alerts.
	kubectl kustomize infrastructure/kubernetes/alerts | $(KUBECTL) delete --ignore-not-found=true -f -

grafana-port-forward: ensure-kind-context ## Port-forward local Grafana to localhost:$(GRAFANA_PORT).
	./scripts/port-forward-grafana.sh

prometheus-port-forward: ensure-kind-context ## Port-forward Prometheus to localhost:$(PROMETHEUS_PORT).
	$(KUBECTL) -n monitoring port-forward svc/kube-prometheus-stack-prometheus "$(PROMETHEUS_PORT):9090"

alertmanager-port-forward: ensure-kind-context ## Port-forward Alertmanager to localhost:$(ALERTMANAGER_PORT).
	$(KUBECTL) -n monitoring port-forward svc/kube-prometheus-stack-alertmanager "$(ALERTMANAGER_PORT):9093"

adminer-port-forward: ensure-kind-context ## Port-forward Adminer to localhost:$(ADMINER_PORT).
	$(KUBECTL) -n "$(DATA_NAMESPACE)" port-forward svc/adminer "$(ADMINER_PORT):8080"

vault-ui: ensure-kind-context ## Port-forward Vault API/UI to localhost:$(VAULT_PORT).
	$(KUBECTL) -n vault port-forward svc/vault "$(VAULT_PORT):8200"

status: ensure-kind-context ## Show core lab resources.
	$(KUBECTL) get nodes
	$(KUBECTL) -n monitoring get pods,svc
	-$(KUBECTL) -n logging get pods,svc,ds
	-$(KUBECTL) -n "$(DATA_NAMESPACE)" get pods,svc
	-$(KUBECTL) -n vault get pods,svc
	-$(KUBECTL) -n "$(APPS_NAMESPACE)" get pods,svc

clean: ## Delete the local lab cluster.
	$(MAKE) kind-down
