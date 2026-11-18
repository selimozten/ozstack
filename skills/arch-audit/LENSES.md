# Lenses

Reference for [arch-audit](SKILL.md), stage 2. Each lens is a question with the evidence that answers it. Section numbers refer to `~/.ozstack/standards/architecture.md`.

## Leaks: too little structure

1. **Outward dependency** (2). Does the domain depend on an adapter, a framework, storage or transport? Does the application depend on an adapter? Evidence: the dependency listing of each part.
2. **Reach-in** (1). Does one context use another's internals, write its data, or read it without going through its interface? Evidence: cross-context dependencies and every site that touches each stored collection.
3. **Rule in the wrong place** (2, 3). Is a business decision made in a transport handler, a query, a job or the wiring? Is one rule written in two places? Evidence: the sites that decide it, file and line.
4. **Leaky port** (4). Does a port's signature carry a storage or transport type, or does a domain type carry their annotations? Evidence: the signature.
5. **Aggregate without a guard** (3). Can callers set state directly? Are invariants checked by callers instead of the aggregate? Evidence: the write sites outside the aggregate.
6. **Wrong aggregate edge** (6). Does one transaction change several aggregates? Does an aggregate load far more than its rule needs? Evidence: the operations and what each loads and writes.
7. **Lost event** (1, 6). Does a context learn of another's change by polling or reaching in? Is an event sent outside the change's transaction, or does it carry the whole record? Evidence: the publish site and its transaction.
8. **Language drift** (1). Does the code name a concept differently from the glossary, or use one word for two concepts with no translation? Evidence: the terms side by side.

## Ceremony: too much structure

9. **Pass-through** (5). Does a layer only forward? Apply the deletion test. Evidence: the share of its operations that add no decision.
10. **Speculative port** (4, 5). Is there an interface inside the core with one implementation and no reason of direction or variation? Evidence: its implementations and callers.
11. **Copy chain** (5). Does the same shape pass through several types with no change of meaning? Evidence: the types and the mapping code between them.
12. **Scattered concept** (5). Does one use case require reading many small modules, or does one change touch many files? Evidence: the files changed together in recent history.
13. **Plumbing module** (5). Is there a module named for a mechanism (utilities, helpers, common, manager) that many others depend on? Evidence: its dependents and what they take from it.
14. **Unused freedom** (5). Is there an option, a type parameter or an extension point that nothing varies? Evidence: the values in use.

## Health

15. **Test shape** (8). Does a domain rule need storage to be tested? Do tests reach past the interface, or replace collaborators inside the core? Evidence: what each test constructs.
16. **Wiring** (2). Is anything constructed outside the start-up wiring, or read from global state? Evidence: the construction sites.
17. **Unheld rule** (9). Is there a rule the code relies on that no check enforces? Evidence: the rule and the absence of a failing check when it is broken.

## Across contexts

18. **Map against code.** Does a dependency exist that the context map does not show, or run against its direction? Is there a cycle?
19. **Flow.** Follow two or three real flows from the first input to the last effect. Is each handover a published interface or an event, and does one failure in the middle leave a state someone owns?
20. **Design intent.** For each idea the system is built on: what in the code still goes around it?
