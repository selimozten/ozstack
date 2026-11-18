# Document format

Format of `docs/state-machines.md`, the output of [state-machine-audit](SKILL.md). Examples use synthetic data.

## Layout

```md
# State machines

Audited at <commit sha>, <date>.

## Coverage

| area | kind | machines |
|---|---|---|
| `internal/billing` | directory | M-03, M-04 |
| `invoices` | table | M-03 |
| `email-outbox` | queue | M-07 |
| `internal/i18n` | directory | none: pure lookups, no stored state |

## Ledger

| id | machine | lens | invalid state or transition | grade | priority | issue | status |
|---|---|---|---|---|---|---|---|
| F-012 | M-03 Invoice | Concurrent | paid and cancelled both set | confirmed | P0 | #123 | fixed in #130 |
| F-013 | M-07 Outbox | Crash | sent, row still `pending` | suspected | P1 | #124 | open |

## Workarounds

| id | where | what it tolerates | machine | issue | status |
|---|---|---|---|---|---|
| W-04 | `billing/reconcile.go:88` | nightly job clears paid+cancelled | M-03 | #123 | deleted in #130 |

## M-03 Invoice

Kind: implicit (`paid_at`, `cancelled_at`, `status`). Owner: `internal/billing`. Stored in: `invoices`.

States: draft, issued, paid, cancelled (terminal: paid, cancelled).

Invariants:
- I1: `paid_at` and `cancelled_at` are never both set. Enforced by: nothing (F-012).
- I2: a paid invoice has exactly one ledger posting. Enforced by: unique index `postings_invoice_uq`.

| from \ event | issue | pay | cancel | webhook: paid |
|---|---|---|---|---|
| draft | issued (`invoice.go:41`) | rejected (`invoice.go:60`) | cancelled (`invoice.go:77`) | unhandled |
| issued | rejected | paid (`pay.go:30`) | cancelled (`invoice.go:77`) | paid (`hook.go:52`) |
| paid | rejected | rejected | unhandled | paid again (F-014) |
| cancelled | rejected | unhandled | rejected | unhandled |

Lenses: Duplicate F-014 · Concurrent F-012 · Crash holds: single transaction, `pay.go:28` · …one entry per lens.

### F-012 paid and cancelled both set

Grade: confirmed. Path: `pay.go:30` and `invoice.go:77` each read status, then write, with no version check.
Red: `go test ./internal/billing -run TestPayCancelRace -count=200` → 37 of 200 runs end with both timestamps set.
Fix shape: one owner (compare-and-swap on status), then unrepresentable (drop the timestamps' independence).
```

One section per machine, one subsection per finding. IDs are stable: a number is never reused.

## Statuses

Finding grade: `suspected`, `confirmed`, `refuted`. Finding status: `open`, `fixed in <PR>`, `refuted`. Workaround status: `open`, `deleted in <PR>`.

## Priority

The rubric is in `~/.ozstack/standards/audits.md`.
