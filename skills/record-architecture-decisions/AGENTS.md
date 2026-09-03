Add or append this to your AGENTS.md

```markdown
## Architecture Decision Records

Repository history and durable technical decisions are recorded in [`docs/adr/`](docs/adr/).

Before completing any non-trivial implementation thread or merge request, use the repository's `record-architecture-decisions` skill to evaluate whether the work produced a durable architectural decision.

When a decision is ADR-worthy, add a small record under `docs/adr/` in the same merge request. Capture the constraints and evidence available at the time, including failed or rejected approaches that explain why the practical solution differed from the ideal one. If no ADR is needed, say so explicitly in the final handoff.
```
