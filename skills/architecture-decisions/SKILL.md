---
name: architecture-decisions
description: Maintain an indexed Architecture Decision Record system in any software repository. Use when bootstrapping a project; planning, reviewing, or implementing a non-trivial change; making or revisiting an architectural decision; changing interfaces, data models, dependencies, trust boundaries, deployment, reliability, or operations; resolving recurring technical uncertainty; or checking whether proposed work conflicts with accepted architecture. Consult the architecture index and relevant ADRs before planning or implementation, and maintain them when decisions change, even when the user does not explicitly mention ADRs.
---

# Architecture Decision Records

Treat repository ADRs as durable decision memory, not retrospective documentation. Keep
`AGENTS.md` as a small lookup table that routes agents to the repository-scoped copy of this skill
and the architecture indexes. Load only relevant records.

## Canonical layout

Use this layout unless the repository already has an established ADR system:

```text
.agents/skills/architecture-decisions/SKILL.md
docs/architecture/
├── README.md
├── adr-template.md
└── decisions/
    ├── README.md
    ├── 2026-09-03-server-authoritative-coordination.md
    └── 2026-10-12-distributed-thread-coordination.md
```

Preserve an existing documented location and naming convention. Do not create a parallel ADR tree.

## Bootstrap a repository

1. Locate the repository root and read all applicable instruction files before editing.
2. Search for an existing ADR system by filename and content before creating one.
3. If none exists, create the canonical layout from [references/templates.md](references/templates.md).
4. Copy this complete skill directory, including `references/`, to `.agents/skills/architecture-decisions/` so
   skills-compatible agents can discover the same workflow at project scope. Keep the repository
   copy semantically identical when updating.
5. Add or merge the architecture rows from the template into the root `AGENTS.md`. Keep it a routing
   table; do not copy the ADR workflow into it.
6. Create proposed ADRs during initial planning only for actual architecturally significant choices.
   Do not manufacture placeholder decisions or an ADR merely stating that ADRs are used.
7. Put only accepted decisions in `docs/architecture/README.md` as the current architecture.

Do not overwrite existing files or unrelated instructions. If `CLAUDE.md` or another compatibility
file already mirrors `AGENTS.md`, preserve that arrangement instead of duplicating policy text.

## Consultation loop

Run this loop before planning, reviewing, or implementing any non-trivial change:

1. Read this `SKILL.md` in full once for the current phase.
2. Read `docs/architecture/README.md` for the accepted architecture.
3. Read `docs/architecture/decisions/README.md` for the decision catalog.
4. Select relevant ADRs using the request, affected paths, systems, dependencies, interfaces, data,
   security boundaries, deployment, reliability, and operational effects.
5. Read each selected ADR in full. Extract its status, decision, constraints, invariants,
   consequences, rejected alternatives, and supersession links.
6. Compare the requested work and proposed plan with those constraints.
7. Cite the relevant ADR identifiers in the plan and explain how the work complies.

Read all ADRs only when the index is missing or unreliable, the repository has very few records, or
the affected scope is ambiguous. Otherwise, page in records on demand.

The loop is recursive across development phases and future sessions, not within a single read. Do
not repeatedly invoke or reread this skill without a phase or scope change. Re-run the loop when new
information materially changes scope, touches a new subsystem, or reveals a possible conflict.

## Conflict gate

Treat accepted ADRs as constraints. If requested work conflicts with one:

1. Stop before implementing the conflicting portion.
2. Identify the ADR and the exact conflict.
3. Draft a new proposed ADR that supersedes the old decision; never silently edit history.
4. Describe alternatives, migration and rollback effects, and affected invariants.
5. Require explicit human acceptance before treating the new ADR as authoritative or executing the
   conflicting architecture.

Rejected and superseded ADRs are historical evidence, not active constraints. Proposed ADRs are not
authorization to implement an architectural change.

## Decide when to write an ADR

Create or supersede an ADR when a decision is both consequential and non-obvious, especially when it:

- is costly or risky to reverse;
- changes system boundaries, ownership, interfaces, data authority, or deployment topology;
- introduces or removes a major dependency, platform, persistence model, or security control;
- establishes a reliability, scalability, compatibility, retention, or operational invariant;
- resolves a real trade-off likely to be questioned again;
- intentionally departs from an accepted decision.

Do not create ADRs for routine implementation details, easily reversible local choices, status
updates, or facts already obvious from code. Record work progress in the repository handoff or task
log, when present; ADRs record why a durable choice was made.

## ADR lifecycle

Use monotonically increasing four-digit identifiers; never reuse a number. Use one decision per ADR.
Valid baseline statuses are `proposed`, `accepted`, `rejected`, `deprecated`, and `superseded`.

- Draft a decision as `proposed` while it is under review.
- Change it to `accepted` only after explicit human approval.
- Mark an unchosen proposal `rejected`; preserve its rationale.
- Mark an obsolete but unreplaced decision `deprecated`.
- Replace an accepted decision with a new accepted ADR and mark the old one `superseded`, linking in
  both directions.

Do not rewrite the context, alternatives, or rationale of an accepted, rejected, deprecated, or
superseded decision to make history look cleaner. Fix typographical errors without changing meaning.
Use a new ADR for a changed decision.

## Maintain the indexes

For every ADR creation or lifecycle change:

1. Update `docs/architecture/decisions/README.md` with ID, status, title, areas/tags, and supersession.
2. Add, change, or remove the linked current-architecture bullet in
   `docs/architecture/README.md`. Include accepted ADRs only.
3. Verify all relative links and bidirectional supersession links.
4. Keep summaries factual and short enough to route future agents to the right record.

The current-architecture page is a projection of accepted ADRs, not another source of decisions.
When it disagrees with an accepted ADR, the ADR is authoritative and the summary must be corrected.

## Close the implementation loop

Before completing a non-trivial change:

1. Review the final diff against the consulted ADRs and plan.
2. Determine whether implementation revealed a new durable decision or invalidated an assumption.
3. Create or supersede ADRs only when the decision threshold is met.
4. Update both indexes in the same independently verifiable change as the architecture they describe.
5. Run the repository's relevant checks and verify links.
6. Report which ADRs were consulted, created, accepted, or superseded. If none changed, say why.

Never claim ADR compliance merely because files exist. Compliance requires reading the relevant
accepted records and comparing them with the actual plan and diff.
