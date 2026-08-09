---
marp: true
title: Platform Engineering in Practice
description: Platform Engineering Introduction session slides
paginate: true
theme: default
---

# Platform Engineering in Practice

**Hazem Ataya**

Founder, HAPE Solutions

---

# Background

- **10+** years in software engineering
- **7+** years in leadership and management
- **2** patents at the European Patent Office
- Scaled **2** startups: Medicus AI and Innoscripta Group

---

# Hazem Ataya

- Started in computer vision with Objective-C and Swift
- Full-stack development (frontend and backend), including PHP Yii2
- C++ developer, then C++ tech lead
- DevOps team lead; also CI/CD engineer and release manager roles
- Product owner for a public cloud — built the team and delivered a proof of concept in one year
- Head of DevOps and Platform Engineering
- Founder, HAPE Solutions

---

# HAPE Solutions

Platform engineering products for software delivery

[hapesolutions.com/about](https://hapesolutions.com/about)

---

# Today's Question

> **How do we make good engineering practices easy to follow at scale?**

---

# DevOps ≠ Tools

Kubernetes, Terraform, Jenkins, GitLab CI, Prometheus, Vault…

Those tools **support** DevOps.

DevOps is a **culture** and a way of work that enables the software engineer to **own the full lifecycle** of the software product.

> **“You build it, you run it.”**
>
> Werner Vogels, CTO of Amazon (2006)

---

# Flow → Feedback → Learning

These are the **principles of DevOps** (the Three Ways).

1. **Flow** — idea to production with less friction
2. **Feedback** — know quickly what works or breaks
3. **Learning** — improve the system from what happened

Source: [The DevOps Handbook](https://www.oreilly.com/library/view/the-devops-handbook/9781098182281/) (O’Reilly)

---

# The Complexity Problem

That ownership principle is valuable.

Unnecessary cognitive load is not.

> How much a software engineer need to know before they can safely run a software product?

---

# Platform as a Product

Development teams are the users of the platform.

> What is slowing engineers down?

> What are they repeatedly asking us to do?

**Support queue → platform roadmap**

---

# Request → Capability

| Repeated request | Capability |
| --- | --- |
| Check my CPU / memory / traffic | Developer Grafana |
| Check my logs | Loki via Grafana |
| Change my deployment | Git-controlled overlays |
| Change a secret | Vault |
| Access the database | Dynamic short-lived credentials |

---

# Controlled Self-Service

Self-service ≠ unrestricted cluster access

- Git as the controlled change interface
- Vault for secrets and dynamic DB credentials
- **Terraform configures** the system
- **Vault protects** secret material

---

# Three Layers of the Platform

1. **Visibility** — Prometheus, Grafana, Loki, alerts
2. **Controlled self-service** — Git, Vault, dynamic credentials
3. **Standardization** — Helm golden paths, Terraform modules

---

# Golden Path vs Guardrail

- **Golden path** — the easy, recommended way (e.g. backend / frontend charts)
- **Guardrail** — non-negotiable safety (private DBs, no long-lived secrets in git, auditable change)

> Platform Engineering removes **unnecessary** responsibility — not ownership.

---

# Live Demo

Local `kind` lab that mirrors this story.

Pattern: **theory → runbook** for each beat.

Operator checklist: [Demo Guide](../demo-guide.md)

Commands live in the runbooks — not on these slides.

---

# Takeaways

1. Start with developer problems, not platform tools
2. Repeated requests are signals
3. Self-service needs boundaries
4. Standardize repeated engineering decisions
5. Encode security into the path

---

# Discussion

1. What is the most annoying repeated step between writing code and production?
2. What do developers currently need to ask another team to do?
3. Which rule exists only as documentation, but could become automation?

**Framework:** Does it repeat? → Standardize? → Automate? → Self-service? → What guardrails?

---

# Thank You

Stay connected

[linkedin.com/in/hazem-ataya-29849b151](https://www.linkedin.com/in/hazem-ataya-29849b151/)

Scan the QR in the HTML deck (`assets/linkedin-qr.png`), or open the link above.
