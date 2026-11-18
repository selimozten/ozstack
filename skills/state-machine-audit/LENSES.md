# Signals and lenses

Reference for [state-machine-audit](SKILL.md): where machines hide (stage 1) and how they break (stage 3).

## Signals

Each signal marks a candidate machine.

- A status, state, phase, step or stage field; an enum; a string compared against literals.
- Two or more booleans, or nullable timestamps (`paid_at`, `cancelled_at`, `deleted_at`), on one entity. The machine is their product; most combinations are invalid.
- A record whose existence is the state (a row in a join table, a lock file, a key in a cache).
- The same fact held in two stores: database and cache, database and search index, database and chain, database and payment provider, server and client. The machine is the pair, including "they disagree".
- A lifecycle: jobs, outbox rows, sagas, uploads, sessions, tokens, invitations, subscriptions, orders, payments, ledger postings, approvals, migrations, feature flags, deployments.
- A mirror of an external process: a transaction that is pending, confirmed or reorged; a webhook-driven status; a third-party order.
- Client flows: loading, error, optimistic and stale states; multi-step forms; anything gated by "has done X".
- A reducer, a switch over a state value, or an if-chain that begins by checking what already happened.
- **Workarounds**: a guard for "should never happen", a retry loop, a swallowed error, a clamp, a default that hides a missing value, a cleanup job, a repair script, a runbook for manual fixes, a comment that says temporary, hack or for now. Each one means somebody met an unnamed state.

## Lenses

Each lens is a question to put to every machine. The answer is a finding or the mechanism that makes the machine hold.

1. **Duplicate**: the same event arrives twice (retry, double click, redelivered message, replayed webhook). Does the second one change anything?
2. **Concurrent**: two actors act on one entity at once. Look for check-then-act and read-modify-write with no lock, version or constraint between the check and the write.
3. **Crash**: the process dies between two writes of one transition. Which state is left, and does anything recognise it as partial?
4. **Unknown outcome**: a call times out and the caller cannot tell whether it happened. What does the retry assume?
5. **Out of order**: events arrive in a different order than they were sent, or a late event arrives after a terminal state.
6. **Stale actor**: a client, cache or worker acts on a state it read earlier.
7. **Restart**: persisted state from an older run or an older version is loaded by new code.
8. **Disagreement**: the two stores of a mirrored fact diverge (reorg, failed sync, partial rollback). Which one wins, and who notices?
9. **Bypass**: a write site that skips the transition function: admin tools, migrations, seeds, bulk imports, tests' factories used in production paths, raw updates.
10. **Stuck**: a state with no exit, or an exit that depends on an event that may never come. Every non-terminal state needs a way out, including timeout and cancel.
11. **Terminal escape**: a transition out of a state that should be final (reopen, refund after refund, re-run of a finished job).
12. **Undefined combination**: a flag or timestamp combination with no meaning that the schema still allows.
13. **Clock**: an expiry or deadline races the action it limits; clocks differ between machines.
14. **Authority**: a transition fired by an actor who may not fire it, or from a state where that actor may not act.

For lenses 1 and 3, ask what happens when the operation runs twice and when the last run died at each step. For lens 2, first ask whether the actors need to share the state at all. Section 4 of `~/.ozstack/standards/engineering.md` has the rules.
