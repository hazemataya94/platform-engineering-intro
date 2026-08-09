import logging
import os
import random
import time
from pathlib import Path
from typing import Any

from fastapi import FastAPI, HTTPException, Request, Response
from prometheus_client import CONTENT_TYPE_LATEST, Counter, Gauge, Histogram, generate_latest
import uvicorn


logging.basicConfig(
    level=os.getenv("LOG_LEVEL", "INFO"),
    format="%(asctime)s %(levelname)s %(name)s %(message)s",
)
logger = logging.getLogger("platform.sample_backend")

REQUEST_COUNT = Counter(
    "platform_http_requests_total",
    "Total HTTP requests handled by the sample backend.",
    ["method", "endpoint", "status"],
)
REQUEST_LATENCY = Histogram(
    "platform_http_request_duration_seconds",
    "HTTP request duration for the sample backend.",
    ["method", "endpoint"],
    buckets=(0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1.0, 2.5),
)
IN_PROGRESS = Gauge(
    "platform_http_requests_in_progress",
    "HTTP requests currently in progress.",
)
BUSINESS_EVENTS = Counter(
    "platform_business_events_total",
    "Synthetic business events produced by the sample backend.",
    ["event_type"],
)
SECRET_PRESENT = Gauge(
    "platform_vault_app_secret_present",
    "Whether the Vault-injected application secret file is present.",
)

APP_SECRET_FILE = Path(os.getenv("APP_SECRET_FILE", "/vault/secrets/api_token"))
REQUIRE_APP_SECRET = os.getenv("REQUIRE_APP_SECRET", "true").lower() in {"1", "true", "yes"}

app = FastAPI(title="platform-engineering-sample-backend")


def _load_app_secret() -> str | None:
    if not APP_SECRET_FILE.exists():
        SECRET_PRESENT.set(0)
        return None
    value = APP_SECRET_FILE.read_text(encoding="utf-8").strip()
    SECRET_PRESENT.set(1 if value else 0)
    return value or None


@app.on_event("startup")
def startup() -> None:
    secret = _load_app_secret()
    if secret is None:
        message = f"Vault-injected app secret missing at {APP_SECRET_FILE}"
        if REQUIRE_APP_SECRET:
            logger.error(message)
            raise RuntimeError(message)
        logger.warning("%s; continuing because REQUIRE_APP_SECRET=false", message)
        return
    logger.info("vault_app_secret_loaded path=%s length=%s", APP_SECRET_FILE, len(secret))


@app.middleware("http")
async def metrics_middleware(request: Request, call_next: Any) -> Response:
    IN_PROGRESS.inc()
    start = time.perf_counter()
    status_code = 500
    try:
        response = await call_next(request)
        status_code = response.status_code
        return response
    finally:
        endpoint = request.url.path
        elapsed = time.perf_counter() - start
        REQUEST_LATENCY.labels(request.method, endpoint).observe(elapsed)
        REQUEST_COUNT.labels(request.method, endpoint, str(status_code)).inc()
        IN_PROGRESS.dec()


@app.get("/")
def index() -> dict[str, Any]:
    BUSINESS_EVENTS.labels("page_view").inc()
    secret = _load_app_secret()
    logger.info("index_requested vault_secret_present=%s", secret is not None)
    return {
        "service": "platform-engineering-sample-backend",
        "message": "Use /work for synthetic load and /metrics for Prometheus metrics.",
        "vault_app_secret_present": secret is not None,
    }


@app.get("/healthz")
def healthz() -> dict[str, str]:
    if REQUIRE_APP_SECRET and _load_app_secret() is None:
        raise HTTPException(status_code=503, detail="vault app secret not available")
    return {"status": "ok"}


@app.get("/work")
def work() -> dict[str, Any]:
    event_type = random.choice(("signup", "checkout", "search"))
    latency_seconds = random.uniform(0.02, 0.4)
    time.sleep(latency_seconds)
    BUSINESS_EVENTS.labels(event_type).inc()
    logger.info("work_completed event_type=%s latency_seconds=%.3f", event_type, latency_seconds)
    return {"status": "ok", "event_type": event_type, "latency_seconds": round(latency_seconds, 3)}


@app.get("/metrics")
def metrics() -> Response:
    return Response(content=generate_latest(), media_type=CONTENT_TYPE_LATEST)


if __name__ == "__main__":
    port = int(os.getenv("APP_PORT", "8080"))
    uvicorn.run("main:app", host="0.0.0.0", port=port, log_level="info")
