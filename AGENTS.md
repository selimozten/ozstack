# ozstack

Rules for agents changing this repo.

## Layout

| path | what |
|---|---|
| `skills/<name>/` | one user-invoked skill: `SKILL.md` and its own reference files |
| `standards/` | what good work is; read by path as `~/.ozstack/standards/<file>` |
| `templates/` | files to fill in: briefs, the profile, the workspace scaffold |
| `install.sh`, `check.sh` | link the kit into place; hold the rules below |

## What enters

- **General.** It holds in any project and any language. No project, organisation, person, host, account, path or model is named. Rules for one language or framework belong in the repo that uses them.
- **Observed.** It encodes something done by hand several times, or fixes a failure seen in a real session.
- **Small.** If the behaviour composes from what exists, it does not get a new file.
- **Ours.** Ideas from other kits are adapted and credited; the wording is written here.

## Rules

- Run `./check.sh` before every commit. It must pass.
- A `SKILL.md` has `name` equal to its folder, a one-line `description`, `disable-model-invocation: true`, and at most 100 lines.
- A skill defines its leading words, names its one output, and gives stages that each end on "Done when". It states the behaviour wanted; prohibitions are for hard guardrails.
- A file refers to another part of the kit as `~/.ozstack/<path>`, and to its own folder's files by relative link.
- One meaning lives in one place. What audits share is in `standards/audits.md`.
- Every skill and standard is listed in `README.md`. The README says what the kit is and how to start; notes about its current state go in commits.
- Examples are synthetic. Words to refuse can be listed one per line in an untracked `.private-words` file, which `check.sh` reads.
