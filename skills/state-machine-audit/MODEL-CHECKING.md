# Model checking

Optional branch of [state-machine-audit](SKILL.md), stage 4. A model checker explores every ordering of a machine's transitions within stated bounds and returns the shortest path to a broken invariant. Use it where a test cannot be made reliably red.

## When it earns its cost

- A finding from the Concurrent, Crash, Out of order or Disagreement lens that the red loop reproduces rarely or not at all.
- A machine whose worst finding would be P0, where "no finding" needs more than the absence of a failing test.

Choose the machine where a bug costs the most and tests reach the least. Leave the rest to tests.

## What a model is

The machine's states, its starting states, every transition as a step from one state to the next, and the invariants from the document. The model describes the design; it is a second artifact, separate from the code. Use the checker the project already has; otherwise prefer one a developer can install and rerun with one command.

## Rules

1. **Derive it from the transition table.** Each row is one action; each actor that can fire it is a process. Cite the table row beside each action.
2. **Write the bounds down.** The number of actors, retries and queue slots the run covers goes in the document. A pass holds only inside them.
3. **Show it can fail.** Break the invariant on purpose once and confirm the checker reports it, before you trust a pass.
4. **Replay every counterexample against the real code.** Turn the path into a test that follows the same steps. Only a red test grades the finding `confirmed`; a path the code cannot follow means the model is wrong, and the model is fixed.
5. **Describe the path in code terms.** Each step of a counterexample names the function and line it stands for, so it reads without the tool.
6. **Record the sync point.** The document notes the commit the model was last checked against. A change to the machine's write sites updates the model in the same PR, or marks it stale.

## What a pass means

The model keeps its invariants within the bounds. It says nothing about code that has drifted from the model, about properties nobody wrote down, or about whether the invariants are the right ones for the product.

## In the document

Add to the machine's section: the model's path, the bounds, the invariants checked, the sync commit, and for each counterexample its finding ID.
