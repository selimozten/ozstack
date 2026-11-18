---
name: state-machine-audit
description: Documents a codebase's state machines, proves which invalid states are reachable, and fixes them at the root.
disable-model-invocation: true
---

# State machine audit

A **machine** is anything whose legal next step depends on what already happened. Explicit machines have a status field or a reducer. Implicit ones hide in flag combinations, nullable timestamps, rows that exist or not, and two stores that must agree.

The audit writes every machine down as a transition table, attacks each table for **reachable** invalid states, and fixes what it proves at the root.

A **workaround** is code that tolerates a state nobody named: a guard, a retry, a swallowed error, a clamp, a cleanup job, a repair script. Each one is a lead in stage 1 and a debt in the ledger, closed when the root fix deletes it.

## The document

One file holds everything: `docs/state-machines.md` in the repo that owns the code, or the file that repo already uses. Its format is in [DOCUMENT.md](DOCUMENT.md). It is the single source of truth for machines, findings and their status; issues and PRs link to it.

## Stages

Each stage commits its output to the document before the next one starts. A run enters at the first stage whose output is missing. An author agent handed one issue runs stage 6 only.

Under an orchestrator, stages 1 to 4 fan out one child per subsystem. Children do not inherit this skill: give each the absolute paths of this folder's files and its slice. Read-only in stages 1 to 3. A worker's finding is a claim: rerun its command before you grade it.

### 1. Inventory

Sweep the code with the signals in [LENSES.md](LENSES.md#signals). Record every candidate in the ledger as a machine or as dismissed with the reason.

Done when the coverage list names every top-level source directory, every persisted entity (table, collection, contract storage, file), every queue, job and schedule, and every external integration, each with its machines or `none: <reason>`.

### 2. Model

For each machine, write its states, invariants and transition table from the code as it runs today. Take state names from the project's glossary, and add a missing term there. Where the code and the intended design differ, record both.

Done when every write site of the machine's state is cited in a row (`file:line`), and every state × event cell reads as a transition, `rejected (where)`, or `unhandled`. `unhandled` cells are leads for stage 3.

Then add one line to the repo's `AGENTS.md`: a change to a machine's write sites updates its table in the same PR.

### 3. Attack

Apply every lens in [LENSES.md](LENSES.md#lenses) to every machine. Each hit is a finding graded `suspected`, with the code path that reaches it.

Done when every machine lists every lens with a finding ID or `holds: <mechanism, file:line>`.

### 4. Confirm

Build a **red** loop for each suspected finding: a test or script that drives the real code into the invalid state and asserts it. One command, deterministic, seconds long. For races, raise the reproduction rate until the loop is debuggable; where that fails, or the machine is high-stakes, check a model of it per [MODEL-CHECKING.md](MODEL-CHECKING.md). Grade each finding:

- `confirmed`: the command and its red output are in the document.
- `refuted`: the mechanism that prevents it, `file:line`.
- `suspected`: the repro could not be built; say what blocked it.

Only `confirmed` is a bug. Done when every finding carries one grade and its evidence.

### 5. Issue

Rank, group and publish per `~/.ozstack/standards/audits.md`. Each issue also names the machine, the invalid state or transition, and the fix shape from stage 6.

Done when every confirmed finding has an issue link.

### 6. Fix

Fix per the audits standard, where the invalid state is produced. Take the highest rung that fits:

1. **Unrepresentable**: one state field, a discriminated union or a database constraint replaces the flag combination.
2. **One owner**: a single transition function that every write site calls, rejecting illegal moves and comparing the current state before it swaps.
3. **Idempotent**: a retried or replayed transition converges to the same end state.
4. **Guard**: only where the state is legitimate and the code simply failed to handle it.

Delete the workarounds the fix makes dead.

Done when the test is green, the repo's checks pass, the document matches the code, and the listed workarounds are gone.

## Finish

The audit is complete when the ledger shows every finding `fixed`, `refuted`, or `suspected` with an open issue, and every workaround `deleted` or tied to an open issue. Report those counts.
