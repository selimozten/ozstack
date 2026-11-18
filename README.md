# ozstack

A skill kit for building software with coding agents: how the work is run, how quality is found, and the standards it is held to.

One long-running **orchestrator** session plans, briefs, verifies and decides. Authors and reviewers are **child** agents it starts for one piece of work each. Skills are invoked by name and standards are read by path, so nothing sits in an agent's context by default.

## Get started

Give your agent this prompt from the directory you want to work in:

```
Clone https://github.com/selimozten/ozstack (or pull it if it is already cloned) and run ./install.sh.
Then follow ~/.ozstack/skills/workspace/SKILL.md for this directory: "new" if it is empty,
"adopt" if it already holds my repos. Ask me only what you cannot find out yourself.
```

After that, start an orchestrator session in the workspace with `/orchestrate`.

## Skills

| skill | what it does |
|---|---|
| `workspace` | sets up, adopts or checks the directory an orchestrator works from |
| `orchestrate` | the rules of the orchestrator seat |
| `issue-loop` | turns a batch of issues into reviewed draft PRs |
| `pr-loop` | takes open PRs through review to merged |
| `handoff` | ends a session so a fresh one can continue |
| `arch-audit` | maps contexts and dependencies, finds leaks and ceremony, fixes the proven candidates |
| `state-machine-audit` | documents state machines, proves reachable invalid states, fixes them at the root |
| `prune-slop` | removes comments, docs and tests that carry no signal |

## Standards

| file | what it holds |
|---|---|
| `standards/engineering.md` | how code is written: root causes, the smallest complete change, proof |
| `standards/architecture.md` | contexts, ports and adapters, deep modules |
| `standards/audits.md` | what every audit shares: grades, ledger, priority, issues, fixes |
| `standards/signal.md` | what earns a place in a repo: comments, docs and tests a later reader needs |

Templates for briefs, the workspace profile and the workspace scaffold are in `templates/`.

## Install

`./install.sh` links the kit to `~/.ozstack` and each skill into `~/.claude/skills`; `git pull` updates it. The orchestrator skills drive child agents with `hc` (herdr-core); everything else needs no particular tool.

## Credits

MIT licensed. Ideas are adapted from Matt Pocock's skills, pstack by Lauren Tan and the `ponytail` skill, all MIT; the deep-module vocabulary follows John Ousterhout and Michael Feathers.
