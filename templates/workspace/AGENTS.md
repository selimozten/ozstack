# {name} workspace

Instructions for every coding agent in this workspace. `CLAUDE.md` imports this file. Keep shared rules here.

This root is the control plane for {product or organisation}. It holds {what: decisions, plans, glossary} and ignores `repos/`, where the product repos are checked out.

## Repos

[`repos.tsv`](./repos.tsv) is the source of truth for the repo list and each repo's visibility.

| repo | visibility | stack | role |
|---|---|---|---|
| `{repo}` | {public or private} | {stack} | {one line} |

Each repo's own `AGENTS.md`, README and CI config win over this file for work inside that repo.

## Docs

| path | what |
|---|---|
| `GLOSSARY.md` | the domain language; use its terms in plans, decisions and code |
| `docs/adr/` | decisions, numbered `NNNN-short-title.md`; supersede an accepted one with a new one |
| `docs/plans/` | plans, each opening with a `Status` line kept current |

## Working rules

- This repo holds documents and its own tooling in `bin/`. Code lives in its own repo, linked from `repos.tsv`.
- {Shared repo: commit on a branch in `_worktrees/ws-<topic>` and open a PR.}
- Work inside one product repo at a time, in `_worktrees/<repo>-<topic>`.
- Run the owning repo's checks before calling a change done, and report the checks actually run.
- Secrets, `.env` contents and real customer or personal data stay out of this repo and out of notes. Examples are synthetic.
- Session notes, drafts and evidence go in `.scratch/` (ignored). Promote what lasts into `docs/`.
- `bin/ws sync` clones missing repos and fast-forwards clean default branches. `bin/ws status` shows each repo's state. `bin/ws visibility` checks the host against `repos.tsv`.

## How agent work runs

{How a change gets from issue to merged here: who authors, who reviews, what the gate is, where heavy commands run, branch and commit form. Point to the orchestrator profile for anything that changes weekly.}

## Issue tracker

{Where issues live for code, and for product or cross-repo questions.}
