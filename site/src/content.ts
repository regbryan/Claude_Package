// Shared content for all variant pages (HashiCorp / Linear / Ferrari).
// Layer colors are remapped per-variant in each page file.

export const stats = [
  { n: "165+", l: "Specialist subagents" },
  { n: "130+", l: "Workflow skills" },
  { n: "20+",  l: "Live connectors" },
  { n: "3",    l: "Plugin marketplaces" },
  { n: "100+", l: "Hermes (parallel) skills" },
];

export const layers = [
  { id: "01", t: "Operating conventions", d: "Visual-review discipline, evidence-based verification, no-surprise-deploy rules, sensible layout defaults, applied to every project." },
  { id: "02", t: "Connectors",            d: "Live two-way OAuth links to the tools you already use. Read, write, and act inside Gmail, Obsidian, HubSpot, Figma, Vercel, Supabase, and more." },
  { id: "03", t: "Plugins",               d: "Capability bundles from three marketplaces: official Anthropic, claude-mem (persistent memory), claude-ads (paid media practice)." },
  { id: "04", t: "Skills",                d: "130+ specialized workflows invoked automatically based on the request. From app reviews to brand systems to financial research." },
  { id: "05", t: "Subagents",             d: "165+ specialist personas. A domain expert exists for almost any task you can name. Claude routes to them with no setup." },
  { id: "06", t: "Slash commands",        d: "Single-line shortcuts for multi-step jobs: quality reviews, knowledge graphs, scheduled work, interface design audits." },
  { id: "07", t: "Hermes",                d: "A parallel Python-based agent for autonomous, scheduled, and background work. Runs alongside Claude Code, shares your filesystem." },
];

export const connectors = [
  { group: "Communication & schedule", items: [
    { n: "Gmail",            url: "https://mail.google.com" },
    { n: "Google Calendar",  url: "https://calendar.google.com" },
    { n: "Granola",          url: "https://granola.ai" },
    { n: "Slack",            url: "https://slack.com" },
  ]},
  { group: "Knowledge & files", items: [
    { n: "Obsidian (the brain)", url: "https://obsidian.md" },
    { n: "Box",                  url: "https://box.com" },
    { n: "PDF Viewer",           url: null as string | null },
  ]},
  { group: "Sales & CRM", items: [
    { n: "HubSpot", url: "https://hubspot.com" },
    { n: "Apollo",  url: "https://apollo.io" },
  ]},
  { group: "Design & creative", items: [
    { n: "Canva",                  url: "https://canva.com" },
    { n: "Figma",                  url: "https://figma.com" },
    { n: "Stitch (Google)",        url: "https://stitch.withgoogle.com" },
    { n: "nanobanana (image gen)", url: null },
    { n: "Higgsfield (video gen)", url: "https://higgsfield.ai" },
    { n: "Adobe Creative Suite",   url: "https://adobe.com" },
  ]},
  { group: "Marketing & content", items: [
    { n: "Selr / Marketing Studio", url: null },
    { n: "Postiz",                  url: "https://postiz.com" },
    { n: "Firecrawl",               url: "https://firecrawl.dev" },
  ]},
  { group: "Web & dev infrastructure", items: [
    { n: "Chrome DevTools",  url: "https://github.com/ChromeDevTools/chrome-devtools-mcp" },
    { n: "Cloudflare",       url: "https://cloudflare.com" },
    { n: "Supabase",         url: "https://supabase.com" },
    { n: "Vercel",           url: "https://vercel.com" },
    { n: "autograph",        url: null },
    { n: "MCP Registry",     url: null },
  ]},
  { group: "Research & intelligence", items: [
    { n: "Bigdata.com (finance)", url: "https://bigdata.com" },
  ]},
  { group: "Automation & memory", items: [
    { n: "claude-mem",       url: "https://github.com/thedotmack/claude-mem" },
    { n: "scheduled-tasks",  url: null },
    { n: "Session archive",  url: null },
  ]},
];

export const plugins = [
  { n: "Marketplace 01", t: "Anthropic Official", repo: "anthropics/claude-plugins-official", url: "https://github.com/anthropics/claude-plugins-official", note: "14 plugins. Every Anthropic-curated capability bundle worth installing.", items: ["superpowers", "claude-code-setup", "code-review · code-simplifier", "security-guidance", "frontend-design", "figma", "github", "supabase", "chrome-devtools-mcp", "firecrawl", "data", "typescript-lsp", "atomic-agents", "autofix-bot", "claude-md-management"] },
  { n: "Marketplace 02", t: "claude-mem (Memory)", repo: "thedotmack/claude-mem", url: "https://github.com/thedotmack/claude-mem", note: "Persistent cross-session memory. The stack gets smarter every time you use it.", items: ["Skill: do", "Skill: make-plan", "Skill: mem-search", "Skill: smart-explore", "Worker captures observations + session summaries"] },
  { n: "Marketplace 03", t: "claude-ads (Advertising)", repo: "AgriciDaniel/claude-ads", url: "https://github.com/AgriciDaniel/claude-ads", note: "A full paid-media practice in plugin form.", items: ["Apple · Google · Meta · LinkedIn", "Microsoft · TikTok · YouTube", "Audit · budget · creative · DNA · math", "Generate · landing · photoshoot · plan · test", "10 specialist agents · 19 sub-skills"] },
];

export const skills = [
  { t: "Pre-ship quality",       items: ["app-review", "engineering:*", "superpowers:*", "code-review", "security-review"] },
  { t: "Brand & identity",       items: ["brand", "brand-render", "brand-voice:*", "design", "design-system", "design-motion-principles"] },
  { t: "UI & frontend",          items: ["interface-design", "frontend-design", "impeccable", "ui-styling", "ui-ux-pro-max", "figma:*"] },
  { t: "Visual assets",          items: ["banner-design", "slides", "canvas-design", "theme-factory", "adobe-for-creativity:*"] },
  { t: "Video & motion",         items: ["commercial-reel", "reel-clone", "higgsfield", "ltx2", "remotion", "moviepy", "compare-video", "ffmpeg", "watch"] },
  { t: "Audio",                  items: ["elevenlabs", "acestep", "music-generator"] },
  { t: "Image generation",       items: ["nanobanana", "qwen-edit", "runpod"] },
  { t: "Marketing",              items: ["marketing:*", "postiz", "claude-ads:* (19)"] },
  { t: "Sales & revenue ops",    items: ["sales:*", "apollo:*"] },
  { t: "Customer support",       items: ["customer-support:*"] },
  { t: "Product management",     items: ["product-management:*"] },
  { t: "Finance & accounting",   items: ["finance:*"] },
  { t: "Operations",             items: ["operations:*"] },
  { t: "Data & analytics",       items: ["data:*"] },
  { t: "Knowledge & research",   items: ["graphify", "bigdata-com:* (24)", "firecrawl:*"] },
  { t: "Document & file work",   items: ["pdf", "docx", "xlsx", "pptx", "pdf-viewer:*"] },
  { t: "Slack & collaboration",  items: ["slack-by-salesforce:*"] },
  { t: "Browser & web testing",  items: ["chrome-devtools-mcp:*"] },
  { t: "Salesforce",             items: ["sf-changes"] },
  { t: "Meta · build your own",  items: ["skill-creator", "mcp-builder", "loop", "schedule", "update-config", "claude-api"] },
];

export const subagents = [
  { t: "Sales & GTM",          n: 11 },
  { t: "Marketing (global)",   n: 22 },
  { t: "Marketing (China)",    n: 11 },
  { t: "Paid media",           n: 7  },
  { t: "Design & creative",    n: 14 },
  { t: "Engineering",          n: 31 },
  { t: "Game development",     n: 15 },
  { t: "XR / spatial",         n: 6  },
  { t: "Ops · finance · PM",   n: 20 },
  { t: "Cultural advisors",    n: 10 },
  { t: "Research & academic",  n: 9  },
  { t: "Testing & QA",         n: 6  },
  { t: "Behavioral · product", n: 4  },
];

export const workflows = [
  { cat: "Marketing",         q: "Draft a launch email for the new offer, save it as a Gmail draft, prep a matching Canva post in our brand template, and schedule it to LinkedIn via Postiz next Tuesday at 9am." },
  { cat: "Paid advertising",  q: "Audit our Google Ads account, surface wasted spend, and rewrite the top 5 underperforming ads using our brand voice." },
  { cat: "Sales operations",  q: "Pull this week's new HubSpot deals over $10K, enrich each contact via Apollo, draft a follow-up sequence for each, and put a prep brief in Obsidian." },
  { cat: "Brand & design",    q: "Build a brand identity for [client]. Logo options, color system, typography, full corporate identity program with 50 mockups, three banner variants." },
  { cat: "Video",             q: "Clone this Instagram reel. Same pacing, swap the visuals via Higgsfield, write the script, generate the voiceover, render the final MP4." },
  { cat: "Web & dev",         q: "Build a landing page. Use our brand tokens, generate components from the Figma file, run the full app-review, deploy to Vercel." },
  { cat: "Meetings",          q: "Summarize yesterday's Granola call, draft a recap email, create follow-up tasks in HubSpot, Slack the team, block prep time on Friday." },
  { cat: "Research",          q: "Run a Bigdata.com investment memo on [company], pull recent news via Firecrawl, build a peer comparables table, save it as a note in Obsidian with a knowledge graph via /graphify." },
  { cat: "Finance & ops",     q: "Reconcile last month's bank statement, generate journal entries, draft variance analysis vs budget, produce the financial statements package." },
  { cat: "Obsidian-centric",  q: "Check my vault. What did I decide about [client] last month? Pull every related note, summarize the through-line, draft my next message to them." },
  { cat: "Automation",        q: "Every weekday at 7am, run my morning brief: yesterday's calendar, today's calendar, overnight inbox, top 3 priorities. Drop it in Obsidian and Slack it to me." },
];

export const installSteps = [
  { id: "01", t: "Install Claude Code",          time: "5 min",     d: "Download and sign in.", link: { t: "claude.com/claude-code", url: "https://claude.com/claude-code" } },
  { id: "02", t: "Apply operating conventions",  time: "2 min",     d: "Your CLAUDE.md rules drop into ~/.claude/. Picked up automatically.", link: null },
  { id: "03", t: "Add plugin marketplaces",      time: "5 min",     d: "Three repos registered.", link: { t: "claude-plugins-official", url: "https://github.com/anthropics/claude-plugins-official" } },
  { id: "04", t: "Enable plugins",               time: "5 min",     d: "14 from official, claude-mem, claude-ads.", link: null },
  { id: "05", t: "Install skills",               time: "10 min",    d: "130+ skills copied to ~/.claude/skills/.", link: null },
  { id: "06", t: "Install subagents",            time: "5 min",     d: "165+ specialist personas dropped into ~/.claude/agents/.", link: null },
  { id: "07", t: "Connect your tools",           time: "20–30 min", d: "Each connector: click Sign in, authorize via OAuth. Done with you on a call.", link: null },
  { id: "08", t: "Install Hermes (optional)",    time: "10 min",    d: "Python parallel agent for autonomous and scheduled work.", link: null },
  { id: "09", t: "Install system tooling",       time: "5 min",     d: "gitleaks, osv-scanner, syft, semgrep via winget or brew.", link: { t: "semgrep.dev", url: "https://semgrep.dev" } },
  { id: "10", t: "Test drive",                   time: "10–15 min", d: "We run real requests together so you see the stack work end-to-end.", link: null },
];

export const sysTools = [
  { n: "gitleaks",      url: "https://github.com/gitleaks/gitleaks",          d: "Secret detection" },
  { n: "osv-scanner",   url: "https://google.github.io/osv-scanner/",         d: "Dependency CVE scanner" },
  { n: "syft",          url: "https://github.com/anchore/syft",               d: "Software bill of materials" },
  { n: "semgrep",       url: "https://semgrep.dev",                           d: "Static analysis security scanner" },
  { n: "Biome",         url: "https://biomejs.dev",                           d: "Lint + format" },
  { n: "Knip",          url: "https://knip.dev",                              d: "Dead code detection" },
  { n: "Madge",         url: "https://github.com/pahen/madge",                d: "Circular dependency detection" },
  { n: "axe-core",      url: "https://github.com/dequelabs/axe-core",         d: "Accessibility" },
  { n: "Lighthouse CI", url: "https://github.com/GoogleChrome/lighthouse-ci", d: "Perf, a11y, SEO budgets" },
  { n: "size-limit",    url: "https://github.com/ai/size-limit",              d: "Bundle size budgets" },
  { n: "Lefthook",      url: "https://github.com/evilmartians/lefthook",      d: "Git hooks" },
  { n: "Playwright",    url: "https://playwright.dev",                        d: "E2E + visual regression" },
];
