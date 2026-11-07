# Design autopilot

One brief in, finished and defended design work out. Run every stage in order without stopping for approval. Ask the user only if the primary goal or page type is missing, at most 2 questions, then continue with stated assumptions.

## Stages
Load each mode file when its stage starts. External skills (impeccable, stop-slop, humanizer, a taste skill) are used only if installed. If a skill is not installed, use the fallback and say so in the final report.

| Stage | Mode or skill | Fallback |
|---|---|---|
| Structure | base-work mode | its steps from memory |
| Slop budget and cut | anti-slop mode | its budget table |
| Critique and audit | `impeccable` | Nielsen 10 heuristics check |
| Hi-fi direction (only if hi-fi is asked) | `design-taste-frontend` or `frontend-design` | 1 accent, 2 fonts, 4 sizes |
| Prose and microcopy | `stop-slop`, then `humanizer` for long text | anti-slop mode copy rules |
| Evidence | papers mode | cite references/knowledge only |
| Notes | `obsidian-markdown` | plain markdown |

## Pipeline
1. **Classify** the request: new page, new flow, redesign, review only, or copy only. Skip stages that do not apply (review only starts at stage 5).
2. **Budget first.** Run anti-slop mode step 1 and write the budget at the top of the work. Everything after must fit it.
3. **Structure.** Run base-work mode: problem statement, IA, 3 grayscale options, decision log.
4. **References.** If Inspo, Mobbin, Refero or Awwwards tools are connected, pull 3 to 5 references for the recommended option only. Borrow patterns, never whole layouts.
5. **Cut and refine.** Run anti-slop mode steps 2 to 5 on the recommended option. Score must reach 85 with no floor failures. Loop at most 3 times.
6. **Critique.** Run impeccable critique, then audit. Fix every P0 and P1.
7. **Hi-fi** only if asked: apply a taste skill if installed, inside the budget, then repeat stage 5 once.
8. **Copy.** Run stop-slop on all visible text. Keep the voice plain.
9. **Evidence.** Every decision in the log needs a source. If a claim has none, run papers mode for one paper or mark it "assumption" with a test.
10. **Log.** Append to the vault (`{paths.vault}`): one note per run named `Run YYYY-MM-DD <page>`, linking the decision log, score, sources and output file. Link it from `Welcome.md`.

## Parallel work
When sub-agents are available, run these at the same time: references (stage 4), evidence lookups (stage 9), and color or hi-fi variants. Keep structure, cut and critique sequential, because each depends on the last.

## Stop conditions
- Slop score 85+ with no floor failures, impeccable P0 and P1 fixed, every decision sourced or marked assumption.
- Or 3 loops reached: ship the best version and list what still fails.

## Final report (short)
Recommended option and file · slop score before and after · top 5 cuts · P0/P1 fixes · sources used · skills that were missing · the one A/B test to run first.
