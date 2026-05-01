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
data/
  projects.json           # LEGACY — migrated to content/projects/; can be ignored
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

Individual talk pages are NOT rendered (`build: render: never` cascaded from `_index.md`). They appear in lists only; card titles link directly to the external URL.

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

Same cascade as talks — no individual pages rendered.

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

## Memory

- [No Claude attribution](memory/feedback_no-claude-attribution.md) — Never commit with Co-Authored-By or AI attribution

## Owner details

- **Name:** Adil Leghari
- **Role:** Senior Solutioneer @ Wiz
- **GitHub:** adilio
- **Bluesky:** adilio.ca
