# Golden Paths Intro

## Purpose

Explain golden paths as opinionated defaults that make the good way the easy way.

## Main Idea

A golden path does not pretend every workload is identical.

It standardizes the repeated decisions that every team would otherwise reinvent.

## Lab Connection

- `charts/backend` encodes a FastAPI backend deployment path.
- `charts/frontend` encodes a React frontend deployment path.
- Both charts include probes, resources, labels, and service wiring by default.
- The backend and exporter charts also expose ServiceMonitor hooks for metrics.

## Takeaway

Standardize where standardization creates value. Preserve choice where workloads legitimately differ.

## Next

Continue with [Runbook 02 — Helm Golden Path](../runbooks/02-helm-golden-path.md).
