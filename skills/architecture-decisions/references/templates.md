# Repository ADR templates

Use these templates only when the repository has no established ADR system.

If the repository already has an ADR location, naming convention, index format, or template, follow the existing convention unless the task explicitly includes changing it. Adapt project-specific names and areas without weakening the consultation, conflict, approval, or supersession rules.

## Repository convention

Before creating or modifying an ADR:

1. Search the repository for an existing ADR convention.
2. If one exists, follow its location, filename scheme, template, metadata, and indexing conventions.
3. Do not introduce a competing ADR structure unless the task explicitly requires migrating or replacing the existing convention.

If no ADR convention exists, use:

```text
docs/architecture/
docs/architecture/decisions/
```

Create the directories lazily, only when the first architecture documentation or ADR is needed.

Use date-based ADR filenames:

```text
YYYY-MM-DD-short-decision-title.md
```

Use lowercase kebab-case for the decision title.

Example:

```text
docs/architecture/decisions/2026-08-31-use-binlog-based-point-in-time-recovery.md
```

Date-based filenames are the default because they are naturally sortable and avoid sequential-number collisions across concurrent branches.

## Root `AGENTS.md` lookup rows

Merge these rows into a small context lookup table. Preserve existing instructions.

When an existing repository ADR convention was discovered, substitute its actual paths below.

```markdown
## Context lookup

Load context on demand. Do not preload every linked document.

| When | Read first |
| --- | --- |
| Before planning or implementing a non-trivial change | `.agents/skills/architecture-decisions/SKILL.md`, then `docs/architecture/README.md` |
| When architecture, interfaces, data, dependencies, security, deployment, reliability, or operations may change | `docs/architecture/decisions/README.md`, then each relevant ADR in full |
| When proposed work conflicts with an accepted decision | Draft a superseding ADR and obtain explicit approval before implementation |
```

## `docs/architecture/README.md`

```markdown
# Architecture

This directory is the canonical record of accepted architecture. Implementation and review follow
the accepted ADRs in the [decision index](decisions/README.md).

## Current architecture

No architecture decisions have been accepted yet.
```

Replace the final sentence with concise linked bullets as decisions are accepted:

```markdown
- The server owns durable threads, ordering, recovery, and authorization; clients are leased
  executors ([Server-authoritative coordination](decisions/2026-09-03-server-authoritative-coordination.md)).
```

## `docs/architecture/decisions/README.md`

```markdown
# Architecture decision index

Read this index before planning or implementing non-trivial changes. Select records by affected
area, dependency, interface, data flow, trust boundary, deployment, reliability, and operations;
then read every selected ADR in full.

| ADR | Status | Decision | Areas | Supersession |
| --- | --- | --- | --- | --- |

## Status meanings

- `proposed`: under review; not implementation authority
- `accepted`: current decision and active constraint
- `rejected`: considered but not chosen
- `deprecated`: obsolete without a direct replacement
- `superseded`: replaced by a newer ADR
```

## `docs/architecture/adr-template.md`

```markdown
---
status: proposed
date: YYYY-MM-DD
decision-makers: []
areas: []
supersedes: null
superseded-by: null
---

# Short decision title

## Context

Describe the forces, constraints, and problem without arguing for an outcome.

## Decision

State the decision in active voice: "We will ..."

## Invariants

- State conditions that implementations must preserve.

## Consequences

### Positive

- Describe benefits.

### Negative

- Describe costs, risks, and operational burden.

## Alternatives considered

### Alternative name

Explain why it was not selected.

## Implementation and validation

- Link the plan, tests, migrations, or other durable evidence when available.
```

## Filename and index example

For a decision accepted on `2026-09-03` titled `Server-authoritative coordination`, create:

```text
docs/architecture/decisions/2026-09-03-server-authoritative-coordination.md
```

Add:

```markdown
| [2026-09-03: Server-authoritative coordination](2026-09-03-server-authoritative-coordination.md) | accepted | Server-authoritative coordination | server, threads, authorization | — |
```

If a later decision titled `Distributed thread coordination` supersedes it, create a new date-based ADR rather than renaming or replacing the original:

```text
docs/architecture/decisions/2026-10-12-distributed-thread-coordination.md
```

Update the original ADR:

```yaml
status: superseded
superseded-by: 2026-10-12-distributed-thread-coordination
```

Set the new ADR metadata:

```yaml
status: accepted
date: 2026-10-12
supersedes: 2026-09-03-server-authoritative-coordination
superseded-by: null
```

Then update the index:

```markdown
| [2026-09-03: Server-authoritative coordination](2026-09-03-server-authoritative-coordination.md) | superseded | Server-authoritative coordination | server, threads, authorization | Superseded by [2026-10-12: Distributed thread coordination](2026-10-12-distributed-thread-coordination.md) |
| [2026-10-12: Distributed thread coordination](2026-10-12-distributed-thread-coordination.md) | accepted | Distributed thread coordination | server, threads, authorization | Supersedes [2026-09-03: Server-authoritative coordination](2026-09-03-server-authoritative-coordination.md) |
```

Never reuse, rename, or delete an accepted ADR merely because it has been superseded. Preserve it as part of the repository's architectural history.
