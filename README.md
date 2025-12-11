# adilio.ca
Personal site & blog for Adil Leghari, powered by [Hugo](https://gohugo.io/) and the [`PaperMod`](https://github.com/adityatelange/hugo-PaperMod) theme (profile mode).

## Overview
- Canonical domain: `https://adilio.ca`
- Content: Markdown in `content/`, theme pulled in as a submodule at `themes/PaperMod`, generated output in `public/`
- Hosting: Netlify using the Hugo build defined in `netlify.toml`
- Helper script: `scripts/test.sh` validates the site and builds it locally or via Docker

## Local setup
1. Clone the repo and pull the theme submodule: `git submodule update --init --recursive`
2. Choose a toolchain:
   - **Recommended:** install Hugo Extended ≥ **0.151.0** (`brew install hugo` on macOS ships this version today)
   - **Alternative:** rely on Docker; the helper script automatically falls back to the pinned image when the daemon is running
3. Run `scripts/test.sh`
   - Guards against lingering references to the previous domain
   - Builds the site with Hugo 0.151.0 using the local binary when it meets the minimum version, otherwise it falls back to Docker (`klakegg/hugo:0.151.0-ext-alpine`)
4. Optional preview: `hugo server -D` launches the live-reload dev server if Hugo is installed locally

## Tests
`scripts/test.sh` is the single entry point for verification. Tune behaviour with environment variables when needed:
- `HUGO_VERSION` (default `0.151.0`) — override the Hugo version used both locally and in Docker
- `REQUIRE_HUGO_BUILD=true` — fail if neither a suitable local Hugo nor Docker is available
- `BUILD_DIR` — change the destination directory for the generated site (defaults to `public`)

## Deployment (Netlify)
- Netlify reads `netlify.toml` for build commands, Hugo version, headers, and redirects
- Production command: `hugo --gc --minify --enableGitInfo`
- Deploy previews/branch deploys use the site URL from Netlify (`$DEPLOY_PRIME_URL`)

## Troubleshooting
- **Submodule missing** → run `git submodule update --init --recursive`
- **Skipping Hugo build** → install Hugo ≥ 0.151.0 or start Docker Desktop so the script can use the pinned container image
- **Template/runtime errors** → ensure you’re on Hugo 0.151.0 or newer; PaperMod expects post-0.128 config keys
