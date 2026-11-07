# skillers

A growing skill library for custom tailored design work. **Status: 0.1 beta.**

The skills turn a prompt into design references and research-backed base work, inside UX laws and conversion research, without AI slop. One config file tailors every skill to the person using it.

## One skill, seven modes
Install one skill, `skillers`. Its `SKILL.md` reads your config, guards the scope, picks a mode from your request and loads only that mode's file.

| Mode | What it does |
|---|---|
| setup | First run. Writes your config: paths, voice, sign-off, OS, script runner, reference sources |
| references | Prompt to references from Dribbble, Awwwards, Godly and the web, ranked by UX laws and slop rules, as an editable Obsidian canvas. Refine with "more like 3", "drop the dark ones" |
| base-work | Brief to problem statement, IA, 3 grayscale wireframe options with law markers, SEO block, decision log |
| anti-slop | Sets budgets before generating, cuts to purpose, scores 0 to 100, ships at 85 |
| papers | Open access papers (arXiv, OpenAlex) into your papers folder, logged as notes |
| autopilot | Runs the modes end to end from one brief |
| scope | Scope lock and drift check for a project |

Research notes behind the rules live in `skills/skillers/references/knowledge/` and load only when a decision needs a cited reason.

## Install

**Claude Code, as a plugin**
```
/plugin marketplace add Shubhi8008/skillers
/plugin install skillers@skillers
```

**Claude Code or any session, by copying**
```
git clone https://github.com/Shubhi8008/skillers
cd skillers
scripts/install.sh            # macOS, Linux, cloud sessions
# or: powershell -ExecutionPolicy Bypass -File scripts\install.ps1   (Windows)
```

**Claude apps (upload)**
```
scripts/package.sh            # builds dist/skillers.zip, upload it in Settings > Capabilities > Skills
```

## Tailor it
Ask the skill to "set up skillers" once, or copy `config/skillers.config.example.json` to `~/.skillers/config.json` and edit it. Lookup order: `$SKILLERS_CONFIG`, then `./skillers.config.json`, then `~/.skillers/config.json`.

Scripts that need a local network (reference gathering, paper downloads) run on the machine named by `runner`: `desktop-commander` for Windows through the Claude desktop app, or `shell` where Claude runs. Clone this repo on that machine and set `paths.repo` to it.

## Grow it
`tools/harvest/harvest.ps1` searches GitHub and curated lists every hour and writes an index note into your vault. Double-click `tools/harvest/install-hourly.cmd` to schedule it. Set a `GITHUB_TOKEN` environment variable yourself to lift the API limit from 60 to 5,000 calls an hour.

## Test it
See `BETA.md`. Each mode has eval cases in `tests/evals/`, plus `router.md` for mode picking. Log runs in `tests/results/`. A mode becomes stable after 3 runs in a row average 4 of 5, with no low score on honesty or scope.

## Rules
References are for study, always credited to their source. Papers come from open access sources only. No tokens or personal data in the repo.
