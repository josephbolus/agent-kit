---
name: roboporter
description: Distill and apply proven methods for porting open-source applications, command-line tools, services, libraries, agents, and other software across languages, runtimes, platforms, frameworks, APIs, protocols, dependencies, architectures, or backends while preserving observable behavior and validating functional parity. Use for complete software ports and compatibility reimplementations, not simple upgrades, migrations, rebranding, or mechanical source translation.
---

# roboporter

Port **observable behavior** of an open-source project into a different implementation environment. Preserve public contracts. Adapt internals honestly. Prove parity with evidence.

This is not: rebranding, a dependency bump, swapping one client library, mechanical translation, transpilation without semantic checks, moving files, or a proof of concept.

## When this skill applies

Use it when the work must produce a counterpart that users of the source project can operate by the same contracts (commands, APIs, flags, formats, exit codes, security guarantees), even if the internals cannot be copied.

Do not use it to shrink the product to a style exercise, a demo subset, or “the interesting 20%.” Local coding style is not a license to cut scope.

## Required starting facts

Do not design until these are named:

1. **Source project** and the revision being ported.
2. **Porting dimension** (language, runtime, platform, storage, protocol, provider, architecture, or a combination).
3. **Target environment**, including **closely related variants** that must work independently (do not assume sibling targets are compatible).
4. **Parity level**: full product; documented subset; or analogue-with-recorded-gaps.
5. **Non-goals** that are source-environment-only and have no honest analogue.

If any of these is missing, inspect the repositories and ask before inventing them.

## Workflow

Read `references/parity-method.md`, `references/capability-mapping.md`, `references/verification.md`, and `references/failure-patterns.md` as the corresponding step needs them. Do not skip the inventory.

### 1. Read the source as a specification set

Inspect, in combination:

- public interface surface (CLI, API, config, env, schemas, exit codes);
- architecture documents and package boundaries;
- tests (they encode invariants the README omits);
- docs of user-visible reports and degraded modes;
- license, NOTICE, copyright, and attribution files;
- packaging, install, and CI contracts if those are in scope.

Treat runtime behavior of the source on real instances as a specification equal to the code.

### 2. Inventory before writing target code

Build a **parity matrix** (see `references/parity-method.md`). Every user-visible command, flag, format, finding/rule, integration, and security promise is a row. Classify each row:

| Class | Meaning |
|---|---|
| equivalent | same contract, target-native internals |
| adapted | same purpose, different mechanism |
| replaced | target-native capability substitutes |
| not applicable | source-environment-only; record why |
| unsupported | needed for claimed parity; target cannot provide it |

**Unsupported items cannot be silently dropped.** Either implement an honest analogue, demote the claimed parity level, or list them as open gaps.

### 3. Map capabilities, do not translate lines

For each source-specific dependency, find a **semantic equivalent** or a **target-native adaptation**. Consult authoritative target documentation and probe running instances. See `references/capability-mapping.md`.

False friends (same name or similar API, different meaning) are a primary failure mode. Measure the quantity the finding or feature claims to represent; do not reuse a nearby counter because it is easier to collect.

When the target lacks a validator or facility the source used, **do not fabricate equivalence**. Label exactness honestly (for example: plan-only, unvalidated, sampled vs cumulative).

### 4. Keep architecture that encodes the product

Preserve the source’s **separation of collection, diagnosis, and presentation** when that split is how correctness is maintained. Do not fold diagnosis into rendering, or sampling into a display heuristic.

Prefer small predicates with table tests for rules that must not fire on the wrong signal.

Do not fail the whole run because one optional collector or integration is unavailable; degrade that section and continue.

### 5. Implement in vertical slices

Ship complete paths (collect → diagnose → present → test) per area. A command that exists but prints an empty stub, or a JSON schema without the human report, is not a slice.

Keep the source tree read-only. Do not “simplify” the product to match a preferred program shape.

### 6. Verify with the shipped entry point

See `references/verification.md`. Minimum evidence for a claimed row:

- a test that drives **shipped** functions (not a reimplementation of the rule);
- a launch of the **real** target binary/API against a **live** instance of each supported variant when feasible;
- a degrade test when an optional capability is off.

A skipped integration test is not a pass when that environment is in the compatibility matrix.

Package-level coverage floors on the diagnosis/render/contract packages beat a single overall percentage.

### 7. Stop conditions

Do **not** claim complete parity while any of these remain:

- a public command or API that stubs, crashes, or omits its report;
- a human interface that is not recognizably the source’s (headers, scores, groupings, detail views);
- a diagnostic that uses the wrong signal (lifetime totals, daemon uptime, source-environment SQL/DDL);
- a closely related target untested;
- an unsupported analogue presented as validated;
- license/NOTICE/attribution missing.

Review the final diff for leftover source-environment names, APIs, SQL dialects, DDL, and comments.

## Invariants (always)

- **Read-only / least privilege** of the source is preserved: setup that only *prints* privileged SQL must not execute it; analysis that must not run user workloads must not grow an “execute” mode.
- **Secrets** do not belong in committed config. Prefer OS-native credential stores or a restricted file over exporting a password in the process environment. Redact secrets in errors and logs.
- **Related targets diverge.** Detect engine, provider, or version and apply per-variant setup; do not assume sibling targets share defaults.
- **Public contracts stay.** Flags, formats, schema versions, and exit codes change only with explicit authorization.
- **Provenance stays.** Keep applicable licenses, copyright lines, NOTICE files, and documented trademark boundaries.

## Output of a porting engagement

1. Parity matrix with classification and evidence links.
2. Recorded behavioral differences (honest analogues and non-goals).
3. Target implementation in slices, each with tests.
4. Live runs against every supported variant, or a captured inability to reach them.
5. Diff review notes: no source-environment remnants in user-facing surfaces.
