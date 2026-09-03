# Parity method

## What to inventory

Enumerate **observable** items, not source files. Walk:

- entry points (commands, HTTP routes, library exports, language bindings, agent tools);
- flags, configuration keys, environment variables, and their precedence;
- output formats and schema versions (text, JSON, CI formats);
- exit / status codes and which findings move them;
- user-visible reports (not only machine JSON): headings, scores, groups, empty states, “full” detail views;
- diagnostic rules / findings and the **signal each claims**;
- optional integrations and their degrade text;
- install, packaging, and docs **if they are in the parity claim**;
- security promises (read-only, no execute-analyze, credential refusal in committed files).

Source tests, golden outputs, and live runs of the source are part of the inventory. A flag that exists in `--help` but whose body is a stub is still a row — mark it unimplemented until the report is real.

## Classification rules

Assign every row one class. Criteria:

**equivalent** — same inputs and outputs; internals may change. Example criterion: same exit code mapping from severity.

**adapted** — purpose preserved, mechanism replaced because the source facility does not exist. The adaptation must be named (sampled window vs lifetime counter; plan-only suggestion vs planner-validated suggestion).

**replaced** — a target-native facility covers the user need (different name, same job). Document the mapping so users of the source can find it.

**not applicable** — the item is defined by the source environment and has no counterpart (a wraparound horizon, an extension that cannot exist). These may be non-goals. They still appear in the matrix so they are not “forgotten.”

**unsupported** — the parity claim needs this item and the target cannot provide it. Stop or lower the claim. Do not ship a lookalike that implies the missing capability.

Pixel-identical presentation is usually **not applicable** unless the contract is a screenshot or golden terminal dump. Recognizability of the report (score, severity groups, detail board) usually **is** a contract.

## Traceability

Each row needs:

- source location (command, test, or doc);
- target location (once implemented);
- class;
- evidence (test name, captured run, or “blocked: environment unreachable”).

A checklist of empty boxes is not evidence. Claiming “command exists” without a captured real report is incomplete.

## Completion gates

A port is complete for its claimed level only when:

1. Every inventory row is classified.
2. Every **equivalent / adapted / replaced** row has implementation **and** a test or live capture of the **shipped** path.
3. Every **not applicable** row has a one-line reason.
4. Every **unsupported** row is either resolved or the claimed parity level has been reduced in user-facing docs.
5. Human default output and machine output are both checked. JSON schema version + findings array does not replace the findings-first text report if the source has both.
6. Closely related target variants were run separately, or the failure to reach them is captured (not faked).
7. License, NOTICE, and attribution from the upstream project are present if the port is a derivative.

Refuse “1:1” or “feature-complete” language while a public surface returns a stub, a diagnostic uses the wrong signal, or a variant is untested.
