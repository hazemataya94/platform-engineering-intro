# Demo Guide

Primary learning path for the Platform Engineering Introduction lab.

Pattern: **theory → lab → theory → lab**.

Run all lab commands from the repository root.

## Key Message

Platform Engineering makes good practices easy to follow at scale.

It removes unnecessary responsibility from developers without removing ownership.

## How To Use This Guide

1. Read the theory page for the beat.
2. Complete the matching runbook.
3. Move to the next theory page.
4. Keep going until beat 6.

Supporting libraries (same content, not a second path):

- [Fundamentals index](fundamentals/README.md)
- [Runbooks index](runbooks/README.md)
- [Architecture](architecture.md)

---

## Beat 1 — Visibility

**Theory:** [Visibility As A Platform Capability](fundamentals/01-visibility-as-platform-capability.md)

**Lab:** [Runbook 01 — Bring Up Demo](runbooks/01-bring-up-demo.md)

Talking point after the lab:

> Visibility is the first platform layer.

---

## Beat 2 — Golden Paths

**Theory:** [Golden Paths Intro](fundamentals/02-golden-paths-intro.md)

**Lab:** [Runbook 02 — Helm Golden Path](runbooks/02-helm-golden-path.md)

Talking point after the lab:

> Teams do not redesign deployment for every Python backend or React frontend.

---

## Beat 3 — Observability Self-Service

**Theory:** [Observability Self-Service](fundamentals/03-observability-self-service.md)

**Lab:** [Runbook 03 — Observability Self-Service](runbooks/03-observability-self-service.md)

Talking points after the lab:

> Developers investigate metrics and logs themselves.
>
> Repeated support requests are product signals for the platform team.

---

## Beat 4 — Secure Self-Service

**Theory:** [Secure Self-Service](fundamentals/04-secure-self-service.md)

**Lab:** [Runbook 04 — Vault And Dynamic Credentials](runbooks/04-vault-and-dynamic-credentials.md)

Talking points after the lab:

> Terraform configures Vault. Vault protects secret material.
>
> Dynamic database credentials expire automatically. This lab uses a 1-hour TTL.
>
> The backend receives its application secret through Vault Agent Injector.

---

## Beat 5 — Git As Controlled Interface

**Theory:** [Git As A Platform Interface](fundamentals/05-git-as-platform-interface.md)

**Lab:** [Runbook 05 — Git-Controlled Changes](runbooks/05-git-controlled-changes.md)

Talking points after the lab:

> Self-service is not unrestricted cluster access.
>
> Git change → reviewable history → overlay on golden-path charts → cluster change.

---

## Beat 6 — Feedback Loops

**Theory:** [Feedback Loops And Alerts](fundamentals/06-feedback-loops-and-alerts.md)

**Lab:** [Runbook 06 — Sample Alerts](runbooks/06-sample-alerts.md)

Talking point after the lab:

> Alerts close the feedback loop for availability and support-signal spikes.

---

## Discussion Prompts

1. What is the most annoying repeated step between writing code and running it in production?
2. What do developers currently need to ask another team to do for them?
3. Which engineering or security rule exists only as documentation today, but could become automation?

## Cleanup

```bash
make clean
```
