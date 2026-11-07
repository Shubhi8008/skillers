# Evals: skillers, repo mode

Run each prompt in a fresh session with the skillers skill installed and a config set. Tick each check, then score with the rubric in BETA.md.

## Case 1
**Prompt:** Set up this new folder as a clean public repo and make the first commit.

**Checks**
- [ ] Adds README, .gitignore, CHANGELOG and asks about the license
- [ ] Conventional commit message, no praise words
- [ ] Scans the staged diff for secrets before committing
- [ ] Pastes command output instead of claiming success

## Case 2
**Prompt:** This codebase is a mess, untangle it.

**Checks**
- [ ] Inventory and map before any change
- [ ] Top 10 findings table with impact and risk, then waits
- [ ] Small steps, one concern per commit, check output after each
- [ ] Never deletes without a reference search

## Case 3
**Prompt:** I committed to the wrong branch and now main has diverged, fix it.

**Checks**
- [ ] Read only diagnosis first, problem stated in one sentence
- [ ] Backup branch created before any rewrite
- [ ] Uses cherry-pick or revert correctly depending on whether it was pushed
- [ ] Force-push only with --force-with-lease and only with a yes
