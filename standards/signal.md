# Signal

Everything written into a repo is read again by every later session, human or agent. **Signal** is what changes what that reader does. **Noise** is everything else: it costs attention on every read and hides the signal beside it.

The test for any comment, paragraph or test: would a reader a year from now, with no memory of the session that wrote it, act differently because it is there?

## Session context stays out

What was just changed, what it replaced, how far the work has come, who asked for it, what was considered: this is true for one session and noise after it. It has a home, and the home is not the code or the docs:

| it says | it goes in |
|---|---|
| what changed and why | the commit message |
| the evidence that it works | the pull request |
| what is left to do | an issue |
| where the work stands | the handoff |

Words that give it away: now, new, previously, no longer, currently, as discussed, for the time being, status.

## Comments

Keep a comment that tells the reader something the code cannot: why it is this way, a constraint from outside, a hazard, the decision it follows.

Delete a comment that repeats the code, narrates its history, marks a section, or holds code that was switched off. A note to do something later is an issue, with a link if it must stay. When code needs a comment to say what it does, rename or restructure until it does not.

## Docs

A doc says what the thing is, how to use it, and what a reader must know that they cannot see by looking. Write the present tense of the system.

Leave out what the environment already states (commands in a config file, the folder tree), what a check does not keep true, and any account of how the doc or the system got here. A README says what it is and how to start.

For documents agents read, one more rule: an instruction the agent already follows by default is noise.

## Tests

Keep a test that can fail for a reason a user of the code would care about, and that says in its name which behaviour broke.

Delete a test that:

- cannot fail: it asserts a constant, a type the compiler holds, or a value computed the same way the code computes it;
- tests the implementation: which internal calls were made, in what order, how many times;
- repeats the path of another test with different names;
- compares against a stored snapshot nobody reads when it changes;
- covers behaviour that no longer exists.

The proof that a test is signal: break the behaviour it names, and it goes red.

## When in doubt

Write less. A missing line is noticed and added by the first reader who needs it; a useless one is read by everyone forever.
