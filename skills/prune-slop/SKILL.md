---
name: prune-slop
description: Removes comments, docs and tests that carry no signal from a diff, a path or a repo.
disable-model-invocation: true
---

# Prune slop

Applies `~/.ozstack/standards/signal.md` to text that already exists. Read it first. **Signal** changes what a later reader does; **noise** is the rest. Pruning deletes noise and rewrites what is half of each. It changes no behaviour.

## 1. Scope

Take what the user named: a diff, a path, or the whole repo. For a diff, prune only the lines it adds. For a repo, go one directory at a time, most-read files first: the README, the agent instructions, then code.

Done when the scope is one list of files.

## 2. Sweep

Read every comment, every doc paragraph and every test in scope, and give each one verdict:

- **keep**: it passes the standard's test.
- **delete**: it is session context, repeats what is beside it or what another file already states, or cannot fail. Where two files state the same thing, keep it in the one that owns it and point there from the other.
- **rewrite**: it holds one fact worth keeping inside noise. Write the fact in one line.
- **move**: it is true and useful but in the wrong home (a commit message, an issue, a decision record). Say where it goes.

Done when every item in scope has a verdict. Items you kept need no note.

## 3. Prove the tests

A test is deleted only on evidence, one of:

- it still passes with the behaviour it names broken (show the break and the green result);
- another named test crosses the same path with the same assertion;
- the behaviour it covers is gone from the code.

For each deleted test, name what still covers that behaviour, or state that nothing did and the deleted test did not either. A test that is weak but the only cover is rewritten until it goes red on the break.

Done when every test verdict of delete or rewrite carries its evidence.

## 4. Apply

Make the edits. Keep the change to pruning: no renames, no refactors, no fixes to what you noticed on the way; those go in the report. Run the repo's checks.

Done when the checks pass and the diff contains only deletions, one-line rewrites and moves.

## 5. Report

Counts per verdict for comments, docs and tests; the tests deleted with their evidence; what was moved and where; and anything found that pruning should not fix, with file and line.
