# Your Claude Code Setup

This is the AI workstation I install for clients. It turns Claude Code (Anthropic's CLI assistant) into a multi-purpose operator that can run your marketing, sales, design, video, engineering, operations, finance, and knowledge work. All from one place, all on your machine, all working with the tools you already use.

This guide explains **what's in the setup, what it does for you, and how to install it.** You do not need to be technical to follow it.

---

## 1. What you're getting

Out of the box, Claude Code is a smart assistant in a terminal. What I add on top is the difference between "smart assistant" and "operator who can actually do the work."

The setup is built in seven layers:

| Layer | What it does |
|---|---|
| **Operating conventions** | The rules Claude follows on every project: visual review, evidence-based verification, no surprise deploys |
| **Connectors (MCP servers)** | Live two-way links into your tools: Gmail, Calendar, HubSpot, Canva, Figma, Obsidian, Box, Cloudflare, Vercel, Supabase, and more |
| **Plugins** | Pre-built capability bundles installed from three marketplaces (Anthropic official, claude-mem, claude-ads) |
| **Skills** | 130+ specialized workflows that Claude invokes automatically based on what you ask |
| **Subagents** | 165+ specialist personas. Every business function has a domain expert |
| **Slash commands** | One-line shortcuts for common multi-step jobs |
| **Hermes (parallel agent)** | A separate Python-based agent that runs autonomous and scheduled work alongside Claude Code |

The result: instead of switching between ChatGPT, Canva, Figma, HubSpot, your email, your CRM, and a dozen other apps all day, you tell Claude what you want and it works across them.

### Obsidian is the brain of the operation

One connector deserves a callout up front. **Obsidian is your second brain and the system of record for the entire setup.** Every Claude session gets auto-logged to your Obsidian vault. Every brief, recap, research note, meeting summary, daily standup, and project plan lands there. When Claude needs to remember something from last week, it searches your vault. When you want to know what got done, it's already written down.

If you've never used Obsidian, it's a local Markdown notes app. Your notes live on your machine as plain text files, not in someone else's cloud. The setup turns it into the persistent memory layer that ties everything else together.

---

## 2. Prerequisites

Before installing the setup, you need:

1. **A Claude account** at [claude.ai](https://claude.ai). Pro or Max plan recommended.
2. **Claude Code installed**. Download from [claude.com/claude-code](https://claude.com/claude-code) (Mac, Windows, or web).
3. **A login for each tool you want connected** (Gmail, HubSpot, Canva, etc.). You'll sign in to each one once during setup.
4. **About 60–90 minutes** for the first install. The install itself is mostly automated; logins are the slow part.

That's it. No coding background required.

---

## 3. The Setup

### 3.1 Operating Conventions

These are the rules Claude follows on every project. They live in a file called `CLAUDE.md` that loads automatically every session.

The big ones:

- **Visual review is required.** When Claude changes something a user can see, it must take a screenshot, look at it, and write a real critique before claiming it's done. No "looks fine" without proof.
- **No autonomous shipping.** Claude will never push code, send an email, post a social, or deploy a site without you explicitly approving that specific action.
- **Evidence-based verification.** Claims of "it works" require a screenshot, test output, or live demo, not just "tests passed."
- **Standard review process.** Before anything ships, `/app-review` runs a 5-phase quality check: code → security → design → verification → ship-readiness.
- **Sensible layout defaults** for any website or web app. Wide-screen ready, not capped at the old 1280px width that looks broken on modern monitors.
- **Default tooling stack** for new projects (Biome, Knip, Madge, axe-core, Lighthouse CI, size-limit, Lefthook, Playwright). All local, all free, no SaaS lock-in.

You don't have to think about these. They just happen.

### 3.2 Connectors (MCP Servers)

Live two-way links between Claude and your tools. Sign in once per connector and Claude can read, write, and act inside that tool.

**Communication & schedule**
- **Gmail**: read threads, draft replies, manage labels, search inbox, file by topic
- **Google Calendar**: list events, schedule, suggest times, send invites, respond to invites
- **Granola**: pull meeting transcripts and summaries
- **Slack**: channel digests, draft announcements, find discussions, standups

**Knowledge & files**
- **Obsidian** *(the brain of the setup)*: read, write, search, tag, and patch any note in your vault. Open files, read active file paths, list daily notes, run Obsidian commands, list tags, get the full vault document map. **Every Claude session ends with an automatic Obsidian log entry** (via the `obsidian-session-log.sh` hook in `~/.claude/hooks/`), so the vault is a continuous record of what got done, decided, and discussed. Hermes also reads and writes Obsidian for autonomous and scheduled work, so morning briefs, weekly reviews, and recurring research land there too.
- **Box**: search, read, organize folders; manage metadata templates
- **PDF Viewer**: open, annotate, fill, sign PDFs interactively

**Sales & CRM**
- **HubSpot**: query and update contacts, deals, companies, campaigns, owners
- **Apollo**: enrich leads, run sequence loads, prospect at scale

**Design & creative**
- **Canva**: create designs from brand templates, export, comment, search folders, merge designs
- **Figma**: read designs, generate code from components, search design systems, manage Code Connect mappings
- **Stitch**: generate full UI screens and design systems from a brief
- **nanobanana**: AI image generation and editing (Gemini 3 Flash Image / Pro Image)
- **Higgsfield**: AI video generation (Kling, Sora 2, Veo, Wan, Seedance, Minimax, etc.)
- **Adobe Creative Suite**: Photoshop / Premiere / Lightroom workflows (batch edit, retouch, resize, social variations, quick cuts)

**Marketing & content**
- **Selr / Marketing Studio**: AI video clipping, virality prediction, character consistency, content workflows
- **Postiz**: multi-platform social media scheduling
- **Firecrawl**: clean, LLM-optimized web scraping and research (replaces basic web tools)

**Web & dev infrastructure**
- **Chrome DevTools**: drive a real browser for testing, screenshots, network/console inspection, accessibility audits, Lighthouse audits, performance traces
- **Cloudflare**: manage domains, Workers, KV, D1, R2, Hyperdrive
- **Supabase**: query databases, run migrations, manage projects and branches, deploy edge functions
- **Vercel**: deploy sites, view runtime logs, manage projects, check deployments
- **autograph**: call into your own running code from Claude
- **MCP Registry**: discover and suggest new connectors

**Research & financial intelligence**
- **Bigdata.com**: financial research analyst (24 different deep-research workflows: company briefs, earnings analysis, valuation, peer comparison, sector analysis, country analysis, risk assessment, etc.)

**Automation & memory**
- **claude-mem**: persistent memory across sessions (powered by the thedotmack/claude-mem plugin)
- **scheduled-tasks**: create, update, list, run scheduled remote agents
- **ccd_session_mgmt**: archive, list, and search session transcripts

You don't need all of these. We turn on the ones you actually use.

### 3.3 Plugins

Plugins are bundles of related capabilities. They install from three marketplaces:

**From the official Anthropic marketplace (`claude-plugins-official`)**
- **superpowers**: Disciplined workflows. Brainstorming, planning, debugging, TDD, code review, parallel agent dispatch, plan execution, git worktrees.
- **claude-code-setup**: Recommends automations based on how you actually use Claude.
- **code-review** + **code-simplifier**: Two-pass quality checks for any code Claude writes.
- **security-guidance**: Reviews for common security mistakes before code ships.
- **frontend-design**: Production-grade UI generation that avoids generic AI-looking output.
- **figma**: Implement Figma designs as production code with 1:1 fidelity.
- **github**: Issues, pull requests, repo operations.
- **supabase**: Database and backend operations.
- **chrome-devtools-mcp**: Browser automation, accessibility debugging, LCP optimization, performance traces.
- **firecrawl**: Web scraping, research, search that returns clean data.
- **data**: Analyze data, build dashboards, run SQL, statistical analysis, data visualization.
- **typescript-lsp**: Smart code intelligence for TypeScript projects.
- **atomic-agents**: Lightweight agent composition patterns.
- **autofix-bot**: Automatic bug fixing from CI failures.
- **claude-md-management**: Keep your project's CLAUDE.md rules up to date.

**From `thedotmack/claude-mem` marketplace**
- **claude-mem**: Persistent memory system. Auto-installs and manages a worker service that captures observations, session summaries, and context across all your Claude sessions. Includes skills `do`, `make-plan`, `mem-search`, `smart-explore`.

**From `AgriciDaniel/claude-ads` marketplace**
- **claude-ads**: Comprehensive paid advertising platform. Includes 19 sub-skills for Apple, Google, Meta, LinkedIn, Microsoft, TikTok, and YouTube ads, plus auditing, budgeting, competitor analysis, creative strategy, DNA analysis, generation, landing pages, math and forecasting, photoshoots, planning, and testing. Backed by 10 specialist agents (audit-budget, audit-compliance, audit-creative, audit-google, audit-meta, audit-tracking, copy-writer, creative-strategist, format-adapter, visual-designer).

### 3.4 Skills

Skills are specialized workflows Claude invokes automatically when relevant. There are 130+ in total. Here's the inventory organized by what they do.

#### Pre-ship quality & engineering
- **app-review**: Five-phase production-readiness review (code → security → UI/UX → a11y → performance → LLM safety → verification → ship)
- **engineering:***: Architecture, code review, debug, deploy checklist, standup, system design, documentation, tech debt, incident response, testing strategy
- **superpowers:***: Brainstorming, writing plans, executing plans, TDD, systematic debugging, finishing branches, parallel agent dispatch, requesting and receiving code review, verification-before-completion, using git worktrees, skill authoring
- **review** / **security-review** / **code-review:code-review**: Pull request review variants

#### Brand & design system
- **brand**: Brand voice, visual identity, messaging frameworks, asset management, brand-guideline templates
- **brand-render**: Multi-brand asset generation with strict brand-discipline enforcement (used for clients with multiple brands)
- **brand-voice:***: Discover brand voice, generate guidelines, enforce voice on outgoing content
- **design**: End-to-end design routing (logos, full corporate identity programs with 50 deliverables, mockups, banners, icons, social photos, slides)
- **design-system**: Token architecture (primitive → semantic → component), CSS variables, component specs, brand-compliant slides
- **design-motion-principles**: Motion design audit grounded in Emil Kowalski / Jakub Krehel / Jhey Tompkins frameworks
- **design:***: Design critique, accessibility review, design handoff, UX copy, research synthesis, user research

#### UI & frontend
- **interface-design**: Dashboards, admin panels, app interfaces
- **frontend-design**: Distinctive, production-grade web interfaces
- **impeccable**: UI design critique, polish, iterative improvement
- **ui-styling**: shadcn/ui + Tailwind components and themes
- **ui-ux-pro-max**: Comprehensive UI/UX intelligence (50+ styles, 161 palettes, 57 font pairings, 161 product types, 99 UX guidelines, 25 chart types, 10 stacks)
- **figma:***: Implement Figma design (1:1 code translation), Code Connect, design system rules

#### Visual asset generation
- **banner-design**: 22 styles across social, ads, web heroes, print
- **slides**: Strategic HTML presentations with Chart.js, design tokens, copywriting formulas
- **anthropic-skills:canvas-design**: Canvas-based visual design
- **anthropic-skills:theme-factory**: Generate full theme systems
- **adobe-for-creativity:***: Design from template, quick cuts, batch photo edits, social variations, portrait retouching, resize

#### Video & motion
- **commercial-reel**: Landscape commercial video ads (30–60s) with real footage and overlays via Higgsfield/LTX-2 plus Remotion
- **reel-clone**: Replicate or adapt Instagram/TikTok reels from a reference (motion audit → scripted scenes → voiceover → sync verify → render)
- **higgsfield**: Pro-grade prompts for Higgsfield platform (Kling, Sora 2, Veo, Wan, Seedance, etc.)
- **higgsfield-connector**: One-shot OAuth setup of Higgsfield MCP + Selr templates
- **ltx2**: LTX-2.3 22B text-to-video and image-to-video
- **remotion** + **remotion-official**: Programmatic React-based video composition (custom transitions, shared components)
- **moviepy**: Python video composition for text overlays, captions, lower-thirds
- **playwright-recording**: Capture demo videos and UI walkthroughs in a real browser
- **compare-video**: Side-by-side composites, motion heatmaps, filmstrip analysis
- **ffmpeg**: Format conversion, compression, audio extraction
- **watch**: Download and analyze any video (URL or local). Frames, transcripts, content Q&A.
- **anthropic-skills:video-prompt-builder**: Seedance shot-by-shot prompt generation

#### Audio
- **elevenlabs**: Voiceovers, sound effects, music via ElevenLabs API
- **acestep**: Music generation with ACE-Step 1.5 (background music, vocals, covers, stems, repaint, continuation)
- **anthropic-skills:music-generator**: ElevenLabs Music API integration

#### Image generation & editing
- **qwen-edit**: Photo editing with identity preservation, reframing, clothing/pose/style edits
- **runpod**: Cloud GPU pipelines for advanced image/video work (qwen-edit, realesrgan, propainter, sadtalker, qwen3-tts)
- **openclaw-video-toolkit**: End-to-end autonomous video creation pipeline

#### Marketing & content
- **marketing:***: Brand review, email sequences, draft content, content creation, performance reports, campaign plans, competitive briefs, SEO audits
- **postiz**: Multi-platform social scheduling

#### Sales & revenue ops
- **sales:***: Daily briefing, pipeline review, forecast, call prep, competitive intelligence, account research, draft outreach, create assets, call summary
- **apollo:***: Enrich lead, sequence load, prospect

#### Customer support
- **customer-support:***: Customer escalation, draft response, KB article, ticket triage, customer research

#### Product management
- **product-management:***: Brainstorm, metrics review, competitive brief, write spec, sprint planning, product brainstorming, synthesize research, stakeholder update, roadmap update

#### Finance & accounting
- **finance:***: Journal entry prep, audit support, reconciliation, financial statements, variance analysis, close management, SOX testing

#### Operations
- **operations:***: Vendor review, risk assessment, process documentation, process optimization, capacity planning, runbooks, change requests, status reports, compliance tracking

#### Data & analytics
- **data:***: Analyze, write SQL, validate data, statistical analysis, visualization, dashboards, exploration, context extraction

#### Productivity & memory
- **productivity:***: Memory management, start-of-day routine, task management, status updates
- **anthropic-skills:consolidate-memory**: Memory consolidation across sessions

#### Knowledge & research
- **graphify**: Convert any input (codebase, docs, papers, images) into a navigable knowledge graph with clustering, god nodes, BFS/DFS query tools
- **bigdata-com:***: 24 institutional-grade financial research workflows (catalyst monitor, company brief, country analysis, cross-sector, earnings digest, earnings preview, earnings quality screen, earnings reaction, G7 comparison, investment memo, moat/governance review, peer comparables, quick take, regional comparison, risk assessment, scenario analysis, sector analysis, sector playbook, thematic research, valuation snapshot, variant perception)
- **firecrawl:***: Clean web research, search, and crawl

#### Document & file work
- **anthropic-skills:pdf**: Read, edit, merge, split, sign, OCR PDFs
- **anthropic-skills:docx**: Create, read, edit Word documents
- **anthropic-skills:xlsx**: Open, edit, create spreadsheets
- **anthropic-skills:pptx**: Slide decks, pitch decks, presentations
- **pdf-viewer:***: Open, view, annotate, fill, sign PDFs interactively

#### Slack & collaboration
- **slack-by-salesforce:***: Channel digests, draft announcements, find discussions, standups, summarize channels, search Slack

#### Salesforce specialists
- **sf-changes**: Interpret Salesforce release notes into client-ready summaries with action items

#### Browser & web testing
- **chrome-devtools-mcp:***: Accessibility debugging, LCP optimization, troubleshooting, full DevTools workflows

#### Meta / setup / tooling
- **anthropic-skills:skill-creator**: Build your own skills
- **anthropic-skills:mcp-builder**: Build your own MCP server
- **anthropic-skills:brand-guidelines** + **anthropic-skills:web-artifacts-builder**
- **update-config**: Configure Claude Code settings via hooks, permissions, env vars
- **keybindings-help**: Customize keyboard shortcuts
- **fewer-permission-prompts**: Auto-allowlist common safe tool calls
- **loop**: Run a prompt or command on a recurring interval
- **schedule**: Create, update, list, run scheduled remote agents
- **simplify**: Review changed code for reuse, quality, efficiency
- **init**: Project init
- **claude-api**: Build and migrate Anthropic SDK apps

### 3.5 Subagents: Your Specialist Team

In addition to skills, the install includes ~165 named subagent personas. Domain experts Claude delegates to when a task needs deep specialization. The full roster covers every business function:

**Sales & GTM specialists**
Account Strategist, Sales Coach, Deal Strategist, Discovery Coach, Sales Engineer, Pipeline Analyst, Outbound Strategist, Proposal Strategist, Sales Data Extraction Agent, Report Distribution Agent, Data Consolidation Agent

**Marketing specialists (global + China-specific)**
Content Creator, Growth Hacker, SEO Specialist, AI Citation Strategist, App Store Optimizer, Brand Guardian, Carousel Growth Engine, Instagram Curator, LinkedIn Content Creator, TikTok Strategist, Twitter Engager, Reddit Community Builder, Social Media Strategist, Trend Researcher, Whimsy Injector, Visual Storyteller, Image Prompt Engineer, Book Co-Author, Podcast Strategist, Livestream Commerce Coach, Short-Video Editing Coach, Cross-Border E-Commerce Specialist, Healthcare Marketing Compliance Specialist
Plus China-market specialists: Baidu SEO, Bilibili, Douyin, Kuaishou, Weibo, Xiaohongshu, Zhihu, WeChat Official Account, WeChat Mini Program Developer, China E-Commerce Operator, Private Domain Operator

**Paid media specialists**
Paid Media Auditor, PPC Campaign Strategist, Paid Social Strategist, Programmatic & Display Buyer, Ad Creative Strategist, Search Query Analyst, Tracking & Measurement Specialist

**Design & creative**
UI Designer, UX Architect, UX Researcher, Brand Guardian, Visual Storyteller, Whimsy Injector, Inclusive Visuals Specialist, Image Prompt Engineer, Document Generator, Technical Artist, Narrative Designer, Game Designer, Level Designer, Game Audio Engineer

**Engineering (broad)**
Backend Architect, Frontend Developer, Senior Developer, Software Architect, Rapid Prototyper, Mobile App Builder, AI Engineer, AI Data Remediation Engineer, Data Engineer, Database Optimizer, DevOps Automator, Embedded Firmware Engineer, Senior Project Manager, Code Reviewer, Security Engineer, SRE, Incident Response Commander, Threat Detection Engineer, Performance Benchmarker, Git Workflow Master, Technical Writer, MCP Builder, LSP/Index Engineer, Blockchain Security Auditor, Solidity Smart Contract Engineer, Identity Graph Operator, Agentic Identity & Trust Architect, Autonomous Optimization Architect, Compliance Auditor, Salesforce Architect, Feishu Integration Developer

**Game dev specialists** (Unity, Unreal, Godot, Roblox, Blender)
Unity Architect, Unity Editor Tool Developer, Unity Multiplayer Engineer, Unity Shader Graph Artist, Unreal Multiplayer Architect, Unreal Systems Engineer, Unreal Technical Artist, Unreal World Builder, Godot Gameplay Scripter, Godot Multiplayer Engineer, Godot Shader Developer, Roblox Avatar Creator, Roblox Experience Designer, Roblox Systems Scripter, Blender Add-on Engineer

**XR / spatial computing**
visionOS Spatial Engineer, macOS Spatial/Metal Engineer, XR Cockpit Interaction Specialist, XR Immersive Developer, XR Interface Architect, Terminal Integration Specialist

**Operations, finance, support, project management**
Studio Producer, Studio Operations, Project Shepherd, Jira Workflow Steward, Experiment Tracker, Sprint Prioritizer, Workflow Architect, Workflow Optimizer, Analytics Reporter, Finance Tracker, Accounts Payable Agent, Recruitment Specialist, Supply Chain Strategist, Corporate Training Designer, Government Digital Presales Consultant, Healthcare Marketing Compliance, Legal Compliance Checker, Infrastructure Maintainer, Support Responder, Feedback Synthesizer

**Specialized advisors & cultural intelligence**
French Consulting Market Navigator, Korean Business Navigator, Study Abroad Advisor, Cultural Intelligence Strategist, Anthropologist, Geographer, Historian, Narratologist, Psychologist, ZK Steward (Zettelkasten knowledge base)

**Research & academic personas** for deep work
Academic Anthropologist, Academic Geographer, Academic Historian, Academic Narratologist, Academic Psychologist, Executive Summary Generator, Developer Advocate, Tool Evaluator, Model QA Specialist

**Testing & QA**
Accessibility Auditor, API Tester, Evidence Collector, Reality Checker, Test Results Analyzer, Performance Benchmarker

**Behavioral & product intelligence**
Behavioral Nudge Engine, Product Manager, Trend Researcher, Feedback Synthesizer

Claude routes to these automatically. You don't pick. If you say "audit my landing page," it pulls in the right subagents (accessibility auditor + paid media creative strategist + design critique + reality checker). The handoff is invisible.

### 3.6 Slash Commands

Quick one-liners for common multi-step jobs:

**Quality & review**
- `/app-review`: Full pre-ship pipeline. Variants: `/app-review security`, `/app-review code`, `/app-review design`, `/app-review verify`, `/app-review ship`, `/app-review --quick`
- `/review`: Review a pull request
- `/security-review`: Security-focused PR review
- `/code-review` (plugin): Code review with structured plan checks

**Knowledge & research**
- `/graphify`: Convert any input into a navigable knowledge graph

**Interface design pipeline**
- `/audit`, `/critique`, `/extract`, `/init`, `/status`: Multi-stage interface design workflow

**Automation**
- `/loop <interval> <command>`: Run a prompt or command on a recurring interval
- `/schedule`: Create, update, list, run scheduled remote agents

**Setup & config**
- `/init`: Initialize a new project
- `/help`: Get help with Claude Code

Plus many more from installed plugins (each plugin can register its own commands).

### 3.7 Hermes: The Parallel Agent

Hermes is a separate Python-based agent installed alongside Claude Code that runs autonomous and scheduled work. They share your filesystem but operate independently. Useful when you want background jobs (cron tasks, recurring report generation, autonomous monitoring) that don't tie up Claude Code.

**What Hermes covers** (100+ skills across these categories):

- **Apple ecosystem**: Apple Notes, Apple Reminders, FindMy, iMessage, macOS computer-use automation
- **Autonomous agents**: Claude Code orchestration, Codex, Kanban-Codex lanes, OpenCode, native Hermes agents
- **Creative**: Architecture diagrams, ASCII art and video, Excalidraw, manim videos, P5js, pixel art, popular web designs, sketches, songwriting and AI music, TouchDesigner, design.md, comic generation, infographic generation
- **Data science**: Jupyter live kernel
- **DevOps**: Kanban orchestrator and worker, webhook subscriptions
- **Email**: Himalaya CLI email
- **Gaming**: Minecraft modpack server, Pokémon player AI
- **GitHub**: Codebase inspection, GitHub auth, code review, issues, PR workflow, repo management
- **Inference**: inference.sh integration
- **MCP**: Native MCP server scaffolding
- **Media**: GIF search, Heartmula, Songsee, Spotify, YouTube content
- **MLOps**: Evaluation, HuggingFace Hub, inference, models, research, training, vector databases
- **Note-taking**: Obsidian deep integration
- **Productivity**: Airtable, Google Workspace, Linear, Maps, Nano PDF, Notion, OCR & documents, PowerPoint, Teams meeting pipeline
- **Red-teaming**: Godmode adversarial testing
- **Research**: arXiv, blogwatcher, LLM Wiki, Polymarket, research paper writing
- **Smart home**: Philips Hue (OpenHue)
- **Social media**: HyperFrames video (local HTML+GSAP+Puppeteer → MP4 via `npx hyperframes render`), xurl
- **Software development**: Debugging Hermes TUI, skill authoring, Node debugger, plan and spike workflows, Python debugpy, requesting code review, subagent-driven development, systematic debugging, TDD, writing plans
- **Diagramming** + **Dogfood** + **Yuanbao** + **Gifs** + **Domain** workspaces

**When Hermes comes into play**
Anything that needs to run on a schedule, in the background, or autonomously without keeping Claude Code open. Examples: *"Every weekday at 7am, summarize yesterday's calendar and inbox into a morning brief."* *"Watch this RSS feed and notify me when X happens."* *"Run a recurring competitor scrape."*

Claude Code and Hermes can hand off to each other.

### 3.8 System-Level Tooling

A handful of command-line tools get installed on your machine to support the workflows. All free, all local, no SaaS lock-in:

- **gitleaks**: secret detection in code
- **osv-scanner** (Google): dependency vulnerability scanning
- **syft**: software bill of materials generation
- **semgrep**: static analysis security scanner

For new web projects, the default dev-dependency stack is also seeded automatically:
- **Biome** (linting + formatting)
- **Knip** (dead-code detection)
- **Madge** (circular-dependency detection)
- **axe-core** (accessibility)
- **Lighthouse CI** (perf/a11y/SEO budgets)
- **size-limit** (bundle size budgets)
- **Lefthook** (git hooks)
- **Playwright** (E2E + visual regression)

---

## 4. Day-to-Day Workflows

These are the kinds of requests the setup is built for. Type them in plain English. Claude figures out which tools, skills, and agents to use.

**Marketing & content**
> *"Draft a launch email for the new offer, save it as a Gmail draft, prep a matching Canva post in our brand template, and schedule it to LinkedIn via Postiz next Tuesday at 9am."*

**Paid advertising**
> *"Audit our Google Ads account, surface wasted spend, and rewrite the top 5 underperforming ads using our brand voice."*

**Sales operations**
> *"Pull this week's new HubSpot deals over $10K, enrich each contact via Apollo, draft a follow-up sequence for each, and put a prep brief in Obsidian."*

**Design**
> *"Build a brand identity for [client name]. Logo options, color system, typography, full corporate identity program with 50 mockup deliverables, and three banner mockups for LinkedIn, Instagram, and a homepage hero."*

**Video**
> *"Clone this Instagram reel for our brand. Same pacing, swap the visuals using Higgsfield, write the script, generate the voiceover via ElevenLabs, render the final MP4 with Remotion."*

**Web & dev**
> *"Build a landing page for the new product. Use our brand tokens, generate the components from the Figma file, run the full app-review (including accessibility and security) before we ship, deploy to Vercel."*

**Meetings & follow-ups**
> *"Summarize yesterday's Granola call, draft a recap email, create the follow-up tasks in HubSpot, send a Slack note to the team, and block prep time on Friday's calendar."*

**Research**
> *"Run a Bigdata.com investment memo on [company], pull recent news via Firecrawl, build a peer comparables table, and save the whole thing as a note in Obsidian with a knowledge graph via /graphify."*

**Finance & ops**
> *"Reconcile last month's bank statement, generate the journal entries, draft variance analysis vs budget, and produce the financial statements package."*

**Automation**
> *"Every weekday at 7am, run my morning brief: yesterday's calendar, today's calendar, overnight inbox, top 3 priorities. Drop it in Obsidian and Slack it to me."*

**Obsidian-centric (the brain of the setup)**
> *"Check my Obsidian vault. What did I decide about [client] last month? Pull every related note, summarize the through-line, and draft my next message to them."*

> *"At the end of every day, append a journal entry to today's daily note: what I worked on (from Claude session logs), open loops, tomorrow's top 3."*

> *"Take this meeting transcript, save it as a properly-tagged note in Obsidian, link it to the related project and client notes, and update my running CRM-style note for that contact."*

---

## 5. Installation

Here's the order I install everything in. You're present for the connector logins.

**Step 1. Install Claude Code** (5 min)
Download from [claude.com/claude-code](https://claude.com/claude-code) and sign in.

**Step 2. Apply operating conventions** (2 min)
I drop the `CLAUDE.md` rules file into your user folder. Claude picks it up automatically.

**Step 3. Add plugin marketplaces** (5 min)
Three marketplaces: Anthropic official, claude-mem (memory), claude-ads (advertising).

**Step 4. Enable plugins** (5 min)
The 14 plugins from the official marketplace, plus claude-mem and claude-ads.

**Step 5. Install skills** (10 min)
130+ skills copied into `~/.claude/skills/`. They activate automatically based on what you ask.

**Step 6. Install subagents** (5 min)
~165 specialist agent personas dropped into `~/.claude/agents/`. Claude routes to them automatically.

**Step 7. Connect your tools** (20–30 min)
For each connector you want, you click "Sign in" and authorize Claude inside the tool's normal login screen (Google, HubSpot, Canva, etc.). I do this with you so we confirm each connection works.

**Step 8. Install Hermes** (10 min)
Python-based parallel agent. Installs Hermes CLI and its 100+ skills. Optional. Skip if you don't need autonomous or scheduled work.

**Step 9. Install system tooling** (5 min)
gitleaks, osv-scanner, syft, semgrep installed via winget or brew.

**Step 10. Quick test drive** (10–15 min)
We run real requests together so you see the stack working end-to-end and know what to expect.

---

## 6. Maintenance

**Updates**
Plugins, skills, and connectors update themselves when authors push new versions. Once a quarter I do a maintenance pass to add anything new worth adopting and prune what's no longer useful.

**Adding a tool later**
If you start using a new tool (e.g., Linear, Discord, Telegram), most have a Claude connector available. We add it in 5 minutes.

**Something not working?**
Three things to try first:
1. Restart Claude Code (closes and reopens the session).
2. Run `/doctor`. It diagnoses common configuration issues.
3. Reach out. I keep a record of your install and can fix or re-link anything.

**Hermes maintenance**
- Update: `hermes update`
- Health check: `hermes doctor`

**Privacy & control**
- All credentials live on your machine, not mine.
- Connectors use OAuth. Same security and revoke-anytime control as your other apps.
- Claude only acts when you ask it to. No background automation runs unless you specifically set it up.
- Hermes runs entirely locally. No cloud relay.

---

## 7. What's intentionally optional

A few things in my full setup that I don't include by default. They're either niche, technically heavy, or only relevant to specific workflows. Ask if any apply to you:

- **Custom RunPod GPU pipelines** for advanced image and video work that needs serious horsepower
- **Self-hosted MoviePy / LTX-2 / Qwen-Edit pipelines** for clients doing high-volume video work
- **Game dev subagents** (Unity, Unreal, Godot, Roblox, Blender). Only relevant for game studios.
- **XR / spatial computing subagents**. Only relevant for visionOS and spatial-app work.
- **China-market marketing specialists** (Baidu, Bilibili, Douyin, Kuaishou, Weibo, Xiaohongshu, Zhihu, WeChat). Only relevant for clients selling into mainland China.
- **HyperFrames video pipeline**. Local HTML+GSAP+Puppeteer video rendering, for clients doing programmatic short-form video.
- **Salesforce-specific tooling** (sf-changes, Salesforce Architect subagent). Only if you're in the Salesforce ecosystem.
- **Bigdata.com financial research**. Only relevant for finance and investment workflows.

---

*Setup maintained by Reggie. Questions, requests, or anything broken, reach out.*
