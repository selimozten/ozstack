---
name: arch-audit
description: Maps a codebase's contexts and dependencies, finds where structure leaks or adds ceremony, and fixes the proven candidates.
disable-model-invocation: true
---

# Architecture audit

Judges a codebase against `~/.ozstack/standards/architecture.md` in two directions. A **leak** is too little structure: a rule living in the wrong place, a dependency pointing outward. **Ceremony** is too much: surface without depth. Most codebases have both, often side by side.

Grades, the ledger, ranking, issues, fixes and the ratchet are in `~/.ozstack/standards/audits.md`. Read both standards before stage 1.

## The document

One file: `docs/architecture.md` in the repo that owns the code, or the file that repo already uses. Format: [DOCUMENT.md](DOCUMENT.md). It opens with the system's **design intent**, the three or four ideas it is built on, taken from the repo's own decisions. The audit judges the whole against them, not only module by module.

## Stages

Each stage commits its output to the document before the next starts. A run enters at the first stage whose output is missing or stale for its scope. Under an orchestrator, stages 1 to 3 fan out one read-only child per context; give each the absolute paths of the two standards, this folder's files and its slice.

### 0. Scope

Take the area the user named. Otherwise find the hot spots: the paths that change most often and the paths that change together across contexts in recent history. Deepening pays where change happens.

Read the glossary, the recorded decisions and the earlier runs' ledger. List the open PRs and drop what they are changing.

Done when the document states the scope, the design intent, and what was skipped with the reason.

### 1. Map

Write the code as it is: the contexts and how they depend on each other, and for each context in scope its aggregates, its application interface, its ports and adapters, its events, and the data it owns. Derive dependencies from the build's own dependency listing, not from reading.

Done when every package or directory in scope belongs to a context or is listed as unowned, and every dependency between contexts appears on the map with its direction.

### 2. Assess

Apply every lens in [LENSES.md](LENSES.md) to every context in scope, then the cross-context lenses to the map. Each hit is a finding with the code that shows it.

Done when every context lists every lens with a finding ID or `holds: <evidence>`.

### 3. Confirm

Give each finding its grade. A leak is a claim about the code and can be `confirmed`: a dependency listing, a test that passes without the rule, a count of write sites. Ceremony is a design candidate: apply the deletion test, measure what can be measured (callers, forwarding operations, files touched per change), and grade it `confirmed` on those numbers or `judged` with the measurement that would settle it.

Done when every finding has one grade and its evidence.

### 4. Rank and design

Rank per the audits standard. For each of the top candidates, up to four per run, design the new shape **three times** before choosing: once for the smallest possible interface, once to make the most common caller trivial, once strictly by ports at the edge. Under an orchestrator each is a separate child that sees only the problem. Compare on depth, on how many places a future change touches, and on what the tests would cross. Record the chosen shape, the two rejected ones in a line each, and the slices that get there.

Done when each chosen candidate has a before and after diagram, its slices, and the check that will hold it.

### 5. Issue

Per the audits standard. One candidate is one issue, or one issue per slice when slices can merge on their own.

### 6. Fix

Per the audits standard, with these additions:

- Behaviour stays the same unless the finding is a defect; the PR shows the proof.
- Tests cross the new interface. Tests of the modules it replaced are deleted, not kept beside it.
- The repo's instructions, glossary and decision records that the change makes wrong are corrected in the same PR.
- The last slice adds the check, with a baseline if the rule is still broken elsewhere.

Done when the map in the document matches the code and the candidate's row reads `fixed in <PR>`.

## Recurring runs

Run it per area on a schedule that matches how fast the area changes. Each run starts from the ledger: candidates left ranked by the last run come first, and nothing recorded as fixed, in flight or refuted is raised again.
