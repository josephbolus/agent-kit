# Failure patterns

Observed during a full-product port of a diagnostics CLI across storage engines. Generalized. Do not treat the original engines as required context.

## 1. Style-driven product cut

**Symptom:** A “port” that is a tiny program in one package; most commands, reports, and CI contracts gone.  
**Cause:** A local coding aesthetic (small mains, few dependencies) was applied as a **scope** rule.  
**Prevent:** Treat style as file-local (errors, comments). Inventory the **product**. User rejection of a toy subset is a stop, not a polish pass.

## 2. Command exists, report does not

**Symptom:** Help lists every source command; default output is a dump or a stub; detail view still tells the user to pass the detail flag.  
**Cause:** Parity counted binaries/flags, not recognizability (score, severity groups, healthy-subsystem list, status board).  
**Prevent:** Human report is a matrix row. Detail view must not advertise itself.

## 3. Nearby counter, wrong quantity

**Symptom:** Idle instances look critically ill (multi-hour “transactions,” disk-bound waits).  
**Cause:** Used process-list command time (daemon ≈ uptime) instead of engine transaction age; used lifetime wait totals instead of a short sample. Housekeeping I/O dominated an idle server.  
**Prevent:** Name the quantity the rule claims. Prefer sampled windows for “current” claims. Exclude instrumenter/self SQL and housekeeping events. Table-test idle and daemon cases.

## 4. Fabricated validator

**Symptom:** Index or plan advice implied the target planner confirmed a hypothetical object.  
**Cause:** Source used a planner-validation extension with no analogue; the port still spoke as if validation happened — or emitted source-dialect DDL the target rejects (nameless create-index).  
**Prevent:** Plan-only / unvalidated label. Target-legal statements. Never execute the inspected workload to “see if it is slow.”

## 5. Sibling-target assumption

**Symptom:** Connect or session setup fails on a close variant; optional profiler off by default; unknown session variable.  
**Cause:** Assumed one vendor’s SQL and defaults on a related product.  
**Prevent:** Capability detection; per-variant setup; include the variant that has the optional subsystem off in the compatibility matrix; do not abort the whole run when one probe fails.

## 6. Privileges and idempotent setup

**Symptom:** Analysis user can connect but cannot read the application schema; re-running printed setup fails on “user exists.”  
**Cause:** Setup SQL omitted object-level read grants; `CREATE USER` was not idempotent.  
**Prevent:** Setup output is the full least-privilege set for the product’s queries. Idempotent constructs. Setup **prints**; it does not apply.

## 7. Secrets in the wrong channel

**Symptom:** Password in exported environment, argument list, committed config, or empty env keys that override a good default.  
**Cause:** A generic connection-string environment variable was treated as the secure path; config files meant to be committed accepted credential keys; an empty env value overrode a better source.  
**Prevent:** Refuse credentials in committed config. Prefer native OS credential stores or a mode-restricted secret file. Product-specific environment before generic environment. Empty override must not win. Redact in errors.

## 8. Temporal engine too thin

**Symptom:** History command only compares first vs last snapshot.  
**Cause:** Stopped at a two-point diff while the source reports onset over a series.  
**Prevent:** If the source uses a series (onset, hops), the port must too when ≥N snapshots exist. Two-point compare is a fallback, not the full contract.

## 9. Coverage vanity

**Symptom:** Overall statement percentage looks fine; collectors that hold the false-positive rules are untested without a live target.  
**Cause:** Gating on one number; integration tests skip in CI.  
**Prevent:** Package floors. Live-target job where skip is failure. Tests call shipped collect/diagnose functions.

## 10. Declaring done at JSON

**Symptom:** Machine document has `schema_version` and `findings`; users still cannot read a findings-first report.  
**Cause:** JSON is easier to assert than terminal structure.  
**Prevent:** Both surfaces are gating. Live detail view checked for the board/sections.

## 11. Silent optional features

**Symptom:** Follow-mode logs, extra agent tools, or config scaffolding missing with no matrix row.  
**Cause:** Implemented the happy path of inspect only.  
**Prevent:** Inventory agent tools, config subcommands, and optional flags. Either implement, degrade, or list as non-goals **before** claiming completeness.
