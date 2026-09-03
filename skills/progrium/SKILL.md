---
name: progrium
description: >
  Write or refactor Go and Bash code in the style of Jeff Lindsay (progrium):
  small flat programs, standard library first, bare error returns, tiny helper
  functions, near-zero comments. Use when asked to "write this the way progrium
  would" or "refactor this in progrium style".
---

# progrium (Jeff Lindsay) coding style

## Origin

Study date 2026-08-29 (commit-shape rules corrected on a same-day re-run with an
unbiased cross-repo commit sample). Read-only analysis of 14 repositories, commit
filter `Jeff Lindsay <progrium@gmail.com>`. Go corpus after exclusions: 196 files,
1018 functions.

- High weight, recent: `tractordev/apptron` (2024-2026, 85%), `progrium/topframe` (2021, 100%).
- Medium: `gliderlabs/cmd` (2016-2017, 61% of lines, the bulk), `gliderlabs/ssh`
  (2016-2018, author is creator, treated as library), `progrium/envy` (77%),
  `progrium/entrykit` (67%), `gliderlabs/sshfront` (48%), `gliderlabs/sigil` (author core files).
- Low, old: `registrator`, `logspout`, `localtunnel`, `gitreceive` (2010-2016).
  Artifact (shell, other authors): `dokku/dokku`, `gliderlabs/herokuish`.

## Core principles

Write the smallest program that works, in one `package main` at the repo root
until a second binary forces a `cmd/` split. Reach for the standard library
first; add a dependency only for real protocol work. Let errors travel back
unchanged and stop the program with `log.Fatal` at the top. Repeat yourself with
three-line helper functions, not abstractions. Leave the code almost uncommented;
the function names carry the meaning. Treat a public library as a different job:
there you document every exported symbol and offer functional options.

## Rules

### Structure

- Put a small tool in one or two files in `package main` at the repo root
  (`topframe/topframe.go`, `sigil/sigil.go`). Add `cmd/<name>/main.go` only for a
  second binary.
- Keep files near 60 lines, 90th percentile about 210. Split before 400.
- Collect a package's interfaces in one `types.go` (`logspout/router/types.go`).
- Name packages with one lowercase word. No underscores, no camelCase.

### main and control flow

- When each startup phase produces a value the next phase needs, split `main`
  into named step functions:

```go
// topframe/topframe.go
func main() {
	// ... flag.Parse and early-exit flags ...
	dir := ensureDir()
	addr := startServer(dir)
	fw := startWatcher(dir)
	runApp(dir, addr, fw)
}
```

- When the logic is one straight-line sequence with little reuse, a long
  procedural `main` or command handler is also in style. Do not carve it into
  artificial sub-functions. `apptron/boot.go` runs past 600 lines,
  `apptron/system/cmd/aptn/exec.go:execWasm` past 100.
- If the binary reports a version, check `--version` by hand at the top of
  `main`, before `flag.Parse`.
- Exit with a non-zero code for a bad invocation: `os.Exit(2)`, or `os.Exit(64)`
  for a usage error. `os.Exit(1)` for a runtime failure.

### Functions and types

- Most functions are tiny: median 7 lines, 75th percentile 16. Keep a helper to a
  handful of lines. About 1 in 10 functions runs past 30 lines, and a top-level
  handler may run much longer (see above).
- Pass 0 to 2 parameters. 3 is the practical limit. 79% of functions take 2 or fewer.
- Return `(value, error)` with `error` last. Use a named return only to document a
  single result: `func ensureDir() (dir string)`.
- Constructor is `New` when the package is named for the type, `NewThing`
  otherwise. Return `*T` or `(*T, error)`. No builder types.

```go
// registrator/bridge/bridge.go
func New(docker *dockerapi.Client, adapterUri string, config Config) (*Bridge, error) {
```

- Configure with a plain exported struct; set defaults in the constructor
  (`NewConfig` `entrykit/config.go`).
- Inject dependencies as constructor arguments or struct fields, not package
  globals. In 2014-2017 `gliderlabs` code (`cmd`, `logspout`), a package instead
  registers itself in `init()` (`Cmds["render"] = Run`, `router.AdapterFactories.
  Register(...)`) and reads config through the `comlab` framework, including its
  `log` and `config` packages. Read that form; do not write it in new code.
- Keep interfaces to 1 to 3 methods. `-er` suffix for an action name (`Handler`,
  `Signer`), a plain noun otherwise (`Session`, `Job`).

### Errors

- Return the error unchanged: `if err != nil { return err }`. Do not use `%w`.
  Do not use `github.com/pkg/errors`.
- Build a new error with `errors.New` or `fmt.Errorf`, message usually lowercase
  (88%): `errors.New("bad transport: " + route.Adapter)`.
- Use a typed error struct only when the caller must branch on the kind, and keep
  it flat: `type Error struct { Err error; Status int }` `cmd/lib/cli/cli.go:40`.
- In `main` and setup code, stop on any error with `log.Fatal`. Two forms are
  both in style: a `fatal(err)` / `assert(err)` helper (`topframe`,
  `registrator`), or a plain `if err != nil { log.Fatal(err) }` repeated inline
  in a command handler (`apptron/system/cmd/aptn/exec.go`).

```go
// topframe/topframe.go (registrator/registrator.go: same shape, named assert)
func fatal(err error) {
	if err != nil {
		log.Fatal(err)
	}
}
```

- Drop errors from best-effort calls with `_`: `os.MkdirAll(dir, 0755)`,
  `bin, _ := filepath.Abs(p)`.
- Reserve `panic` for an impossible state or a `mustX` helper.

### Helpers

- Add a small unexported helper for each cross-cutting need. Copy it between
  repos rather than share a package.

```go
// verbatim in logspout/logspout.go and registrator/registrator.go
func getopt(name, dfault string) string {
	value := os.Getenv(name)
	if value == "" {
		value = dfault
	}
	return value
}

// logspout/router/pump.go
func debug(v ...interface{}) {
	if os.Getenv("DEBUG") != "" {
		log.Println(v...)
	}
}
```

### Configuration and version

- Read a setting that varies by deployment from an environment variable with an
  inline default. App-specific names use `APPNAME_THING` upper snake
  (`TOPFRAME_DIR`, `SIGIL_PATH`); a generic toggle stays bare (`DEBUG`, `LOCAL`).
- Fixed infrastructure values (a listen port, a subnet, a gateway MAC) are hard
  coded in a struct literal or a `const`, not made configurable
  (`apptron/worker/cmd/worker/main.go:24`).
- Declare `var Version string` in `package main`, stamped with
  `-ldflags "-X main.Version=$(VERSION)"` (8 of 11 Go repos).

### Dependencies

- Standard library first: `net/http`, `net`, `os/exec`, `text/template`,
  `embed`, `flag`, `log`. Keep direct dependencies few (ssh 2, topframe 2).
- Parse CLI flags with `flag`. Use a subcommand library only for a tool with
  many subcommands (5 repos use `flag`, 2 use cobra).
- Log with `log`. No logrus, zap, or zerolog (0 files).
- Alias an import when the path tail is generic or clashes:
  `dockerapi "github.com/fsouza/go-dockerclient"`, `gossh "golang.org/x/crypto/ssh"`.

### Concurrency

- Start a server or watcher with a bare `go`. Two consumer patterns appear: a
  `select` loop over an event channel and a closed channel (`topframe`), or a
  `sync.WaitGroup` with an `atomic` done flag and a poll loop that sleeps
  (`apptron/system/cmd/aptn/exec.go`).
- Guard a shared map with `sync.Mutex`. Pass `context.Context` only in library
  and post-2018 code.

### Comments and docs

- A short single-purpose tool carries almost no comments (topframe 0.4 per 100
  lines, sigil 0.8, envy 0.6). Do not narrate a small helper.
- Comments cluster in two places: step markers inside a long procedural function
  (`// setup root bindings`, `// load bundle`, `apptron/boot.go`), and a note
  above a tricky spot (`// if cobra gets empty args ... we never want this`
  `cmd/lib/cli/cli.go:141`). Usually one line, sitting directly above its target.
- Most exported symbols in an application carry no doc comment (14%). A small
  utility function meant to be copied elsewhere sometimes gets a one-line one:
  `// DecodeIP converts "HHHHHHHH" hex to an IP` `apptron/worker/cmd/worker/main.go:218`.
- Leave a `// todo:` note (lowercase for new work; pre-2020 code used `// TODO:`).
- Keeping a block of superseded code commented out above the new code is in style
  (`apptron/boot.go` "old way of loading env:").
- In a library that others import, write a doc comment on every exported symbol
  and offer functional options:

```go
// ssh/ssh.go, ssh/options.go
type Option func(*Server) error

// PasswordAuth returns a functional option that sets PasswordHandler on the server.
func PasswordAuth(fn PasswordHandler) Option {
	return func(srv *Server) error { srv.PasswordHandler = fn; return nil }
}
```

### Tests

- Write few or no Go tests for an application (6 of 11 repos have zero test files).
- When you test, use `testing` only. Plain `t.Fatal` and `t.Error`, no testify.
  A fixture helper returns a cleanup closure:
  `func newClientSession(...) (*gossh.Session, *gossh.Client, func())`.
- Put end-to-end coverage in a bats shell script (`gitreceive/tests/gitreceive.bats`).

### READMEs

- Follow this skeleton, 60 to 120 lines: `# Name`, one or two sentences,
  `## Getting <Name>`, `## Using <Name>`, feature `###` sections, `## Sponsors`,
  `## License`.

### Bash

- `#!/bin/bash`, 2-space indent. `lower_snake_case` functions, form `name() {`.
- Declare constants at the top: `readonly GITUSER="${GITUSER:-git}"`.
- Name positional args on the function's first line:
  `declare home_dir="$1" git_user="$2"`. Write one comment above each function.
- Quote every expansion. Use `|| true` for an idempotent step.

### Tooling and commits

- Ship a `Makefile` with `build`, `release`, `dev`, `clean`. `build`
  cross-compiles into `build/<os>/<name>`.
- Commit subjects: short (~27 chars), lowercase first letter (91%), no trailing
  period (5%), empty body for routine work. Tag releases `vX.Y.Z`.
- Prefix the subject `component: ` only in a multi-package repo (`system:`,
  `lib/web:`, `go.mod:`) — a directory or subsystem name, never a Conventional
  Commit type. It runs 60-82% in `cmd` and `apptron` and 0% in the ten
  single-purpose tool repos. For a small tool, write a bare `lowercase summary`.

## Never

- Never wrap an error. `fmt.Errorf("...: %w", err)` appears once in the whole corpus.
- Never import `github.com/pkg/errors` outside the one repo that already has it.
- Never use functional options outside a public importable library. Zero in apps.
- Never add generics. Zero in 1018 functions, including 2024-2026 code.
- Never import a third-party logging library. Use `log`.
- Never use an assertion library in a test. One file in the corpus does.
- Never write `Get`-prefixed getters. `func (u User) Name()` not `GetName()`.
- Never use dot imports.
- Never write Conventional Commit prefixes (`feat:`, `fix:`, `chore:`).
- Never narrate the body of a short helper line by line. A single doc line above
  a reusable utility is fine; running commentary inside it is not.
- Never build deep package trees. `cmd/lib/google/analytics` is the deepest.

## Refactor procedure

Preserve behavior at every step. Run the tests, or build and smoke-test, after
each step. Stop and report if a step changes output.

1. Replace error wrapping with bare returns. Change `fmt.Errorf("x: %w", err)`
   and `errors.Wrap(err, "x")` to `return err`. Put needed context in a plain
   `fmt.Errorf` string. Remove the `pkg/errors` import.
2. Add helpers. Introduce `fatal`/`assert`, and `getopt` or `debug` if the file
   reads env vars or logs conditionally. Replace repeated
   `if err != nil { log.Fatal(err) }` in `main` with `fatal(err)`.
3. Move deployment settings from flags or config files to
   `getopt("APPNAME_THING", "default")`.
4. Where a startup phase feeds the next, split `main` into named step functions.
   Leave a straight-line sequence as one function.
5. Delete narrating comments on short helpers. Keep step markers in long
   functions, why-notes, and lowercase `todo`.
6. Collapse the layout: a single-binary tool into one or two files in
   `package main` at the root. Merge packages that hold only one type.
7. Swap a heavy dependency for the standard library when the swap is small:
   cobra to `flag`, logrus to `log`.
8. Add `var Version string` if the binary has none.
9. Rewrite the change set's commit messages as a short lowercase summary, no
   period. Add a `component: ` prefix only if the repo is multi-package.

## Review checklist

Answer yes or no against the diff.

- Do all error paths return the error unchanged, with no `%w` and no `pkg/errors`?
- Does `main` stop on errors with `log.Fatal` (helper or inline)?
- Are new helpers tiny (a handful of lines) with 2 or fewer parameters?
- Are new env vars named `APPNAME_THING` with an inline default via `getopt`?
- Is each comment short, directly above its target, and free of line-by-line
  narration inside short helpers?
- Did you avoid generics, third-party logging, and functional options (unless
  this is a library)?
- Is the CLI parsed with `flag`, unless the tool already uses cobra?
- Does a new binary declare `var Version string`?
- Are new packages one lowercase word, and the tree no deeper than before?
- Are commit subjects short, lowercase, and period-free, with a `component: `
  prefix only if this repo is multi-package?

## Limits

The corpus is about 80% Go and 15% Bash. It does not cover: JavaScript or
TypeScript style (author share small, mixed with bundles); Python; `context`
cancellation, structured logging, `errors.Is`/`errors.As` (the corpus predates or
opts out); generics-based API design; benchmark and fuzz tests; HTTP router
choice (three repos, three answers). When the task falls here, ask rather than
guess.
