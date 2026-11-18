# ozstack

A skill kit for working with coding agents through one orchestrator: how the work is run, and the standards it is held to. Everything here is general: no project, organisation, host or person is named. What is true in only one workspace lives in that workspace.

Status: early. `state-machine-audit` and `ref/engineering.md` are settled; the orchestrator skills and `workspace` are new and will change as they are used.

## The pattern

One long-running orchestrator session (a large model) plans, briefs, verifies and decides. Authors and reviewers are child agents it starts with `hc` (herdr-core) inside Herdr, on lean harnesses. Small one-off tasks can still go to a single agent with a brief and `ref/engineering.md`.

| shelf | reader | how it is reached | context cost |
|---|---|---|---|
| `skills/` | the orchestrator | the user types `/<name>`, or a handoff names it | none until invoked |
| `ref/` | any agent | its brief names the file's path | none until read |

Nothing here is listed in a child's system prompt. A child gets one brief; the brief names what to read.

## skills/

| skill | when |
|---|---|
| `workspace` | set up, adopt or check the control-plane directory an orchestrator works from |
| `orchestrate` | start of every orchestrator session; the rules the loops rest on |
| `issue-loop` | turn a batch of issues into reviewed draft PRs |
| `pr-loop` | take open PRs through review to merged |
| `handoff` | end a session so a fresh one can continue |
| `state-machine-audit` | find, document and fix reachable invalid states |

## ref/

| file | for |
|---|---|
| `engineering.md` | every author and reviewer: how code is written |

## What belongs where

| it is true… | it lives in |
|---|---|
| in every project | this kit |
| in one workspace (repos, model roster, launch lines, hosts, gate, limits) | that workspace's `.agents/orchestrator.md` (format: `skills/orchestrate/PROFILE.md`) |
| in one repo (how to add a module, its checks, its PR form) | that repo's `AGENTS.md` and project skills |

Model names, hosts, accounts and paths change and are private: they go in a profile, never here.

## Install

`./install.sh` links each skill into `~/.claude/skills` (override with `CLAUDE_SKILLS_DIR`). It skips a name that already exists there and is not a link into this repo, and says so. Requires `hc` for the orchestrator skills.

## Adding to the kit

A skill earns a place after the thing has been done by hand at least three times. Keep `SKILL.md` under 100 lines, end every step on a checkable done condition, state the target behaviour instead of listing prohibitions, and use synthetic examples.

## Credits

MIT licensed; see `LICENSE`. Ideas and some structure are adapted from Matt Pocock's skills (`mattpocock/skills`) and pstack, both MIT licensed. Text here is rewritten; where a passage is carried over closely, the file says so.
