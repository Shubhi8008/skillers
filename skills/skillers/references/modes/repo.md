# Repo mode

Three jobs, one mode. Pick the part that matches the request; run part A's rules for any commit in B or C.

| Part | Use when |
|---|---|
| A. Repo craft | creating, publishing or tidying a repo; commits, branches, PRs, releases |
| B. Codebase untangle | messy code, refactor, cleanup, "understand this repo" |
| C. History untangle | git is in a mess: mixed changes, diverged branches, conflicts, lost work, secrets or large files in history |

## A. Repo craft
### Non-negotiable rules
1. No direct push to the default branch once a repo has history: branch, then PR. The only exception is the very first commit of an empty repo, and only if the owner asked for it.
2. Commit before rebase: add, commit, fetch, rebase, push.
3. Force-push only with `--force-with-lease`, never plain `--force`, and never on a shared default branch.
4. Never say tested, verified or working without pasting the command output that shows it.
5. Never commit secrets, tokens, `.env` files, personal data or large binaries.
6. Commit messages state what changed and why. No praise words ("improved", "better", "robust") without the fact behind them.
7. Interactive git (`add -i`, `add -p`, `rebase -i`) is not available to agents. Use the non-interactive methods below.

### 1. New repo checklist
- `README.md`: what it is, who it is for, install, quick start, status (alpha, beta, stable), how to contribute. Short.
- `LICENSE`: ask the owner. Default suggestion: MIT for code, CC-BY-4.0 for docs and content. No license means all rights reserved; say so.
- `.gitignore`: language template plus OS files, build output, env files, local data.
- `CHANGELOG.md` with `## <version> (<date>)` entries. Versions follow semver: `0.x` while unstable, add `-beta.N` for pre-releases.
- `CLAUDE.md` or `AGENTS.md`: layout, rules for changes, how to test. Keep it under 60 lines.
- One obvious top-level layout: source, tests, docs, scripts, config examples. No loose files at the root beyond the ones above and manifests.
- Config examples go in `config/*.example.*`; real config is gitignored.

### 2. Commits
Format (Conventional Commits): `type(scope): summary` with type in `feat, fix, docs, refactor, test, chore, build, ci, perf, style, revert`. Summary in imperative, under 72 characters. Body: what changed and why, wrapped at 72. Breaking change: `!` after type plus a `BREAKING CHANGE:` footer.

Atomic commits: one logical change each, so it can be reverted or bisected alone.
- Inspect first: `git status --short` and `git diff --stat`, then `git diff <file>` for each file.
- Group files by purpose, then `git add <files>` and commit per group.
- To split one file into two commits without `add -p`: write the hunks you want into a patch (`git diff <file> > all.patch`, edit a copy to keep only the wanted hunks), then `git apply --cached part.patch`, commit, and repeat with the rest.
- Before committing, scan the staged diff for secrets: `git diff --cached | grep -nE '(api[_-]?key|secret|token|password|BEGIN [A-Z ]*PRIVATE KEY)'`. Stop if anything matches and ask.

### 3. Branches and PRs
- Branch names: `type/short-topic` (for example `feat/reference-collage`, `fix/harvest-rate-limit`).
- Keep a branch to one topic. Rebase on the default branch before opening the PR.
- PR description: what, why, how to test (with commands), risks, linked issues. Paste test output.
- Merge only when checks pass and review threads are resolved. Prefer merge or rebase merge over squash unless the owner wants squash.
- After merge: delete the branch locally and on the remote.

### 4. Releases
- Update `CHANGELOG.md`, bump the version in manifests, commit `chore(release): vX.Y.Z`.
- Tag: `git tag -a vX.Y.Z -m "vX.Y.Z"` and push the tag.
- GitHub release notes from the changelog entry: `gh release create vX.Y.Z --notes-file <file>` (add `--prerelease` for beta).

### 5. Non-interactive rebase recipes
- Reword or reorder without an editor: `GIT_SEQUENCE_EDITOR="sed -i 's/^pick <sha>/reword <sha>/'" git rebase -i <base>` with `GIT_EDITOR` set to a script that writes the new message.
- Fixups: `git commit --fixup <sha>` then `GIT_SEQUENCE_EDITOR=: git rebase -i --autosquash <base>`.
- Always create a safety branch first: `git branch backup/<topic>-<date>`.

### 6. Health check (run on any repo you touch)
Report, do not fix without asking: default branch protection, untracked large files (`git ls-files -s | sort -k4 -n | tail`), files over 5 MB in history (`git rev-list --objects --all | git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' | sort -k3 -n | tail`), missing README, license or .gitignore, stale branches, secrets patterns in tracked files.

### Sources
Rules consolidated from netresearch/git-workflow-skill (MIT, CC-BY-SA-4.0), musoyangrigor/gitx-skill, obra/superpowers finishing-a-development-branch, Conventional Commits 1.0, Semantic Versioning 2.0.

## B. Codebase untangle
Map first, cut second. Behaviour must stay the same unless the owner asks for a change.

### 1. Inventory (read only)
- Tree two levels deep, ignoring build output and dependencies.
- Languages and size: count files and lines per language.
- Entry points: main files, CLI commands, routes, scripts in manifests, scheduled jobs.
- How to build, run and test. Run the tests once and paste the result. If there are no tests, say so.
- Write the map to `docs/codebase-map.md` (or show it in chat if writing is not wanted): folders and their job, entry points, data flow in 5 to 10 lines.

### 2. Find the tangles
Score each finding by impact (1 to 3) and risk to fix (1 to 3).
- **Dead code:** files and exports nothing imports; scripts no manifest or doc mentions. Confirm with a search for every reference before calling it dead.
- **Duplicates:** near-identical files or functions (same name in two places, copied blocks).
- **Naming drift:** the same thing called two names, or two things called one name.
- **Cycles:** modules that import each other.
- **Oversized units:** files over ~400 lines or functions over ~60 lines that do several jobs.
- **Hardcoded values:** paths, URLs, keys and user data that belong in config.
- **Config sprawl:** the same setting defined in several places.
- **Stale docs:** README or comments that describe code that no longer exists.

Report the top 10 as a table: finding, where, impact, risk, proposed fix. Stop and let the owner choose before changing anything.

### 3. Plan in small safe steps
Order: highest impact with lowest risk first. Each step:
1. One concern only (move, rename, extract, delete, or config).
2. Has a check that proves behaviour is unchanged: existing tests, a new characterisation test, or a before and after command output.
3. Is one commit (see part A for message format).

### 4. Execute
- Create a branch and a backup branch first.
- Move files with `git mv` so history follows them.
- Rename across the codebase with a search for every occurrence, including docs, configs and scripts.
- Delete dead code only after step 2 confirmed no references. Keep a list of what was deleted in the PR description.
- After each step run the check and paste the output. If it fails, revert that step, do not stack fixes.

### 5. Finish
Update the codebase map, the README and the changelog. Summarise: what moved, what was deleted, what is still tangled and why it was left.

### Rules
- Never mix a refactor with a behaviour change in one commit.
- Never delete without a reference search.
- Never claim a step passed without pasted output.
- If the codebase is too large to map in one pass, map one top-level folder at a time and say which ones are not mapped yet.

### Sources
Informed by Hao0321/claude-skill-code-cleanup (duplicates, naming drift, read-only audit first), obra/superpowers (verification before completion), and refactoring practice from Fowler, Refactoring (2nd ed.).

## C. History untangle
### Safety first (always)
1. Read only diagnosis before any change.
2. Make a backup before any history change: `git branch backup/untangle-$(date +%Y%m%d-%H%M)` and, for uncommitted work, `git stash push -u -m untangle-backup` or a WIP commit on the backup branch.
3. History rewrites on shared branches (anything pushed and used by others) need the owner's explicit yes. Explain who is affected.
4. Push rewritten branches only with `--force-with-lease`.
5. Agents cannot use interactive git. Use the recipes below.

### 1. Diagnose
Run and summarise in plain words:
- `git status --short --branch` (dirty files, ahead or behind)
- `git log --oneline --graph --decorate -n 30 --all`
- `git branch -vv` and `git branch -r --merged origin/<default>` (stale branches)
- `git stash list`
- In-progress operations: `.git/MERGE_HEAD`, `.git/rebase-merge`, `.git/rebase-apply`, `.git/CHERRY_PICK_HEAD`
- Large files and secret patterns (see part A, health check)
Then state the problem in one sentence and the plan in 3 to 6 steps. Wait for a yes if any step rewrites history.

### 2. Recipes
**Mixed uncommitted changes into clean commits:** group by purpose, `git add <files>` per group; split a file with a trimmed patch and `git apply --cached`.

**Undo the last commit, keep the changes:** `git reset --soft HEAD~1`.

**Commit landed on the wrong branch:** note the sha, `git switch <right-branch> && git cherry-pick <sha>`, then remove it from the wrong branch with `git reset --hard HEAD~1` only if unpushed, else `git revert <sha>`.

**Diverged branch:** `git fetch`, then `git rebase origin/<base>` for a private branch, or `git merge origin/<base>` for a shared one.

**Conflicts:** list them with `git diff --name-only --diff-filter=U`. Resolve file by file, keeping both sides' intent; never take `--ours` or `--theirs` wholesale without reading both. After resolving, run the tests, then `git add` and `git rebase --continue` or `git commit`. Abort cleanly with `--abort` if it goes wrong.

**Squash or reorder without an editor:** `git commit --fixup <sha>` then `GIT_SEQUENCE_EDITOR=: git rebase -i --autosquash <base>`; or set `GIT_SEQUENCE_EDITOR` to a sed command that rewrites the todo list.

**Split a big commit:** `git reset --soft <sha>~1` on a backup-protected branch, then recommit in groups.

**Lost work:** `git reflog -n 50`, find the sha, `git branch rescue/<name> <sha>`. Dangling stashes: `git fsck --no-reflog | grep commit`.

**Stale branches:** list merged ones, ask, then `git branch -d` locally and `git push origin --delete` remotely.

**Large files or secrets in history:** stop and tell the owner. Rotate any leaked secret first (rewriting history does not un-leak it). Rewriting needs `git filter-repo` and a coordinated force-push; do it only with explicit approval.

### 3. Verify and report
- `git log --oneline --graph -n 20`, `git status`, tests run with output pasted.
- Report: what changed, where the backup branch is, what is left, and how to undo (`git reset --hard backup/...`).
- Delete the backup branch only when the owner confirms.

### Sources
Consolidated from netresearch/git-workflow-skill (advanced git, merge gate), musoyangrigor/gitx-skill (commit splitting, conflict resolution, doctor), obra/superpowers finishing-a-development-branch, and the git documentation.
