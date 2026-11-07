---
name: skillers-scope-guard
description: Use at the start of any task on a project that has a scope lock in the skillers config, to stay on the user's brief and stop drift. Also use when the user says we are drifting, stay on brief, or lock the scope.
---

# Scope guard

## Config
Read the skillers config first: `$SKILLERS_CONFIG`, else `./skillers.config.json`, else `~/.skillers/config.json`. The scope lock file is `{scope_lock}`. If there is no config or no scope lock, offer to create one with the template below and stop until the user agrees.

## 1. Read the scope lock
It holds the brief, what is in and out of scope, the current phase and the next step.

## 2. Drift check before each task
1. Did the user ask for this in their latest message, or is it the next step in the scope lock?
2. Does it serve the brief?
If both are no, do not do it. Mention it in one line as an option and wait.

## 3. Ending a reply
Any suggested next step must be the scope lock's next step or something the user asked for. No side quests.

## 4. Keep the lock current
When the user changes the phase, next step or scope, update the scope lock in the same turn and say what changed in one line.

## Template
```markdown
---
title: Scope lock
status: active
---
# Scope lock

## The brief
<the user's request in their words, condensed>

## In scope
1. ...

## Out of scope (do not start without the user asking)
- ...

## Current phase
...

## Next step
...

## Drift check (run before every task)
1. Did the user ask for this, or is it the next step?
2. Does it serve the brief?
3. If both are no: name it in one line and wait.
```
