# Sample Backend

FastAPI service used by the Platform Engineering Introduction lab.

## Endpoints

- `GET /healthz` — liveness/readiness probe target; fails closed if Vault secret is required and missing
- `GET /work` — synthetic latency and business events
- `GET /metrics` — Prometheus metrics
- `GET /` — service metadata, including whether the Vault app secret is present

## Vault Agent Injector

When deployed through `charts/backend` with Vault enabled, the Agent Injector renders:

`/vault/secrets/api_token`

The process reads that file and refuses to become ready when `REQUIRE_APP_SECRET=true`.

## Local run

```bash
pip install -r requirements.txt
REQUIRE_APP_SECRET=false python src/main.py
```

## Container

```bash
docker build -t platform-engineering-sample-backend:local .
```
