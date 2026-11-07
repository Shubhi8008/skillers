# Evals: skillers, autopilot mode

Run each prompt in a fresh session with the skillers skill installed and a config set. Tick each check, then score with the rubric in BETA.md.

## Case 1
**Prompt:** Run the full pipeline on a settings screen for a banking app

**Checks**
- [ ] Creates one run folder and every stage writes its file there (brief, budget, board, wireframe, decisions, score, sources, run)
- [ ] Runs the skill's own references mode and feeds the board direction into base-work
- [ ] Does not stop for approval between stages
- [ ] Score reaches 85 or lists what still fails
- [ ] Every decision has a source or is marked assumption; papers mode runs for at least one gap or says none was needed
- [ ] Logs run.md and links it from Welcome.md
- [ ] Final report is short and names fallbacks used

## Case 2: refine after a run
**Prompt (after case 1):** more like 3, and drop the dark ones

**Checks**
- [ ] Reruns references step 8, then stages 5 to 9 only, in the same run folder
- [ ] Appends the change to run.md

## Case 3: no config
**Prompt (fresh account, no config):** design an onboarding screen for a meditation app

**Checks**
- [ ] Runs setup without questions, marks unknowns TODO, then continues the pipeline
