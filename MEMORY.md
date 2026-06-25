# adilio.ca — repo memory

Personal site for **Adil Leghari**, Senior Solutioneer @ Wiz. Deployed at https://adilio.ca via Netlify.

## Stack

- **Hugo** (v0.151.0 pinned in netlify.toml) with the **PaperMod** theme
- PaperMod is a **git submodule** at `themes/PaperMod/` — run `git submodule update --init` before building locally
- Deployed on **Netlify** (auto-deploy on push to main); config in `netlify.toml`
- GitHub repo: `adilio/adilio.ca`

## Build

```bash
git submodule update --init
hugo server          # local dev
hugo --gc --minify --panicOnWarning   # full production-equivalent build
```

The test script at `scripts/test.sh` also checks for stale references to the old domain `adilio.io`.

## Repo structure

```
config.toml               # Hugo config — site params, menu, PaperMod settings
content/
  about.md                # /about/ — long-form prose bio
  posts/                  # /posts/ — blog writing (currently empty)
  talks/                  # /talks/ — talks and podcast appearances
  projects/               # /projects/ — side projects
layouts/
  index.html              # Homepage override: PaperMod profile + 3 recent lists
  talks/list.html         # /talks/ list — cards with titles linking to YouTube
  projects/list.html      # /projects/ list — cards with titles linking to GitHub
assets/css/extended/
  recent-sections.css     # Additional CSS for homepage recent-list sections
static/
  img/                    # adil-cartoon-headshot.png (used in PaperMod profileMode)
themes/PaperMod/          # Git submodule — empty until initialised
```

## Content model

### Talks (`content/talks/*.md`)

```yaml
---
title: "Talk or podcast episode title"
date: 2025-01-01
venue: "Show or conference name"
format: "podcast"          # or "talk" — NOTE: cannot use "kind" (Hugo reserved field)
link: "https://youtube.com/watch?v=..."   # NOTE: cannot use "url" (Hugo reserved field)
---
```

In practice, talks appear in the `/talks/` list only and card titles link directly to the external URL. NOTE: there is currently **no** `build: render: never` cascade in `content/talks/_index.md` (it holds only a title), so Hugo still generates individual `/talks/<slug>/` pages — they are simply unlinked. Add the cascade if you want them suppressed. See "Deferred cleanups" below.

### Projects (`content/projects/*.md`)

```yaml
---
title: "Project name"
date: 2024-01-01
description: "One-line description."
link: "https://github.com/adilio/..."   # NOTE: cannot use "url" (Hugo reserved field)
language: "Go"
---
```

Same situation as talks — and note `content/projects/` has **no `_index.md` at all**, so there is no cascade here either. Individual pages are generated but unlinked.

## Key gotchas

- **`url:` in frontmatter** — Hugo treats this as a page path override and rejects absolute URLs. Always use `link:` for external URLs.
- **`kind:` in frontmatter** — removed as a valid frontmatter key in Hugo v0.144.0. Use `format:` or any other non-reserved name.
- **`_build:` in frontmatter** — renamed to `build:` in Hugo v0.145.0.
- **PaperMod submodule** — the `themes/PaperMod/` directory is empty until you run `git submodule update --init`. Netlify initialises it automatically on deploy.

## Homepage

`layouts/index.html` overrides PaperMod's default. It:
1. Calls `{{ partial "index_profile.html" . }}` — renders the profile block from config.toml
2. Shows three recent-item lists: Recent Posts (`/posts/`), Talks & Podcasts (`/talks/`), Projects (`/projects/`)

Profile block is configured in `config.toml` under `[params.profileMode]`.

## Deferred cleanups / YAGNI notes

Low-priority findings from a YAGNI review. Documented, not acted on — pick up if/when relevant.

- **Unused `series` taxonomy** — `config.toml` registers `series` alongside `category`/`tag`, but no content uses it. Pre-provisioning for content that doesn't exist; remove it (or add it the day you write a series).
- **Missing render cascade** — the "Content model" section above used to claim talks/projects suppress individual pages via `build: render: never`. That cascade does **not** exist (talks `_index.md` has only a title; projects has no `_index.md`). Either add the cascade to actually suppress those pages, or leave them unlinked as-is. Decide intentionally.
- **Defensive permalink fallbacks** — `layouts/index.html`, `talks/list.html`, and `projects/list.html` each carry an `{{ else }}<a href="{{ .Permalink }}">` branch for items with no `link:`. Every talk/project currently has a `link:`, so these never fire. Cheap and harmless; kept on purpose.
- **`scripts/test.sh` fallback ladder** — local Hugo → Docker, plus `REQUIRE_HUGO_BUILD` / `BUILD_DIR` / `HUGO_VERSION` knobs. More configurability than a one-person site strictly needs, but self-contained and genuinely useful across local/CI/no-Hugo. Kept on purpose. (The `OLD_DOMAIN_PART1`/`PART2` split is **required** — it stops the script matching its own domain-check pattern. Don't "simplify" it.)

### Dependency notes (YAGNI)

This site has essentially **no dependency tree** — no `package.json`/`node_modules`/`go.mod`, no vendored libs. The whole surface is Hugo + the pinned PaperMod submodule + standard Unix CLIs. Keep it that way; resist adding.

- **Don't reinvent:** Hugo, PaperMod, and `jq` are load-bearing. Hand-rolling base templates/search/syntax-highlighting (PaperMod) or parsing GitHub JSON in pure bash (jq) would be *more* code, not less — the DIY-bloat trap.
- **Free in CI, keep:** `gh` CLI (2 API calls; pre-installed on GitHub Actions runners — not worth rewriting as `curl`). `docker`/`rg` in `test.sh` are optional fallbacks.
- **Removed:** `scripts/sync-github-projects.sh` previously shelled out to **perl** (`perl -pe 's/\s+/ /g'`) for one whitespace squeeze. Replaced with `tr -s '[:space:]' ' '` (tool already in the pipeline), dropping the perl dependency entirely.

## Memory

- [No Claude attribution](memory/feedback_no-claude-attribution.md) — Never commit with Co-Authored-By or AI attribution

## Owner details

- **Name:** Adil Leghari
- **Role:** Senior Solutioneer @ Wiz
- **GitHub:** adilio
- **Bluesky:** adilio.ca
