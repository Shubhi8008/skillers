# Changelog

## 0.3.0-beta (2026-11-07)
- **Autonomous autopilot.** Autopilot now chains all 8 modes: setup (no questions when config is missing), scope, anti-slop budget, the skill's own references mode, base-work, anti-slop cut and score, critique, copy, papers for unsourced decisions, run log, and a repo-mode commit on a `run/<slug>` branch when the run sits in a git repo.
- Modes hand off through one run folder, `{paths.runs}/YYYY-MM-DD-<slug>/`, so a run can resume in a later session. New config key `paths.runs`.
- User reactions after a run rerun only the stages they touch.
- Router: any design brief that is not one named job goes to autopilot.
- Evals: autopilot cases for hand-off, refine and missing config; two new router rows.

## 0.2.0-beta (2026-11-07)
- **One skill.** The 8 separate skills are merged into a single `skills/skillers` skill. `SKILL.md` loads the config, runs the scope check, routes the request to one of 7 modes (setup, references, base-work, anti-slop, papers, autopilot, scope) and loads only that mode's file from `references/modes/`.
- Research notes moved to `references/knowledge/`, scripts to `scripts/`, scope lock template to `references/scope-lock-template.md`.
- Evals renamed per mode, plus `tests/evals/router.md` for mode picking.
- **repo mode** (new): git repo craft, codebase untangle and git history untangle merged into one mode file, `references/modes/repo.md`, with non-interactive git recipes. Eval cases in `tests/evals/repo.md`.

## 0.1.0-beta (2026-11-07)
First packaged release of the library.

- **reference-collage** (new): prompt to brief, query plan, gather from Dribbble, Awwwards, Godly and og:image pages, contact sheet, law and slop scoring, Obsidian canvas board, refine loop, direction brief. Scripts: `refs.ps1`, `collage.py`.
- **ux-base-work**: grayscale wireframe options with law markers, rule pack, SEO block, decision log. Added loading, motion and eye movement rules. Fix from testing: never default the goal to contact; name the goal in the first line.
- **anti-slop-ux**: budgets, purpose test, tells, score gate. Added false success states and runtime-heavy delivery to the floor. Fix from testing: motion that explains passes the purpose test.
- **research-pdf-fetch**: open access only. Added `fetch_paper.py` for macOS, Linux and cloud shells next to `fetch-paper.ps1`.
- **design-autopilot**: chains the skills end to end.
- **skillers-setup** (new): writes the per-user config that replaces all hardcoded paths.
- **skillers-scope-guard** (new): scope lock and drift check, generalised from one project.
- **ux-knowledge** (new): research notes as a loadable skill.
- **tools/harvest**: hourly GitHub and web harvester for growing the library.
