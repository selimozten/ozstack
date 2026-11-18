# Engineering guidelines

How code is written in my projects. Every author and reviewer brief names this file. The repo's own `AGENTS.md` wins where it says more.

## 1. Understand before you change

Read the repo's `AGENTS.md`, then the code the task names, in full, with its tests and its callers. Check the task's premise against the code as it is: issues are often written from a grep. A premise that is wrong or already fixed ends the task: report it with the evidence and change nothing.

## 2. Work through the problem

Fix the place where the wrong state is produced. The place it surfaced is only where it became visible.

A **workaround** tolerates a state instead of preventing it: a sleep, a retry, a skipped or loosened test, a lint or type suppression, a swallowed error, a clamp, a default that hides a missing value, a guard for "should never happen". When the root fix is larger than the task, stop and report what it would take. The orchestrator decides; a workaround is never the quiet fallback.

A guard is a fix only when the state is legitimate and the code simply failed to handle it.

## 3. The smallest complete change

(The ladder is adapted from the MIT-licensed `ponytail` skill.)

Stop at the first rung that holds:

1. The behaviour already exists: add nothing, show the evidence.
2. The codebase has the primitive or pattern: reuse it.
3. The standard library or platform covers it.
4. An installed dependency covers it.
5. A direct local change: the fewest clear lines in the fewest files.

Size is measured after the cause is fixed: a larger change that removes the cause beats a small patch that leaves it, because the next agent copies whatever it finds. An abstraction needs two concrete call sites today. Prefer deleting to adding and boring to clever. Match the surrounding style, naming and comment voice. Complete means the tests, the docs the repo keeps and the generated files are all current.

## 4. Give state one shape and one owner

- One field or union for a lifecycle, so an invalid combination cannot be written.
- One function that performs each transition; every write site calls it.
- Every operation that can be retried or interrupted converges: ask what happens if it runs twice, and if the last run died at each step.
- External data is parsed into a type at the boundary and trusted after it.
- A module talks to another through its declared interface.

## 5. Prove it

- The test comes first and is seen red, at a public interface, with an expected value from an independent source (a literal, a worked example, the spec).
- Run the real thing, the way its user would: drive the interface, call the API, run the command. "It compiles" and "the test file exists" are proxies.
- Evidence fits the product and is tied to a revision: for an interface, a before and after capture of the interaction; for a number, the same measurement on both revisions.
- For a flake, raise the reproduction rate on unchanged code first, then show the fixed test green many times.
- A failure you believe is older than your change is shown red on the unchanged base before you call it that.
- Report the commands you ran with their counts, including skips.

## 6. Make the right path the easy path

When the same mistake could be made again, remove the chance where it is cheapest to enforce, in this order:

1. **The code**: a type, an invariant or a boundary that makes the mistake impossible to write.
2. **A check**: a lint rule, a test or a CI step that fails on it.
3. **Prose**: a line in the repo's instructions, kept short.
4. **Review**: a person or agent catching it each time.

A finding that a reviewer raises twice moves up this list.

## 7. Stay inside the task

Touch only what the task needs. Regenerate generated files with the repo's tool. A defect you find outside the task goes in your report, with file and line, for its own issue.

## 8. Guardrails

Synthetic data only; secrets stay in the environment. Hooks stay on (`--no-verify` is never the answer), history that is pushed stays as it is, and other agents' worktrees and processes are theirs. Heavy commands run where the brief says.

## 9. Report

Lead with the outcome, then the evidence, then what is open. Long reports go in a file; send its path. Say "blocked" as soon as you are, with what you tried.
