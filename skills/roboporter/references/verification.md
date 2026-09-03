# Verification

## What must be tested

Drive **shipped** code. A parallel reimplementation of a rule in the test file does not prove the product.

Minimum kinds:

| Kind | Proves |
|---|---|
| Predicate / table tests | Wrong signals do not fire (idle daemons, lifetime totals, self-generated workload, source-illegal DDL) |
| Contract tests | Flags exist; missing invocation fails with the usage exit code; formats parse (schema version, tool name) |
| Integration on live instances | Collectors and connect/session pins work on each supported variant |
| Degrade | Optional subsystem off → partial report, not crash or fake health |
| Privilege | Setup path only prints privileged statements; analysis user cannot write |
| Human report | Default view has the source’s recognizability markers; detail view has the board/sections and does not print “see the detail flag” |
| Credential paths | Argument beats store beats file beats env; secret file without a TTY errors rather than hanging; live connect via the non-env path |
| Provenance | License/NOTICE present; no credential in sample config |

## Live instances

When the compatibility matrix names variants, run the **real entry point** against a real instance of each. Two launches of the primary user command (summary and detail) plus one machine-readable dump are a useful minimum.

If an instance cannot be reached, capture that failure. Do not substitute a mocked happy path and call the variant done.

Integration tests that `skip` when the connection env is unset are fine locally. In the job that claims that variant, skip is a **failure** (require the env).

## Coverage as a gate

A single repository-wide percentage rewards tests of command plumbing and starves collectors. Prefer **package floors** on:

- diagnosis / findings;
- temporal / diff engines;
- presentation;
- configuration;
- connection / capability detection;
- collection **when run with a live target**.

Collection often cannot hit its floor without a live instance because sampling talks to the target.

## Security and workload

Assert the tree contains no execute-analyze / destructive path the source forbade.

Assert long-running or “age” findings use the target’s real object age, not a process-list field that tracks command state or daemon uptime.

Assert the port’s own instrumentation does not appear as user workload in “top” lists.

## Completion evidence

Keep captured outputs of:

- unit run;
- live summary and detail reports;
- machine-readable document (parses, version set, findings array);
- CI format with the target product name;
- setup SQL that is comments + grants only;
- temporal commands after two stored snapshots;
- credential smoke (file or native store) when in scope.

Review those captures for false positives on idle targets (the usual sign of lifetime counters or daemon time).
