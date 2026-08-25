# Repository ADR templates

Use these templates only when the repository has no established ADR system. Adapt project-specific
names and areas without weakening the consultation, conflict, approval, or supersession rules.

## Root `AGENTS.md` lookup rows

Merge these rows into a small context lookup table. Preserve existing instructions.

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
  executors ([ADR-0002](decisions/0002-server-authoritative-coordination.md)).
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

# ADR-NNNN: Short decision title

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

For the next unused number `0007` and title `Server-authoritative coordination`, create:

```text
docs/architecture/decisions/0007-server-authoritative-coordination.md
```

Add:

```markdown
| [ADR-0007](0007-server-authoritative-coordination.md) | accepted | Server-authoritative coordination | server, threads, authorization | — |
```

When ADR-0012 supersedes it, update both records and the index:

```markdown
| [ADR-0007](0007-server-authoritative-coordination.md) | superseded | Server-authoritative coordination | server, threads, authorization | Superseded by ADR-0012 |
| [ADR-0012](0012-distributed-thread-coordination.md) | accepted | Distributed thread coordination | server, threads, authorization | Supersedes ADR-0007 |
```
