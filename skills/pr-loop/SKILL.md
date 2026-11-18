---
name: pr-loop
description: Takes open PRs through fresh review and fixes to a batch merge, through hc child agents.
disable-model-invocation: true
---

# PR loop

Open PRs in, merged code out. It runs under the `orchestrate` skill; read it first if it is not in context.

## 1. Collect the queue

List open PRs for each repo in the profile with head SHA, base, draft state, author, mergeability and files.

- **In scope**: PRs from your own runs, and ready PRs on the profile's base branch.
- **Needs the user's word**: a PR by another person, a promotion between long-lived branches, anything on the profile's one-way-door list. These still get a review, posted as a comment.

Done when every open PR is in scope, waiting on the user, or left alone with a reason.

## 2. Review

A PR that already carries a finished review loop on its current head (from `issue-loop`) skips to step 4. Every other PR gets a fresh reviewer per the reviewer template, all in parallel within the cap. Validate the PR's premise like an issue's: a PR that fixes a non-problem gets that said on the PR.

## 3. Fix

Verified findings go to an author child on the PR's branch (the original author if it is still alive). After each push, confirm the PR head is the commit you verified, and rerun review on the new commits only. Comment on the PR: each finding fixed with its SHA, or answered with the reason.

Done when no finding is open on the current head.

## 4. Merge in a batch

The base may have moved since the gate ran. For each PR, check against the current base: merges cleanly, shares no hand-edited or generated file with a PR that merged since, gate line still on the head. Record that check on the PR, or rerun the gate.

Sort:

- **independent**: passes the check and shares no file with another batch PR. Merge these back to back.
- **chained**: stacked, or sharing files or a contract (an API shape, a migration number). Merge in order; after each, bring the next up to date and rerun its gate.
- **blocked**: red gate, open finding, conflict, or waiting on the user.

Merge with the profile's method. Then verify the base once at its final head, the way the profile says.

Done when every in-scope PR is merged or blocked with a stated reason.

## 5. After the merge

Do what the profile says is owed: companion docs, issue comments, previews. Remove the merged runs' worktrees and run folders and close their children.

## 6. Report

Merged (with SHAs), blocked (with reasons), owed work done, and what needs the user.
