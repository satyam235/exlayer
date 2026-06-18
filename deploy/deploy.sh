#!/usr/bin/env bash
# Build locally (Node 20 via nvm) and sync the static site to the server.
# Usage: ./deploy/deploy.sh user@your-server-ip
set -euo pipefail

TARGET="${1:?Usage: ./deploy/deploy.sh user@host}"
REMOTE_DIR="${2:-/var/www/exlayer}"

cd "$(dirname "$0")/.."

# use the Node version pinned in .nvmrc (20)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && nvm use >/dev/null 2>&1 || true

echo "==> building (node $(node -v))"
npm ci
npm run build

echo "==> syncing dist/ -> $TARGET:$REMOTE_DIR"
rsync -avz --delete dist/ "$TARGET:$REMOTE_DIR/"

echo "==> done. On the server: sudo systemctl reload nginx"
