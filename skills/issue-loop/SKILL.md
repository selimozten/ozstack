---
name: issue-loop
description: Turns a batch of issues into reviewed draft PRs through hc child authors.
disable-model-invocation: true
---

# Issue loop

Issues in, gated draft PRs out. It runs under the `orchestrate` skill, whose rules (briefs, reports are claims, capacity) apply to every step; read it first if it is not in context. Merging belongs to `pr-loop`.

## 1. Triage

List open issues and open PRs for each repo in the profile. For every issue that looks like open work, check whether it is already fixed: the base branch's log, linked PRs, the live behaviour.

Sort each into **now**, or **waiting** (blocked, needs the user, deferred) with the reason.

Done when every open issue is in one of the two lists.

## 2. Plan waves

Group the **now** issues into waves of authors on disjoint areas, sized to the profile's agent cap minus the reviewers you will need. Order: security and broken behaviour, then work that unblocks other work, then features. Issues that edit the same files go in sequence.

State the plan in a few lines, then start. The user can redirect while it runs.

## 3. Launch

Per issue: create the worktree and branch in the profile's form, write `runs/<key>/brief.md` from the author template with a real Focus, and start the child with the roster's launch line.

Done when every issue in the wave has a live child whose first message was delivered.

## 4. Validate each report

When a child reports, read the diff yourself, then check each claim in the report against the source: the premise check, the root cause, the red-then-green evidence, the gate line on the PR's current head.

Send back anything below `~/.ozstack/standards/engineering.md`. A premise the child disproved closes the run: comment on the issue with its evidence.

Done when the PR's head is one you have verified.

## 5. Review

Start a fresh reviewer with the reviewer template. Verify each finding in the source; send the real ones to the author; answer the rest on the PR with the reason. Repeat with a fresh reviewer on the new commits until a round finds nothing new.

Post the loop on the PR as its self-review record: each finding fixed (with the commit) or answered.

Done when no finding is open and the gate line matches the head.

## 6. Hand to pr-loop

A PR that passed 4 and 5 is ready for `pr-loop`'s merge step. Close the author and reviewer. Start the next wave when slots free up; do not wait for the whole wave.

## 7. Report

Per issue: PR, what changed, evidence, what is open. List the **waiting** issues with what each waits on.
