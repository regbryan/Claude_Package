---
description: Phased, evidence-based pre-ship production-readiness audit (BLOCKER/WARN/NIT) with a human checkpoint between every phase. Writes findings to the Obsidian vault, or to a reviews folder in the project if there is no vault.
argument-hint: "[path|branch] [--quick] [--phase N] [--no-legal] [--no-llm]"
---

# /app-review — Production-Readiness Audit


You are running a **pre-ship audit** of the app at: **$ARGUMENTS** (default: current repo / branch).

## Operating rules (non-negotiable)

1. **Phased, not parallel.** Run one phase at a time. **STOP at a human checkpoint between every phase** — present the phase report and wait for explicit approval ("proceed" / "next") before starting the next phase.
2. **Skill-first, CLI second. Local tools only.** No SaaS. Prefer installed local tooling (Biome, Knip, Madge, axe-core, Lighthouse, Playwright, gitleaks, osv-scanner, syft, semgrep).
3. **Findings are categorized `BLOCKER` / `WARN` / `NIT`.** Number them per phase (`B1-1`, `W1-2`, `N1-3`, …).
4. **No autonomous fixes during the review.** This is review-only. Do not change app code unless the user explicitly asks after a phase.
5. **Verification requires actual evidence** — a screenshot, test output, or real browser interaction. Never write "looks fine" or "should work."

## Modes & arguments

- **Full pipeline** (default): all applicable phases, in order, with checkpoints.
- `--quick`: condensed single-pass — run the CLI summaries for every phase, collapse to one combined report, skip manual/visual deep dives. Still categorize findings.
- `--phase N`: run only that phase.
- **Conditional phases (auto-detect, override with flags):**
  - **Phase 0 (Legal)** runs if the app collects/stores **PII** or uses third-party OAuth (Gmail, Google, etc.). Disable with `--no-legal`.
  - **Phase 4.5 (LLM/AI Safety)** runs if the app **calls an LLM** or proxies to AI. Disable with `--no-llm`.

## The pipeline

### Phase 0 — Legal & Compliance *(conditional: PII / OAuth)*
- Privacy Policy present & accurate? Terms of Service? Signup **consent capture** logged?
- Third-party OAuth policy compliance (e.g., **Google API Services User Data Policy** for Gmail scopes) — would this pass verification?
- Data retention / deletion (DSAR) path. PII inventory. Cookie/tracker consent before load.

### Phase 1 — Code & Architecture
- CLI: `tsc --noEmit` · `madge --circular` · `biome check` · `knip`. Summarize results in a table.
- Triage Biome by rule/severity; call out **real bug classes** (e.g. `useExhaustiveDependencies`, `noArrayIndexKey`, `useButtonType`) vs. style.
- Architecture & docs: `/docs`, ADRs (`/docs/adr/`), system diagram, **schema ER diagram**, per-module "why this exists" comments, public API surface, route inventory.
- **Visual artifacts MUST be served as in-app routes, NOT files in `/docs/`** — admin-gated `(dev)` group:
  - `/dev/architecture` (system architecture diagram)
  - `/dev/schema` (ER diagram, PII columns tagged)
  - `/dev/app-map` (interactive app map a non-engineer can read)
  - Customer / user flow diagram
  Missing required artifacts = **BLOCKER** for any non-trivial app.

### Phase 2 — Security
- Dependency CVEs: `osv-scanner` / `npm audit` (flag high/critical, give the one-line fix).
- Secrets: `gitleaks`. Static analysis: `semgrep` (needs WSL/Docker on Windows — note if unavailable).
- Auth boundaries, row-level security (RLS) policies, server-side secret handling (tokens never reach the client), security headers (HSTS, X-Frame-Options, CSP, Permissions-Policy), CORS, rate limiting.

### Phase 3 — UI/UX & Accessibility
- CLI: `axe-core/cli` (per route) · `lighthouse` (Perf/A11y/BP/SEO — note dev-mode skew; re-run against `build && preview` for real perf) · echo Biome a11y debt count.
- Manual screen review: viewport breakpoints (375/768/1280), color contrast (4.5:1 AA), keyboard navigation, visible focus rings, **skip-to-content** link, `<main>` landmark, heading outline (`<h1>`), `meta-viewport` must NOT disable zoom (WCAG 1.4.4).
- SEO/metadata: title, description, Open Graph, Twitter Card, canonical, `robots.txt`, `sitemap.xml`, JSON-LD.
- i18n/l10n coverage; third-party scripts loaded pre-consent (privacy + perf).
- Recommend a full **NVDA/VoiceOver** pass per release (can't be automated).

### Phase 4 — Verification
- Prove it works with **evidence**. Run the test suite + CI status. If none exist → BLOCKER (every Phase 1-3 finding regresses without a gate).
- Drive the running app (Playwright / Chrome DevTools MCP): screenshot key flows, exercise critical paths, capture console/network errors. For authed routes, log in with a seeded test account, then run `axe-playwright` per route.

### Phase 4.5 — LLM / AI Safety *(conditional: app calls an LLM)*
- Is the LLM proxy **authenticated** (not publicly callable)? Does it ship **PII to a third party** (disclosed?)? **Prompt-injection** exposure from untrusted input (e.g. incoming emails)? Cost controls / rate limits. Output handling (no raw HTML injection).

### Phase 5 — Ship Readiness
- **Observability**: error tracking, logging, monitoring/alerting (else the first sign of a bug is a user email).
- CI/CD gates, rollback plan, env/secret management, health checks, backups, runbook.

## Output (Obsidian vault if one is set up, otherwise the project folder)

If an Obsidian vault is set up, create `30 Projects/<App>-Review-<YYYY-MM-DD>/` in it. If not, create `reviews/<App>-Review-<YYYY-MM-DD>/` in the project folder. Either way it holds:
- **`Index.md`** — frontmatter `{title, date, status, branch, tags: [app-review, <app>], totals: "N BLOCKER / N WARN / N NIT"}`; a **Phase tracker table** (Phase | Status | BLOCKER | WARN | NIT | link), a **Visual artifacts checklist**, an **Executive summary** ("What's strong, don't lose this" + **Top 5 ship-blockers** in priority order), and the Operating rules reminder.
- **`phases/Phase-N-<Name>.md`** per phase — frontmatter `{phase, name, status, ran}`, a CLI summary table, detailed findings under `### BLOCKER / ### WARN / ### NIT`, and a phase report footer with counts + "Next: Phase N+1. Approve to proceed."

End the whole review with the combined totals and the prioritized top-5 ship-blockers.
