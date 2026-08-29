---
name: bash-style
description: Write, review, or refactor Bash scripts to the progrium/bashstyle conventions (strict mode, functions, quoting, local/declare, main entrypoint, no deprecated syntax). Use this skill whenever the task involves a .sh/.bash file, a shell script, a Bash function, a Bash one-liner that will be committed, a Jenkins/CI shell step, or a git hook, and also when the user asks to review, lint, clean up, or shellcheck existing shell code. Trigger even if the user does not say "style" or "Bash" by name, for example "write a wrapper script", "fix this script", or "make this script safer".
---

# Bash style

Apply these rules when you write or change Bash. Bash is glue. Keep scripts small, obvious, and safe to run twice.

Assume Bash, not POSIX sh. The rules use Bash features on purpose.

## Script skeleton

Use this shape for every runnable script.

```bash
#!/usr/bin/env bash
set -eo pipefail
[[ "$TRACE" ]] && set -x

readonly DEFAULT_TIMEOUT=30

main() {
	declare arg1="$1" arg2="$2"

	# ...
}

main "$@"
```

If the script is also a library, call `main` only when the file runs directly:

```bash
[[ "$0" == "$BASH_SOURCE" ]] && main "$@"
```

## Big rules

Follow these unless you have a stated reason not to. State the reason in a comment.

1. **Quote every expansion.** No naked `$`. This includes command substitution: `"$(cmd)"`.
2. **Put all code in a function.** A single `main` is enough. Only global settings, `readonly` constants, and the `main` call live at the top level.
3. **Give runnable scripts a `main` function.** Call it with `main "$@"`.
4. **Use `local` for variables inside functions.** Use `declare` for named arguments. Set an outer-scope variable only when that is the point of the function.
5. **Use lowercase variable names.** Use uppercase only for exported environment variables and `readonly` constants.
6. **Use `set -eo pipefail`.** Add `|| true` to commands you allow to fail.
7. **Name arguments at the top of any function longer than 2 lines.** Use `declare arg1="$1" arg2="$2"`.
8. **Use `mktemp` for temporary files.** Remove them with a `trap`.
9. **Send warnings and errors to STDERR.** Send parsable output to STDOUT.
10. **Prefer absolute paths.** Use `$PWD`. Qualify relative paths with `./`.
11. **Localize `shopt`.** Turn the option off when the block ends.

The source guide uses `set -eo pipefail`, not `-euo`. `set -u` is not part of this style. If a repo already sets `-u`, keep it and initialize variables before use.

## Never use deprecated syntax

| Use | Do not use |
| --- | --- |
| `myfunc() { ... }` | `function myfunc { ... }` |
| `[[ ... ]]` | `[ ... ]`, `test` |
| `$( ... )` | backticks |
| `$(( ... ))` | `expr` |

## Named and variadic arguments

Named arguments:

```bash
regular_func() {
	declare desc="Does one thing well"
	declare arg1="$1" arg2="$2" arg3="$3"

	# ...
}
```

Variadic arguments, where `declare` does not fit:

```bash
variadic_func() {
	local arg1="$1"; shift
	local arg2="$1"; shift
	local rest="$@"

	# ...
}
```

Add `declare desc="..."` above the argument line in libraries and CLI commands. Other tools read it:

```bash
eval $(type FUNCTION_NAME | grep 'declare desc=') && echo "$desc"
```

## Conditionals

Test the exit code when you can. Test the output only when you need the text.

```bash
# exit code, -q mutes output
if grep -q 'foo' somefile; then
	...
fi

# output, -m1 limits to one result
if [[ "$(grep -m1 'foo' somefile)" ]]; then
	...
fi
```

Use `&&` and `||` for short conditionals. Put `then` and `do` on the same line as the condition.

## Practical preferences

- Use Bash parameter substitution before you reach for `awk` or `sed`.
- Use `printf` when `echo` is not enough. `printf` handles formats and escapes.
- Wrap complex `sed`, `perl`, or `jq` one-liners in a function with a descriptive name.
- Use double quotes by default. Use single quotes when the string must stay literal.
- Prefer optional environment variables over flag parsing. Use subcommands for different modes.
- Use hard tabs. Heredocs strip leading tabs with `<<-`, so tabs keep the indentation correct.
- Use `.sh` or `.bash` only on files that get sourced. Executable scripts get no extension.
- Namespace exported variables when subshells read them.
- Write for the target platform. A script in a container can assume more than a script that runs on many hosts.

## Cleanup pattern

```bash
main() {
	local tmpdir
	tmpdir="$(mktemp -d)"
	trap 'rm -rf "$tmpdir"' EXIT

	# ...
}
```

## Error output

```bash
err() {
	declare msg="$1"
	printf '%s\n' "$msg" >&2
}
```

## Review checklist

Run this list against existing scripts before you approve a change:

- [ ] `set -eo pipefail` is present and near the top.
- [ ] Every expansion is quoted.
- [ ] No code runs at the top level except settings, constants, and `main`.
- [ ] Every function variable is `local` or `declare`.
- [ ] No `[`, no backticks, no `function` keyword.
- [ ] Temporary files use `mktemp` and a `trap`.
- [ ] Errors go to STDERR.
- [ ] The script is safe to run twice.

## Verify

Run `shellcheck` on any script you write or change. Fix the findings or explain why a finding does not apply.

```bash
shellcheck path/to/script
```

Report the command you ran and its result. Do not claim a script is clean without running the check.

## Source

These rules come from `progrium/bashstyle`. Deeper references:

- http://mywiki.wooledge.org/Quotes
- http://wiki.bash-hackers.org/scripting/obsolete
- http://wiki.bash-hackers.org/scripting/newbie_traps
- https://github.com/koalaman/shellcheck