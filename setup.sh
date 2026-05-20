#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────────────────────
# CLIMATRIX — setup.sh
# Initializes the Next.js project, installs dependencies, scaffolds folders.
# ──────────────────────────────────────────────────────────────────────────────
set -e

CYAN='\033[0;36m'
PURPLE='\033[0;35m'
PINK='\033[0;95m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
RESET='\033[0m'

banner() {
  echo -e "${CYAN}${BOLD}"
  echo "   ╔═══════════════════════════════════════════════════╗"
  echo "   ║                                                   ║"
  echo "   ║      C L I M A T R I X    —    Weather, decoded.  ║"
  echo "   ║                                                   ║"
  echo "   ╚═══════════════════════════════════════════════════╝"
  echo -e "${RESET}"
}

log()  { echo -e "${CYAN}▸${RESET} $1"; }
ok()   { echo -e "${GREEN}✓${RESET} $1"; }
warn() { echo -e "${YELLOW}!${RESET} $1"; }
err()  { echo -e "${RED}✗${RESET} $1"; }

banner

# ── Preflight ────────────────────────────────────────────────────────────────
log "Checking prerequisites…"
if ! command -v node >/dev/null 2>&1; then
  err "Node.js is not installed. Install it from https://nodejs.org (LTS)."
  exit 1
fi
NODE_MAJOR=$(node -v | sed 's/v//' | cut -d. -f1)
if [ "$NODE_MAJOR" -lt 18 ]; then
  err "Node.js 18+ required. You have $(node -v)."
  exit 1
fi
ok "Node $(node -v) detected"
ok "npm  $(npm -v) detected"

# ── Scaffold Next.js app in the current directory ───────────────────────────
log "Scaffolding Next.js 14 (TypeScript + Tailwind + App Router)…"
if [ -f "package.json" ]; then
  warn "package.json already exists — skipping create-next-app."
else
  npx --yes create-next-app@14.2.15 . \
    --typescript \
    --tailwind \
    --eslint \
    --app \
    --src-dir=false \
    --import-alias "@/*" \
    --use-npm \
    --no-turbo \
    >/dev/null
  ok "Next.js scaffolded"
fi

# ── Install runtime dependencies ────────────────────────────────────────────
log "Installing runtime dependencies (this can take ~1 min)…"
npm install --silent \
  framer-motion@^11.11.0 \
  recharts@^2.13.0 \
  lucide-react@^0.453.0 \
  maplibre-gl@^4.7.1 \
  zustand@^4.5.5 \
  next-themes@^0.3.0 \
  clsx@^2.1.1 \
  tailwind-merge@^2.5.4
ok "Runtime deps installed"

# ── Install dev dependencies ────────────────────────────────────────────────
log "Installing dev dependencies…"
npm install --silent -D \
  @types/node@^20.16.10
ok "Dev deps installed"

# ── Folder structure ────────────────────────────────────────────────────────
log "Creating folder structure…"
mkdir -p \
  app/favorites \
  app/scores \
  app/about \
  "app/location/[lat]/[lon]" \
  components/map \
  components/panel \
  components/search \
  components/ui \
  components/layout \
  lib \
  store \
  types \
  public
ok "Folders ready"

# ── Clean default boilerplate that will be replaced by build.sh ────────────
log "Removing default boilerplate…"
rm -f app/page.tsx app/layout.tsx app/globals.css app/favicon.ico \
      public/next.svg public/vercel.svg public/file.svg public/globe.svg public/window.svg \
      README.md tailwind.config.ts tailwind.config.js postcss.config.mjs postcss.config.js next.config.mjs next.config.js 2>/dev/null || true
ok "Boilerplate cleared"

echo ""
echo -e "${PURPLE}${BOLD}Setup complete.${RESET}"
echo -e "Next step:  ${CYAN}bash build.sh${RESET}"
echo ""