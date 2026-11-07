---
name: skillers
description: One skill for tailored design work. Prompt to a references collage, research-backed wireframes, anti-slop audits, open-access papers, a full design pipeline, and a scope guard, set per user by one config. Use for references, moodboards, wireframes, UX audits and design research.
---

# Skillers

One skill, several modes. Read this file, pick one mode, load only that mode's file.

## 1. Load the config
Lookup order: `$SKILLERS_CONFIG`, then `./skillers.config.json`, then `~/.skillers/config.json`. Values in `{braces}` in any mode come from this file. If no config exists, run **setup** first, then return to the request.

## 2. Guard the scope
If `{scope_lock}` exists, read it and run the drift check in `references/modes/scope.md` before any work. Out of scope means: name it in one line and wait.

## 3. Pick the mode
| Mode | Use when the request is about | File |
|---|---|---|
| setup | first run, tailoring, changing settings | `references/modes/setup.md` |
| references | references, inspiration, moodboard, "find designs like", Pinterest or Cosmos not close enough, "more like 3", "drop the dark ones" | `references/modes/references.md` |
| base-work | wireframe, layout, structure, information architecture, "how should this page be laid out" | `references/modes/base-work.md` |
| anti-slop | audit, declutter, simplify, "looks like AI", budgets before generating | `references/modes/anti-slop.md` |
| papers | a decision needs a source, download papers or PDFs, reading list | `references/modes/papers.md` |
| autopilot | one brief that needs the whole job: structure, references, cut, critique, evidence | `references/modes/autopilot.md` |
| scope | drifting, stay on brief, lock or update the scope | `references/modes/scope.md` |

If two modes fit, run them in this order: references, base-work, anti-slop, papers. If more than two fit, use autopilot. If none fit, say the request is outside this skill.

## 4. Knowledge, on demand
Load a file from `references/knowledge/` only when a decision needs a cited reason:
`ux-laws.md`, `cognitive-load-and-memory.md`, `scanning-and-placement.md`, `heuristics.md`, `conversion-and-microcopy.md`, `seo-and-performance.md`, `problem-statements-and-design-decisions.md`, `motion-loading-and-eye-movement.md`.

## 5. Scripts
In `scripts/` of this skill and of the repo clone at `{paths.repo}/skills/skillers/scripts/` on the machine that runs them (`{runner}`): `refs.ps1` (gather references, Windows), `collage.py` (contact sheet, palette, Obsidian canvas), `fetch-paper.ps1` and `fetch_paper.py` (open-access papers).

## 6. Output rules (every mode)
- Write in `{user.voice}`. Address the user as `{user.address_as}`; end with `{user.signoff}` if set.
- No invented facts, names, numbers or results. Mark gaps instead.
- Credit every reference and source with a link. Papers from open-access sources only.
- Do only what was asked. One output per request, then suggest the scope lock's next step.
