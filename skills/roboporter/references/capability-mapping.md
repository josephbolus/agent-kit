# Capability mapping

## Discovering source-environment coupling

Search the source for assumptions that will not travel:

- language runtime and standard library behavior;
- OS facilities (process list meaning, sockets, credential files);
- database/engine catalogs and counters (what a timestamp or “time” column actually measures);
- optional subsystems that change the meaning of remaining stats when off;
- planner/validator extensions;
- wire protocols and auth plugins;
- packaging and install PATH requirements.

Pair each coupling with the **question it answers** (open transaction age? current wait share? index the planner would use?). Mapping starts from the question, not from the first similar-looking API.

## Finding target-native equivalents

For each question:

1. Consult authoritative target documentation for the quantity that answers it.
2. Inspect whether the target exposes a snapshot, a lifetime counter, or a sample.
3. Probe a live instance of **each** supported variant. Sibling products often differ in variable names, default-on subsystems, and privilege models.
4. Prefer a short **sample window** when the source attributed *current* time or rate, even if the target also offers cumulative totals.

If two candidate signals exist, write a table test that shows the wrong one firing on idle or daemon activity. That test is cheaper than a production false positive.

## Closely related targets

Do not assume a dialect, cloud edition, or minor version accepts the same session options, catalog views, or defaults. Detect version, engine, or provider at connect time. Branch the **smallest** setup difference; keep diagnosis on a shared context object.

When one variant lacks a catalog, mark that section unavailable and continue. Do not abort the whole run.

## Shared abstraction vs isolation

Keep a shared **context / result document** (versioned schema) so rendering, CI formats, and integrations stay one path.

Isolate:

- connect/session setup per variant;
- SQL/API dialect;
- credential resolution for that ecosystem.

Do not share a “close enough” counter across variants without a test.

## Missing or incomparable capabilities

If the source **validates** a recommendation with a facility the target does not have:

- still emit the recommendation only from evidence the target **can** produce (for example a plan, not an executed workload);
- label it unvalidated / estimate / analogue;
- never imply the missing validator ran.

If the source forbids executing the inspected workload, the port must not grow an execute-or-analyze path. Guard with a repository-wide search test.

If a source DDL or API form is illegal on the target, emit the **target-legal** form. Source syntax in the output is a contract bug, not a style issue.

## Credentials and config

Committed project config is for thresholds and suppressions, not secrets. Refuse credential-shaped keys there.

Resolution order should put an explicit invocation argument first, then an OS-native credential store or a mode-restricted secret file, then a product-specific environment variable, then a generic connection-string environment variable. A password in the process environment or argument list is not a secure mode. An empty environment override must not win over a better source.

Redact secrets in every error wrapping path.

## Honest degrade

Optional capabilities (profilers, extra schemas, follow-mode logs) get a real degrade message. An empty table that looks like “healthy” is a false negative.
