# Operating Conventions

The rules Claude follows on every project. This file lives at `~/.claude/CLAUDE.md`. Edit it freely: it is yours.

## Core rules

- **Visual review is required.** When changing anything a user can see, take a screenshot, look at it, and write a real critique before claiming it's done. No "looks fine" without proof.
- **No autonomous shipping.** Never push code, send an email, post to social, or deploy a site without explicit approval of that specific action.
- **Evidence-based verification.** "It works" requires a screenshot, test output, or a live demo, not just "tests passed."
- **Standard review process.** Before anything ships, run `/app-review`: a phased quality check covering code, security, design, verification and ship-readiness.

## Defaults

- **Layout:** wide-screen ready by default; don't cap page width at the old 1280px.
- **New-project tooling stack** (all local, free): Biome (lint + format), Knip (dead code), Madge (circular deps), axe-core (a11y), Lighthouse CI (perf/a11y/SEO budgets), size-limit (bundle budgets), Lefthook (git hooks), Playwright (E2E + visual regression).
- **Security tooling** (install with winget when needed): gitleaks (secret scanning), osv-scanner (dependency CVEs), syft (SBOM).

## Looking at pages and taking screenshots

- **To look at a page** (check a screen, read a list or a form, visual review): use the built-in browser pane. Prefer reading the page over a screenshot when checking text or values.
- **To get the picture as a file** (for a Word document, an email, or evidence): drive headless Chrome with Playwright and save PNGs. Use `chromium.launch({ channel: "chrome" })` so it uses the installed Chrome.
- **Check your own work:** render finished documents to PDF, look at the pages, fix what you see, then say it is done.

## Apex review rule (Salesforce)

Delete this section if you don't work in Salesforce. Any Apex that gets written or changed is reviewed before it is deployed anywhere a client can see it:

1. **Run Salesforce Code Analyzer first** on the changed classes: `sf code-analyzer run --workspace <classes> --rule-selector Recommended --view detail`. High findings block the deploy; fix or suppress with `@SuppressWarnings('PMD.<Rule>')` plus a comment saying why.
2. **Security by hand:** sharing keyword chosen on purpose; SOQL and DML in user mode unless a comment says why system mode; static SOQL or bound variables, never concatenation; review starts at `@AuraEnabled` and other entry points; Named Credentials, no secrets, no hard-coded IDs.
3. **Bulk and limits:** nothing queries or writes inside a loop; code handles 200 records; queries are selective.
4. **Tests assert outcomes** with messages, cover the bad paths, use `runAs` for permissions, no `SeeAllData`. Every class stays above 75 percent.
5. **Before cutting a package:** analyzer clean of High findings, all tests pass in the dev org, behavior verified in a browser, README version note, zip rebuilt.

## Environment

- Each project has its own folder under `Documents`. Open Claude in that project's folder, and save deliverables and working files there by default.
- Code projects live in `~/dev`.
