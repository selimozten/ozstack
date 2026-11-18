# ozstack

A skill kit for building software with coding agents: how the work is run, how quality is found, and the standards it is held to. It is general by rule: no project, language or person is named.

## The pattern

One long-running **orchestrator** session plans, briefs, verifies and decides. Authors and reviewers are **child** agents it starts for one **run** each. Small tasks can still go to a single agent with a brief and the standards.

Nothing here sits in an agent's context by default. Skills are invoked by name; standards are read by path because a brief names them.

## Skills

| skill | what it does | status |
|---|---|---|
| `workspace` | sets up, adopts or checks the control-plane directory an orchestrator works from | draft |
| `orchestrate` | the rules of the orchestrator seat; read at the start of a session | draft |
| `issue-loop` | turns a batch of issues into reviewed draft PRs | draft |
| `pr-loop` | takes open PRs through review to merged | draft |
| `handoff` | ends a session so a fresh one can continue | draft |
| `arch-audit` | maps contexts and dependencies, finds leaks and ceremony, fixes the proven candidates | draft |
| `state-machine-audit` | documents state machines, proves reachable invalid states, fixes them at the root | draft |

## Standards

| file | what it holds | status |
|---|---|---|
| `standards/engineering.md` | how code is written: root causes, the smallest complete change, proof | draft |
| `standards/architecture.md` | contexts, ports and adapters, deep modules | draft |
| `standards/audits.md` | what every audit shares: grades, ledger, priority, issues, fixes, the ratchet | draft |

## Templates

`templates/briefs.md` (author, reviewer, send-back), `templates/profile.md` (the workspace profile), `templates/workspace/` (the workspace scaffold).

## What belongs where

| it is true… | it lives in |
|---|---|
| in every project | this kit |
| in one workspace (repos, roster, launch lines, hosts, gate, limits) | that workspace's `.agents/orchestrator.md` |
| in one repo or one language (how it is built, its checks, its idioms) | that repo's own instructions and skills |

## Install

```sh
git clone https://github.com/selimozten/ozstack && cd ozstack && ./install.sh
```

This links the kit to `~/.ozstack` and each skill into `~/.claude/skills`. A name that already exists and is not this kit's link is skipped and reported. `git pull` updates everything.

The orchestrator skills (`orchestrate`, `issue-loop`, `pr-loop`, `handoff`) drive child agents with `hc` (herdr-core). The audits, the standards and `workspace` need no particular tool.

## Contributing

`AGENTS.md` has the bar and the rules. `./check.sh` must pass.

## Credits

MIT licensed. Ideas are adapted from Matt Pocock's skills (`mattpocock/skills`) and from pstack by Lauren Tan, both MIT; the deep-module vocabulary follows John Ousterhout and Michael Feathers. The wording here is our own.
