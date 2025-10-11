# Hugo Theme Recommendations

## Current Setup Overview
- **Active theme**: `hello-friend-ng`, configured in `config.toml`.
- Strengths: clean typography, syntax-highlighted code blocks, dark/light toggle, social icon slots.
- Limitations for your goals: limited built-in homepage widgets (no quote-of-the-day block), fewer social link styles, constrained layout customization without editing templates.

## Recommendation Criteria
To better match the UX you like from Gilbert's site and add room for growth, the suggested themes meet these requirements:
1. **Markdown-first authoring**: native support for Markdown posts, shortcodes for images, and fenced code blocks.
2. **Rich homepage modules**: hero sections, profile cards, or configurable widgets where quotes or callouts can live.
3. **Comprehensive social integrations**: icon sets, configurable contact links, and optional badges.
4. **Active community & maintenance**: recently updated, with documentation and examples.

## Top Theme Options

### 1. PaperMod
- **Why it's popular**: one of the most-starred Hugo themes, with an active maintainer base and frequent releases.
- **Feature highlights**:
  - Configurable home profile section (title, subtitle, social links, buttons).
  - Built-in support for code blocks, image captions, math rendering, copy-to-clipboard buttons, and reading-time estimates.
  - Extendable via `layouts/partials` overrides; many community snippets exist.
  - Optional "info" cards and custom widgets (e.g., quote-of-the-day) by creating partials displayed on the home page.
- **Migration notes**:
  - Rename `[params]` in `config.toml` to match PaperMod's schema (`[params.homeInfoParams]`, `[[params.socialIcons]]`, etc.).
  - Assets such as your portrait move to `static/` and are referenced with `.Site.Params.profileMode.imageUrl`.

### 2. LoveIt / FixIt (v2 successor)
- **Why it fits**: LoveIt is feature-rich; FixIt continues the project with a fresh UI and active updates.
- **Feature highlights**:
  - Built-in widgets for profile cards, social badges, and customizable hero banners.
  - Native shortcodes for quotes, tabs, timelines, admonitions, and responsive images.
  - Sidebar modules can host a rotating quote partial fed by data files.
  - Supports multi-language sites, comment systems, analytics, and theme toggles out-of-the-box.
- **Migration notes**:
  - Convert menu definitions to LoveIt/FixIt format (`[menu.main]` works with minimal changes).
  - Add a `data/quotes.yaml` file and include the provided `quote` shortcode or partial on the home page.

### 3. Stack
- **Why it works**: Stack targets personal blogs/portfolios with card-based sections and deep configuration.
- **Feature highlights**:
  - Modular home page supporting About, Recent Posts, Projects, Contact, and custom widgets.
  - Enhanced social links with icon packs and call-to-action buttons.
  - Supports Markdown features, KaTeX/MathJax, Mermaid diagrams, and code block enhancements.
  - Allows custom sections powered by JSON/YAML/TOML data files—perfect for a quote-of-the-day card.
- **Migration notes**:
  - Requires reorganizing front matter to use Stack's `featured` metadata for cards.
  - Social links defined under `params.socialLinks` with support for numerous networks.

## Suggested Next Steps
1. Spin up a preview locally: `hugo server --config config.papermod.toml` (or equivalent) after copying your current config.
2. Start with PaperMod or FixIt: both provide quick wins for social cards and homepage widgets while letting you inject a daily quote partial.
3. Gradually port styling overrides from `hello-friend-ng` using the new theme's `assets/css/custom.css` entry point.
4. Keep your Markdown content unchanged; adjust front matter only if adopting theme-specific parameters (featured images, summary length, etc.).

Choosing PaperMod or FixIt will give you the modern UX you want while preserving your Markdown-first publishing flow and expanding room for social integrations and dynamic sections.
