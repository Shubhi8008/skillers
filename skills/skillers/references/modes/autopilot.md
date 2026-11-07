# Autopilot

One brief in, finished and defended design work out. Autopilot is the conductor: it runs every other mode in order, passes each one's output to the next through one run folder, and does not stop for approval.

Ask the user only if the primary goal or page type is missing: at most 2 questions in one message, then continue with stated assumptions. Everything else is decided, logged and reported at the end.

## The run folder (how modes hand off)
Create `{paths.runs}/YYYY-MM-DD-<slug>/` at the start. Every stage reads what earlier stages wrote and adds its own file. A later session can resume any run from this folder alone.

| File | Written by | Read by |
|---|---|---|
| `brief.md` | stage 1 | every stage |
| `budget.md` | anti-slop step 1 | base-work, anti-slop cut, hi-fi |
| `board/` (picks.json, board.canvas, board.md, direction) | references mode | base-work |
| `wireframe.html`, `decisions.md` | base-work mode | anti-slop cut, critique, evidence |
| `score.md` | anti-slop steps 2 to 5 | final report |
| `sources.md` | papers mode | decisions.md, final report |
| `run.md` | stage 11 | user, next session |

## Pipeline
0. **Setup.** Load the config. If none exists, run setup mode without questions: fill what is known, mark the rest `"TODO"`, and continue. If `{paths.runs}` is not set, use `{paths.vault}/runs`.
1. **Scope.** Run scope mode's drift check on the brief. Out of scope: say so in one line and stop. In scope: write `brief.md` (goal in the first line, page type, audience, platform, must haves, must avoids, assumptions).
2. **Classify:** new page, new flow, redesign, review only, or copy only. Skip stages that do not apply: review only starts at stage 6, copy only runs stages 8, 9 and 11.
3. **Budget.** Run anti-slop step 1 and write `budget.md`. Everything after must fit it.
4. **References.** Run references mode steps 1 to 7 and 9 into `board/`. Do not wait for curation (step 8): take the Top picks group as chosen. Its direction brief feeds stage 5.
5. **Structure.** Run base-work mode with `brief.md`, `budget.md` and the board direction as input. Borrow patterns from the picks, never whole layouts. Output `wireframe.html` and `decisions.md`.
6. **Cut and score.** Run anti-slop steps 2 to 5 on the recommended option. Reach 85 with no floor failures, revising up to 3 loops. Write `score.md`.
7. **Critique.** Run `impeccable` critique, then audit, if installed; else the Nielsen 10 heuristics check. Fix every P0 and P1, then rescore once.
8. **Copy.** Run `stop-slop` on visible text if installed, `humanizer` on long prose; else anti-slop copy rules.
9. **Evidence.** Every line in `decisions.md` needs a source from `references/knowledge/`. If none fits, run papers mode for one open-access paper and cite it in `sources.md`, or mark the line "assumption" with a test to run.
10. **Hi-fi** only if the brief asks: `design-taste-frontend` or `frontend-design` if installed, else 1 accent, 2 fonts, 4 sizes. Stay inside the budget, then repeat stage 6 once.
11. **Log.** Write `run.md`: brief, budget, board link, chosen option, score before and after, cuts, fixes, sources, missing skills, assumptions. Link it from `{paths.vault}/Welcome.md` if that file exists.
12. **Commit.** Only if the run folder is inside a git repo: follow repo mode part A and commit on a branch named `run/<slug>`. Never commit to the default branch. Never push unless the user asked.

## Parallel work
With sub-agents available, run these at the same time: references gathering per source (stage 4), evidence lookups (stage 9), and hi-fi variants. Keep budget, structure, cut and critique in order, because each reads the last one's file.

## After the run: refine without restarting
Route the user's reaction back into the pipeline and rerun only what it touches:
- About references ("keep 3", "drop the dark ones", "more like 5"): references step 8, then stages 5 to 9.
- About layout or content ("move pricing up", "too many sections"): stage 5 with the change, then stages 6 to 9.
- About copy: stage 8.
- "Is that backed?": stage 9 for that decision.
Append each refinement to `run.md` with what changed.

## Stop conditions
- Score 85+ with no floor failures, P0 and P1 fixed, every decision sourced or marked assumption.
- Or 3 loops reached: ship the best version and list what still fails.
- A source or tool fails: note it, use the fallback, keep going.

## Final report (short)
Run folder · chosen option and file · score before and after · top 5 cuts · P0 and P1 fixes · sources · fallbacks used and skills missing · the one test to run first.
