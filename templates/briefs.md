# Briefs

Templates for the first message a child receives. Fill every `{slot}`; delete a line that does not apply. Paths are absolute. Name `~/.ozstack/standards/architecture.md` as well when the task changes structure.

## Author

```
You are an unattended author on one task in {repo}. Your checkout is {worktree}, on branch {branch} from current {base}. Your orchestrator is the hc terminal {orchestrator}.

Task: {issue or task, with the command that shows it, e.g. gh issue view N -R owner/repo --comments}

Read first, in full: ~/.ozstack/standards/engineering.md, the repo's AGENTS.md, and {the files, docs and precedents this task rests on}.

Acceptance: {three to five observable results that mean done; the reviewer gets the same list}

Focus: {the invariants at stake; the cheapest wrong fix to avoid; when to stop and report instead of continuing}

Checks: {where and how heavy commands run, from the profile; the exact gate command and the line that proves it passed}

Deliver: {commit form}; {push and draft PR, or commit only}; PR body with Summary, Evidence (commands and their output lines; for an interface, a before and after capture on this revision), and what is left open.

Limits: {scope fence: only these paths}; no subagents; {the profile's guardrails}.

Report once, when done or blocked:
  hc send {orchestrator} "{key}: <PR url or commit> : <cause, fix, evidence, or the blocker>"
Longer reports go in {run folder}/report.md; send the path. Then wait: findings may follow, and each gets a commit and a new report.
```

## Reviewer

```
You are a fresh, independent reviewer of {PR or branch} in {repo}. You have none of the author's context.

Read-only: on the repo, on GitHub, and on this machine's CPU ({what counts as heavy, from the profile}). No subagents. Read committed state at {worktree}; first run git rev-parse HEAD (expected {sha}) and report it.

Context: {issue}, {PR with comments}, the repo's AGENTS.md, ~/.ozstack/standards/engineering.md.

What this change is: {two or three sentences in your own words}

Acceptance, as given to the author: {the same list}. Check each against the running product or its output, not against the PR text.

The question for every line: {the one way this change can be wrong that matters most}

Try to break each of these, with file:line:
1. {specific risk}
2. {specific risk}
3. Leftovers: debug code, skipped or loosened tests, suppressions, workarounds as engineering.md defines them.
4. Anything in the diff outside the stated scope: is it needed, is it safe?

Write {run folder}/review-{n}.md: head SHA; findings by severity, each with file:line, the failing scenario and the expected fix; "none found" stated per numbered item that holds; last line VERDICT: approve | changes | reject.

Report: hc send {orchestrator} "{key} review {n}: <verdict>, <count> findings, <path>"
```

## Send-back

```
{key}, round {n}. Findings to fix, each with its own commit:
1. {file:line}: {scenario that fails}. Expected: {fix}.
Not accepted as is: {anything you reject, and why}.
Rerun {checks} on the new head and report the same way.
```

## Writing the Focus and the risks

These two slots are where your judgment goes; the rest is form. Name the invariant, the neighbour most likely to break, and the cheapest wrong fix the child might reach for. A reviewer brief with generic risks gets a generic review.
