---
name: workspace
description: Sets up or checks a workspace, the control-plane directory an orchestrator works from.
disable-model-invocation: true
---

# Workspace

A **workspace** is the control plane for one organisation or product: a small git repo that holds the design record and the rules for agents, and ignores the product repos checked out inside it. An orchestrator session starts at its root. One workspace serves one organisation; nothing is shared across two.

## Layout

| path | tracked | what |
|---|---|---|
| `AGENTS.md` | yes | the rules every agent reads; `CLAUDE.md` imports it |
| `repos.tsv` | yes | the repo list and each repo's visibility: the single source of truth |
| `bin/ws` | yes | `sync`, `status`, `visibility` over `repos.tsv` |
| `docs/adr/`, `docs/plans/` | yes | decisions and plans; `GLOSSARY.md` beside them for the domain language |
| `.agents/orchestrator.md` | per choice | the orchestrator profile (format: `~/.ozstack/templates/profile.md`); untracked when it names personal accounts or hosts |
| `repos/<repo>` | no | product repos, each its own git repo |
| `_worktrees/<repo>-<topic>` | no | one worktree per run |
| `.scratch/` | no | session state: `<session>/handoff.md`, `<session>/runs/<key>/` |

The workspace holds documents and its own tooling. Product code, prototypes and generated assets live in their own repos and are linked through `repos.tsv`.

Pick the branch that matches the request: **new**, **adopt** or **check**.

## New

1. Ask for what the templates need: workspace name, the organisation that owns the repos, the repos with visibility and role, the issue tracker, and whether the workspace repo is shared with a team.
2. Copy `~/.ozstack/templates/workspace/` into the new directory: `gitignore` becomes `.gitignore`, `ws` goes to `bin/ws` and is made executable. Fill every `{slot}`; delete a section that has nothing true to say yet.
3. `git init`, then `bin/ws sync`.
4. Write the orchestrator profile with the user: roster, where heavy commands run, the gate, limits, one-way doors.
5. Read each product repo's own `AGENTS.md` and README, and put in the workspace `AGENTS.md` only what spans repos. A repo's own file wins inside that repo.
6. Check that each product repo tells an agent how to run the product and drive it as a user would. Where it does not, that is the first issue to file: agents cannot prove their work without it.
7. Put each guardrail where a tool enforces it (permissions, hooks, branch protection, a sandbox). Prose is for what no tool can hold.

Done when `bin/ws status` lists every repo as present, and a fresh agent could answer from `AGENTS.md` and the profile alone: which repos exist and what each is for, where heavy commands run, how a change gets from issue to merged, and what must never enter the workspace.

## Adopt

For a directory that already works as a workspace but has a different shape. List what exists against the layout table, then propose the moves as a table (from, to, why) and wait for the user's word before moving anything: other sessions may be running from the old paths. Keep history: move with git, and leave live agents' worktrees where they are until their runs end.

Done when the layout table holds and every path named in `AGENTS.md` exists.

## Check

Report drift, changing nothing:

- `bin/ws status` and `bin/ws visibility`.
- Paths, commands and repos named in `AGENTS.md` that no longer exist; facts that the profile and `AGENTS.md` state differently.
- Worktrees whose branch is merged or gone; `.scratch` run folders for merged work; loose files at the `.scratch` root.
- Anything tracked that the layout says is untracked, and any product code inside the workspace repo.
- Secrets or personal data in tracked files: report the file and the kind, never the value.

Done when each bullet has a finding or "clean".

## Rules that hold in every workspace

- A shared workspace repo changes through a branch and a PR, made in a worktree of the workspace itself, so the root stays on its default branch for every session.
- A fact that changes with the week (models, hosts, limits) lives in the profile, in one place.
- When a product repo's behaviour changes, the workspace doc that describes it changes in the same piece of work.
- Examples and seed data are synthetic.
