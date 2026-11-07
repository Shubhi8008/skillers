# Skillers setup

Every skillers mode reads one config file. This mode creates or edits it.

## Where the config lives
Lookup order used by every mode:
1. `$SKILLERS_CONFIG` (environment variable with a full path)
2. `./skillers.config.json` in the current project
3. `~/.skillers/config.json`

Write to option 3 unless the user wants it per project.

## 1. Gather (ask in one message, max 6 questions, offer defaults)
1. Name, how to address them, and a sign-off line if they want one.
2. Writing voice rules (for example: short, plain, no em dashes).
3. Notes vault folder (Obsidian or plain markdown) and a research folder for papers and data.
4. Operating system of the machine that will run scripts, and how Claude reaches it: `desktop-commander` (Claude desktop app on Windows) or `shell` (scripts run where Claude runs).
5. Where the skillers repo is cloned on that machine (`paths.repo`). If not cloned yet, give the clone command: `git clone https://github.com/Shubhi8008/skillers`.
6. Reference sources they can use: Dribbble, Awwwards, Godly, Pinterest (needs sign-in), Cosmos (needs sign-in), Behance, Mobbin (paid).

If the user is away or says "use defaults", fill what is known from context and mark the rest with `"TODO"`.

## 2. Write the file
Start from `config/skillers.config.example.json` in the repo. Keep keys, change values. Paths use the separator of the target OS. Derived paths may reference others with `{paths.vault}` style placeholders.

## 3. Check
- Every folder in `paths` exists, or offer to create it.
- If `runner` is `desktop-commander`, run `git --version` and `python --version` there and note anything missing.
- Read the file back and show the user a 5 line summary.

## 4. Scope lock (optional)
If the user is running a project, create `{paths.vault}/00 Scope Lock.md` from the template in scope mode and set `scope_lock` in the config.

## Rules
- Never write tokens, passwords or keys into the config. If a tool needs a token, tell the user to set an environment variable themselves and record only its name.
- Changing the config later: edit only the keys the user names.
