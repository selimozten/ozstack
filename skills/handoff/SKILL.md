---
name: handoff
description: Writes the orchestrator's handoff so a fresh session can continue.
disable-model-invocation: true
---

# Handoff

Write `handoff.md` in the state directory the workspace profile names, replacing the old one (move the old one to `handoff-<date>.md` beside it). A fresh orchestrator reads only this file and the profile, so it must be able to act from them alone.

Sections, in this order:

1. **Read first**: the two or three commands that show live state (your children, the open PRs).
2. **Children**: one line each: name, harness and model, run, what it is doing now, what it waits on, what to do when it reports.
3. **Ready to merge / blocked**: PR, head SHA you verified, what is missing.
4. **Owed**: work promised and not done (docs, comments, cleanups).
5. **Waiting on the user**: each question with your recommendation.
6. **Timers**: monitors, scheduled jobs and background terminals to re-arm or to check are gone.
7. **Lessons**: only what is not yet in the profile or the kit; then move it there.

Point to PRs, issues and run folders instead of repeating them. Leave out secrets and personal data. Start children that must survive the restart with the flag `hc --skill` names for outliving their parent.

Done when someone with no memory of this session could name the next three actions from the file.
