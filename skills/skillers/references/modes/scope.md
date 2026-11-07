# Scope guard

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
Use `references/scope-lock-template.md`.
