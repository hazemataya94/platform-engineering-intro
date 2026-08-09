# Presentation

Slides and speaker notes for the Platform Engineering Introduction session.

## Files

| File | Role |
| --- | --- |
| [slides.html](slides.html) | Reveal.js deck (HAPE light theme) — preferred for presenting |
| [hape-reveal-light.css](hape-reveal-light.css) | HAPE light design tokens and slide chrome |
| [assets/hape-logo-light.png](assets/hape-logo-light.png) | Light-theme logo (from public website) |
| [assets/linkedin-qr.png](assets/linkedin-qr.png) | QR code to LinkedIn (Thank you slide) |
| [slides.md](slides.md) | Marp Markdown deck (content twin; visual parity optional) |
| [session-draft.md](session-draft.md) | Full speaker script (not the projector deck) |

## Design

- Light theme only, aligned with [hapesolutions.com](https://hapesolutions.com) and the shared HAPE design system.
- Teal headings, muted supporting text, orange used sparingly for emphasis.
- Product accents on the four-products slide: Framework (teal) → Academy (magenta) → IaC (indigo) → Vibes (orange).
- Logo appears on every slide (fixed corner). Clicking it opens [hapesolutions.com](https://hapesolutions.com).

## How To Present

### Reveal.js (HTML)

```bash
cd /Users/hazem/workspace/hape/hape-academy/sessions/platform-engineering-intro/docs/presentation
open slides.html
```

Use arrow keys or space to advance. Links to theory and runbooks are relative to this folder.

### Marp (Markdown)

1. Install the Marp VS Code / Cursor extension, or use the Marp CLI.
2. Open `slides.md` and start Marp preview / present mode.
3. Optional export from the repository root:

```bash
npx @marp-team/marp-cli docs/presentation/slides.md -o docs/presentation/slides.pdf
```

## Live Demo Flow

After the talk framing slides, the deck has six demo beats.

Each beat points at:

1. A fundamentals theory page
2. The matching runbook

Follow [Demo Guide](../demo-guide.md) as the operator checklist. Keep commands in the runbooks, not on the slides.

## Session Timing (Suggested)

1. Intro (you, HAPE, four products)
2. Talk framing and case-study story
3. Six demo beats (theory → lab)
4. Takeaways and discussion
