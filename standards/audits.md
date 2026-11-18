# Audits

What every audit in this kit shares: how a finding is graded, recorded, ranked, issued and fixed. Each audit skill adds its own model and its own lenses.

An **audit** writes down a model of one aspect of a system, attacks the model through a fixed set of **lenses**, and proves what it finds. Its output is one document in the repo that owns the code, kept current after the audit ends.

## Grades

Every finding carries exactly one grade and the evidence for it.

| grade | meaning | evidence in the document |
|---|---|---|
| `confirmed` | a command anyone can rerun shows it | the command and its output: a red test, a dependency listing, a count |
| `suspected` | a path through the code reaches it, not yet shown by a command | the path, file and line, and what blocked the command |
| `judged` | a design opinion | the reasoning, and the measurement that would settle it |
| `refuted` | it cannot happen, or the cost is not real | the mechanism that prevents it, file and line |

Only `confirmed` is a defect. `judged` is for design candidates and never for a claim that code misbehaves. A child's finding is a claim: rerun its command before grading.

## Ledger

One table in the document lists every finding with an ID, its lens, its grade, its priority, its issue and its status. IDs are stable; a number is never reused. Statuses: `open`, `fixed in <PR>`, `refuted`, `parked: <reason>`, `needs the user: <question>`.

A finding that contradicts a recorded decision, or whose fix changes what the product does, is `needs the user`, with a drafted decision record. Work that an open PR is already changing is skipped and noted.

## Priority

Impact first, then reach.

| | reached in normal use | reached by retry or concurrency under normal load | needs a fault |
|---|---|---|---|
| money, irreversible external effect, data loss, security | P0 | P0 | P1 |
| entity stuck or corrupted, manual repair needed | P1 | P1 | P2 |
| wrong display, self-heals | P2 | P3 | P3 |

A design candidate has no failure to rank by. Rank it by what leaving it costs: how often the area changes, how many places a change must touch, and which defects it has already caused.

## Issues

Group by root cause: findings one change fixes are one issue. An issue names the finding IDs, the evidence command, the impact, the shape of the fix, the workarounds it deletes, and acceptance criteria a fresh agent can check. Publish highest priority first and write each issue link into the ledger. A high-priority `suspected` finding gets an issue to build its command.

## Fixes

- One issue per branch and PR. The platform keeps working: each PR passes the repo's full checks on its own and changes only the behaviour its issue names.
- The command that shows the finding is committed first and seen red; the fix turns it green.
- A structural change that should not alter behaviour proves it: the same inputs give the same outputs before and after.
- Every caller moves to the new shape and the old path is deleted in the same piece of work. Two paths left side by side is an unfinished fix.
- Records already in a bad state are counted and repaired in the same PR.
- The document is updated in the same PR: the model, and the finding's status with the PR link.

## Ratchet

A fix ends with a check that fails if the finding returns. When the same rule is already broken elsewhere, the check ships with a **baseline**: the existing violations are listed, new ones fail, and the list may only shrink. A rule held only by review will be broken again.

## Finish

An audit run is complete when every finding in its scope is `fixed`, `refuted`, `parked`, or open with an issue. Report those counts.
