# Working on the skillers library

This repo ships **one skill**, `skills/skillers`, with modes. Read `BETA.md` before changing a mode.

## Layout
- `skills/skillers/SKILL.md` the router: config, scope check, mode table. Keep it short.
- `skills/skillers/references/modes/<mode>.md` one file per mode. `references/knowledge/` research notes. `scripts/` helper scripts.
- `config/skillers.config.example.json` the only place example paths live. Skills never hardcode a user path; they read `{paths.*}` from the config.
- `tests/evals/<mode>.md` eval cases, `router.md` for mode picking. `tests/results/` logged runs.
- `tools/harvest/` the repo harvester. Its data files are gitignored.
- `.claude-plugin/` plugin and marketplace manifests.

## Rules for changes
1. Never add a second skill. New capability means a new mode: a file in `references/modes/` plus a row in the router table. One mode per change; update `CHANGELOG.md`.
2. Every new mode gets at least one eval case in `tests/evals/` and a row in `router.md`.
3. Router frontmatter: `name: skillers`; `description` under ~300 characters and names every mode's use.
4. No personal data, tokens or hardcoded user paths in the skill.
5. Plain, short English. No em dashes.
6. Stay on the brief in `BETA.md`. Do not add unrelated modes without the owner asking.
