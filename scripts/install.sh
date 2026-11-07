#!/usr/bin/env bash
# Copy the skillers skills into a Claude Code skills folder and create a config if missing.
# Usage: scripts/install.sh [user|project]   (default: user -> ~/.claude/skills, project -> ./.claude/skills)
set -euo pipefail
here="$(cd "$(dirname "$0")/.." && pwd)"
target="$HOME/.claude/skills"; [ "${1:-user}" = "project" ] && target="$PWD/.claude/skills"
mkdir -p "$target"
for d in "$here"/skills/*/; do
  name="$(basename "$d")"; rm -rf "$target/$name"; cp -R "$d" "$target/$name"; echo "installed $name"
done
mkdir -p "$HOME/.skillers"
if [ ! -f "$HOME/.skillers/config.json" ]; then
  cp "$here/config/skillers.config.example.json" "$HOME/.skillers/config.json"
  echo "created ~/.skillers/config.json (ask Claude to "set up skillers" to tailor it)"
fi
