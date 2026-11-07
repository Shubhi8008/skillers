#!/usr/bin/env bash
# Build one .zip per skill in dist/ for upload to Claude (Settings > Capabilities > Skills).
set -euo pipefail
here="$(cd "$(dirname "$0")/.." && pwd)"; mkdir -p "$here/dist"
for d in "$here"/skills/*/; do
  name="$(basename "$d")"; (cd "$here/skills" && rm -f "$here/dist/$name.zip" && zip -qr "$here/dist/$name.zip" "$name"); echo "dist/$name.zip"
done
