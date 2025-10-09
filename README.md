# adilio.ca
Personal site & blog for Adil Leghari, powered by [Hugo](https://gohugo.io/) and the `hello-friend-ng` theme.

## Overview
- Canonical domain: `https://adilio.ca`
- Content: Markdown in `content/`, theme overrides in `themes/hello-friend-ng/`, generated output in `public/`
- Automation: GitHub Actions workflow in `.github/workflows/ci.yml` and the helper script at `scripts/test.sh`

## Local setup
1. Clone the repo and choose a toolchain:
   - **Recommended:** install Hugo Extended ≥ **0.151.0** (`brew install hugo` on macOS ships this version today)
   - **Alternative:** run with Docker (no local dependencies) via `docker run` which the helper script handles automatically when the daemon is running
2. Execute `scripts/test.sh`
   - Guards against any lingering references to the previous domain
   - Builds the site with Hugo 0.151.0 using the local binary when it meets the minimum version, otherwise it falls back to Docker with the pinned image `klakegg/hugo:0.151.0-ext-alpine`
3. Optional preview: `hugo server -D` launches the live-reload dev server if you have Hugo installed locally

## Automated tests
`scripts/test.sh` is the single entry point for verification. Tune behaviour with environment variables when needed:
- `HUGO_VERSION` (default `0.151.0`) — override the Hugo version used both locally and in Docker
- `REQUIRE_HUGO_BUILD=true` — fail if neither a suitable local Hugo nor Docker is available (CI uses this)
- `BUILD_DIR` — change the destination directory for the generated site (defaults to `public`)

## CI/CD workflow
- Runs on every push and pull request
- Steps: checkout → install Hugo 0.151.0 (extended) → run `scripts/test.sh` with `REQUIRE_HUGO_BUILD=true` → upload the `public/` artifact → deploy to GitHub Pages with `actions/deploy-pages` when pushing to `main`
- Deployment artifacts are reused between the build and deploy jobs so the published site matches the tested output

## Enabling GitHub Pages
1. Navigate to **Settings → Pages**
2. Under **Build and deployment**, pick **GitHub Actions** (do **not** use “Deploy from branch”)
3. Save — the workflow handles publishing and exposes the live URL in the `github-pages` environment after each successful run

## Troubleshooting
- **Lingering old-domain refs** → the test script highlights the offending paths; update them to `adilio.ca`
- **Skipping Hugo build** → install Hugo ≥ 0.151.0 or start Docker Desktop so the script can use the pinned container image
- **Template/runtime errors** → ensure you’re on Hugo 0.151.0 or newer; the theme has been updated for the post-0.128 config changes

Happy publishing!
