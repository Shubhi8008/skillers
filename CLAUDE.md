# Working on the skillers library

This repo is a skill library, not an app. Read `BETA.md` before changing a skill.

## Layout
- `skills/<name>/SKILL.md` one folder per skill. Scripts go in `skills/<name>/scripts/`, long reference text in `skills/<name>/references/`.
- `config/skillers.config.example.json` the only place example paths live. Skills never hardcode a user path; they read `{paths.*}` from the config.
- `tests/evals/<skill>.md` eval cases. `tests/results/` logged runs.
- `tools/harvest/` the repo harvester. Its data files are gitignored.
- `.claude-plugin/` plugin and marketplace manifests.

## Rules for changes
1. One skill per change where possible. Update its line in `CHANGELOG.md`.
2. Every new skill gets at least one eval case in `tests/evals/`.
3. Frontmatter: `name` matches the folder; `description` says when to use it, under ~300 characters.
4. No personal data, tokens or hardcoded user paths in skills.
5. Plain, short English. No em dashes.
6. Stay on the brief in `BETA.md`. Do not add unrelated skills without the owner asking.
