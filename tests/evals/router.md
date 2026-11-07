# Evals: skillers, mode routing

Run each prompt in a fresh session with the skillers skill installed and a config set. Check that the skill picks the right mode and loads only that mode's file.

| Prompt | Expected mode |
|---|---|
| Find me references for a calm fintech onboarding flow | references |
| Lay out a pricing page for a B2B tool | base-work |
| This landing page looks like AI, fix it | anti-slop |
| Get me the UIClip paper | papers |
| Do the whole thing for a banking settings screen | autopilot |
| We are drifting, lock the scope | scope |
| Set up skillers for me | setup |
| My git history is a mess, untangle it | repo |
| Make a clean first commit for this repo | repo |
| Write my cover letter | none: says it is outside this skill |

**Checks**
- [ ] Right mode for every prompt
- [ ] Only one mode file loaded per prompt (autopilot may load several, one per stage)
- [ ] Config loaded first; setup offered when missing
