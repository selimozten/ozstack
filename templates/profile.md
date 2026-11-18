# Workspace profile

Format of `<workspace>/.agents/orchestrator.md`: the facts of one workspace that the skills in this kit read. It is the single place for anything that changes with the week (models, hosts, limits). When a rule changes, edit the line; history lives in the session logs.

```md
# Orchestrator profile: <workspace>

Updated <date>.

## Direction
<two or three lines: what open questions are decided toward>

## Repos
| repo | checkout | base branch | tracker | branch form | commit form |

## State
State directory: <path>. Worktrees: <path pattern>.

## Roster
| role | harness and model | launch line | use for |
<author, UI author, reviewer, cheap author; the full hc run line for each, flags included>

Launch notes: <dialogs, trust prompts, quota behaviour: only what has bitten>

## Heavy commands
<what counts as heavy; the wrapper to run it through; hosts; slots>

## Gate
<the command; the line that proves a pass; what a PR must quote>

## Review
<who reviews what; trust-sensitive areas that need a stronger reviewer; the verdict line>

## Merge
<merge method; batch rules; what is owed after a merge (docs, previews)>

## Limits
Agents at once: <n>. Free disk to keep: <n GB>. Context threshold for handoff: <n>.

## One-way doors
<the short list that waits for the user>

## Guardrails
<data rules, hosts never to touch, flags never to use>
```
