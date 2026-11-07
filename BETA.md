# Beta testing

Stage: **0.1 beta**. Goal: every skill reaches a satisfactory result on its eval cases before it is marked stable.

## Loop
1. **Install** the library in a fresh session (see README).
2. **Tailor**: run `skillers-setup`, or copy `config/skillers.config.example.json` to `~/.skillers/config.json` and edit.
3. **Run** one case from `tests/evals/<skill>.md`, exactly as written.
4. **Check**: tick the checks that passed.
5. **Score** with the rubric below.
6. **Log**: copy `tests/results/TEMPLATE.md` to `tests/results/YYYY-MM-DD-<skill>-case<n>.md` and fill it in.
7. **Fix**: change the skill, bump its line in `CHANGELOG.md`, rerun the same case.

## Rubric (1 to 5 each)
| Score | Means |
|---|---|
| Fit | Output matches the prompt's meaning, not just its keywords |
| Grounding | Each decision names a law, heuristic or study, or is marked assumption with a test |
| Slop | No over-production, no AI tells, budgets respected |
| Honesty | No invented facts, names, numbers or results; gaps are marked |
| Scope | Did only what was asked; no side quests |
| Speed | Finished without needless steps, retries or questions |

## Promotion rule
A skill moves from beta to stable when 3 logged runs in a row average **4 or more**, with **no score below 3 on Honesty or Scope**. Record the promotion in `CHANGELOG.md`.

## Status
| Skill | Status | Runs logged | Last average |
|---|---|---|---|
| skillers-setup | beta | 0 | |
| skillers-scope-guard | beta | 0 | |
| reference-collage | beta | 1 (manual, 2026-11-07) | |
| ux-base-work | beta | 2 (manual, 2026-11-07) | |
| anti-slop-ux | beta | 1 (manual, 2026-11-07) | |
| research-pdf-fetch | beta | 1 (manual, 2026-11-07) | |
| design-autopilot | beta | 0 | |
| ux-knowledge | reference | n/a | |
