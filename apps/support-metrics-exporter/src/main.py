import logging
import os
import threading
import time
from typing import Any

from fastapi import FastAPI, Response
from prometheus_client import CONTENT_TYPE_LATEST, Counter, generate_latest
import uvicorn


logging.basicConfig(
    level=os.getenv("LOG_LEVEL", "INFO"),
    format="%(asctime)s %(levelname)s %(name)s %(message)s",
)
logger = logging.getLogger("platform.support_metrics_exporter")

SUPPORT_REQUESTS = Counter(
    "platform_support_requests_total",
    "Synthetic platform support requests used to teach roadmap discovery.",
    ["type"],
)

REQUEST_TYPES = (
    "resources",
    "logs",
    "deployment",
    "secrets",
    "database_access",
)

app = FastAPI(title="platform-engineering-support-metrics-exporter")
_stop_event = threading.Event()


def _emit_synthetic_requests() -> None:
    interval_seconds = float(os.getenv("EMIT_INTERVAL_SECONDS", "15"))
    while not _stop_event.is_set():
        for request_type in REQUEST_TYPES:
            SUPPORT_REQUESTS.labels(request_type).inc()
        logger.info("emitted_synthetic_support_requests types=%s", ",".join(REQUEST_TYPES))
        _stop_event.wait(interval_seconds)


@app.on_event("startup")
def startup() -> None:
    worker = threading.Thread(target=_emit_synthetic_requests, name="support-emitter", daemon=True)
    worker.start()
    logger.info("support_metrics_exporter_started")


@app.get("/healthz")
def healthz() -> dict[str, str]:
    return {"status": "ok"}


@app.get("/")
def index() -> dict[str, Any]:
    return {
        "service": "platform-engineering-support-metrics-exporter",
        "metric": "platform_support_requests_total",
        "types": list(REQUEST_TYPES),
    }


@app.get("/metrics")
def metrics() -> Response:
    return Response(content=generate_latest(), media_type=CONTENT_TYPE_LATEST)


if __name__ == "__main__":
    port = int(os.getenv("APP_PORT", "8080"))
    uvicorn.run(app, host="0.0.0.0", port=port, log_level="info")
