# Git As A Platform Interface

## Purpose

Explain why Git is part of the platform, not only a source-control tool.

## Teaching Point

Self-service does not mean every engineer has unrestricted cluster write access.

Git is the controlled interface:

1. Engineer proposes a change.
2. Review creates shared history.
3. Overlay values customize golden-path charts.
4. Automation or someone with deployment access applies the change.

## Lab Mapping

| Idea | Path |
| --- | --- |
| Example pipeline | `cicd/pipelines/.gitlab-ci.example.yml` |
| Overlay values | `cicd/deployment-config/` |
| Golden-path charts | `charts/backend`, `charts/frontend` |

## Why Overlays

Charts encode the reusable shape.

Overlay values encode the team-specific knobs (replicas, resources).

That split keeps standardization without freezing every team into identical settings.

## CI Role In This Lab

The GitLab example validates Helm templates and shows overlay contents.

It is an example for learning.

It is not required to run for the live demo.
