# Architecture

How systems are shaped here: domain-driven design for what the parts are, ports and adapters for how they depend on each other, and deep modules for how big each part's surface is. It holds in any language; a repo's own instructions say how it is spelled there.

## Words

- **Context**: a part of the system with one consistent language and one owner of its data.
- **Aggregate**: a cluster of state that changes together and guards its own invariants.
- **Module**: anything with an interface and an implementation, at any scale.
- **Interface**: everything a caller must know to use a module: operations, invariants, ordering, errors.
- **Depth**: how much behaviour a caller gets per thing it must learn. Deep is a small interface over a lot of behaviour.
- **Port**: an interface the core owns for something outside it. **Adapter**: a concrete thing that satisfies a port.

## 1. Contexts

- One context, one language. Its terms are in the glossary and the code uses exactly those words. The same word in two contexts is two concepts, translated where they meet.
- A context owns its data: its tables, its schema changes, its invariants. Nothing else writes them.
- Contexts meet in two ways only: a published interface the owner offers, and events the owner emits. One context holds another's records by identifier.
- What several contexts share (identifiers, money, time) is a small kernel of value types that knows no context. It grows by recorded decision.
- The map of contexts and how they relate is a document, and the code's dependencies match it.

## 2. Inside a context

Four parts, with dependencies pointing inward:

| part | holds | may depend on |
|---|---|---|
| domain | aggregates, value types, rules, events | nothing outside itself and the kernel |
| application | one operation per use case: load, decide through the domain, store, emit | domain, ports |
| ports | what the core needs from outside, in domain terms | domain |
| adapters | transport in, storage and other systems out | everything inward |

One place wires adapters to ports at start-up. Nothing else constructs its own dependencies or reads global state.

## 3. The domain model

- An aggregate is created valid and stays valid. State changes through operations named in the domain's language (`cancel`, never `setStatus`), and each operation refuses an illegal move.
- A lifecycle is one field with named states, so an invalid combination cannot be written.
- A value with meaning has its own type: an identifier, an amount, a period. It is validated once at creation and trusted after.
- Outside data becomes domain types at the adapter. The domain never sees a request, a row or a wire format, and carries no storage or transport annotations.
- Time, randomness and identifiers come through ports, so the same input gives the same result.

## 4. Ports and adapters

- **Ports sit at the edge**: where the core meets input, output or another context. A port with one adapter is sound there, because it exists for dependency direction. Inside the core, code calls concrete things.
- A port is owned by its consumer, is as narrow as that consumer needs, and speaks domain terms. A port that repeats its adapter operation for operation is the adapter's interface, moved.
- An adapter translates in both directions, including errors: a storage failure becomes a domain error at the adapter, and a domain error becomes a transport response at one place.

## 5. Depth

- Prefer a small interface over a lot of behaviour. Before adding a layer, a type or an option, name what it hides.
- **The deletion test**: imagine the module gone. If complexity disappears, it was a pass-through; if it reappears in every caller, it earns its place.
- A layer that only forwards, a shape copied through several types unchanged, and one use case spread over many small files are the same fault: surface without depth.
- An abstraction needs a reason of direction (the core must not depend on what is behind it) or of variation (two real implementations today).

## 6. Consistency

- One transaction changes one aggregate. The application operation is the transaction boundary.
- What must follow in another aggregate or context follows from an event, recorded in the same transaction as the change and delivered after. Every consumer gives the same result when an event arrives twice.
- An invariant is stated in the aggregate and guaranteed where concurrency is resolved: a version check, a lock or a storage constraint.

## 7. Reads

A query may skip the aggregates and return a shape made for its reader. It never writes, and it reads another context's data through that context's interface or through a read model built from its events.

## 8. Tests follow the shape

- Domain rules are tested as pure logic, with no storage and no stand-ins.
- A use case is tested through the context's application interface. The interface is the test surface: a test that must reach past it is pointing at a wrong shape.
- Use the real store where one runs locally. A fake is allowed when one contract suite runs against both the fake and the real adapter; otherwise it is a second implementation nobody checks.
- When modules merge into a deeper one, tests move to the new interface and the old ones are deleted.

## 9. Held by checks

The dependency rule, the context boundaries and the ownership of data are enforced by checks that run with the build, added with a baseline where the code does not yet comply (`~/.ozstack/standards/audits.md`, Ratchet). A decision that shapes structure is recorded once, with its reason, and superseded by a new record when it changes.
