# Beta testing

Stage: **0.1 beta**. Goal: every mode of the skillers skill reaches a satisfactory result on its eval cases before it is marked stable.

## Loop
1. **Install** the library in a fresh session (see README).
2. **Tailor**: run `skillers-setup`, or copy `config/skillers.config.example.json` to `~/.skillers/config.json` and edit.
3. **Run** one case from `tests/evals/<mode>.md`, exactly as written.
4. **Check**: tick the checks that passed.
5. **Score** with the rubric below.
6. **Log**: copy `tests/results/TEMPLATE.md` to `tests/results/YYYY-MM-DD-<mode>-case<n>.md` and fill it in.
7. **Fix**: change the mode file, bump its line in `CHANGELOG.md`, rerun the same case.

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
A mode moves from beta to stable when 3 logged runs in a row average **4 or more**, with **no score below 3 on Honesty or Scope**. Record the promotion in `CHANGELOG.md`.

## Status
| Mode | Status | Runs logged | Last average |
|---|---|---|---|
| router (mode picking) | beta | 0 | |
| setup | beta | 0 | |
| scope | beta | 0 | |
| references | beta | 1 (manual, 2026-11-07) | |
| base-work | beta | 2 (manual, 2026-11-07) | |
| anti-slop | beta | 1 (manual, 2026-11-07) | |
| papers | beta | 1 (manual, 2026-11-07) | |
| autopilot | beta | 0 | |
