# Support Metrics Exporter

Synthetic exporter that emits `platform_support_requests_total{type=...}` for the lab narrative:

> Repeated support requests become platform roadmap signals.

## Metric types

- `resources`
- `logs`
- `deployment`
- `secrets`
- `database_access`

## Local run

```bash
pip install -r requirements.txt
python src/main.py
```
