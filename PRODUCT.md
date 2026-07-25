# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Users

Adilio.ca serves prospective collaborators and employers evaluating Adil's work, and fellow builders discovering useful apps, experiments, and open-source projects. Both audiences are equally important.

## Product Purpose

Adilio.ca is Adil Leghari's personal home on the web: a place to understand who he is, explore what he builds, and read or listen to his published work. Success means visitors can quickly grasp the breadth and quality of his work, then meaningfully explore a project, article, talk, or external product.

## Positioning

The site connects Adil's professional identity, practical writing, public speaking, 4dl product studio, and broader project history in one personally authored portfolio rather than presenting any one of those facets in isolation.

## Operating Context

The site is a statically generated Hugo site hosted on Netlify. Project information comes from both curated content and public GitHub repository data. Visitors may arrive from professional profiles, search, direct links, or individual project and article links.

## Capabilities and Constraints

- Preserve the existing Hugo and PaperMod foundation.
- Keep the site fast and dependency-light; use Hugo templates, CSS, and minimal vanilla JavaScript.
- Present 4dl.ca, individual 4dl apps, and other public projects in one coherent showcase.
- Curated projects and apps may be pinned or enriched with screenshots and hand-authored context.
- Other eligible public GitHub projects should continue to update through the scheduled repository sync workflow.
- Every showcased item should have an internal detail page with optional external product and source links.
- The site supports light, dark, and system color themes.

## Brand Commitments

- Keep the personal, approachable voice already used across adilio.ca.
- Preserve the Adil Leghari name, adilio.ca domain, cartoon headshot, and existing social identity.
- Treat 4dl as one meaningful part of Adil's body of work, not the boundary of it.

## Evidence on Hand

- Existing biography and profile content in `config.toml` and `content/about.md`.
- Existing project collection in `content/projects/`.
- Scheduled GitHub sync in `.github/workflows/sync-projects.yml` and `scripts/sync-github-projects.sh`.
- Curated 4dl app metadata in `assets/data/featured_apps.yaml`.
- Existing 4dl app screenshots and icons under `static/img/4dl/`.
- The 4dl.ca source project at `/Users/adil/Code/4dl.ca` provides a proven reference for screenshot-led app cards and individual product pages.
- No testimonials, client logos, usage metrics, or employment outcomes are available and must not be fabricated.

## Product Principles

- Make the breadth of the work immediately legible without flattening every project into the same level of importance.
- Let real artifacts and screenshots carry more weight than promotional claims.
- Serve evaluators and curious builders equally through concise overview content and deeper project detail.
- Keep automated discovery reliable while reserving editorial control for the work that best represents Adil.
- Preserve speed, accessibility, and maintainability as part of the experience.

## Accessibility & Inclusion

Use semantic structure, keyboard-operable interactions, visible focus states, sufficient contrast, reduced-motion support, descriptive image alternatives, and layouts that remain usable across mobile and desktop viewports.
