# AGENTS.md

## Before you code

- State each assumption in one sentence.
- If the request has two readings, show both and ask. Do not choose in silence.
- If a simpler method exists, say so before you build the complex one.
- If the target directory is not a Git repository yet, run `git init` before you make changes.

## Scope

- Write the smallest code that solves the request. Add no feature, option, or
  abstraction that nobody asked for.
- Do not handle an error that cannot happen.
- Change only the lines that trace back to the request. Do not touch other
  code, comments, or spacing.
- Match the style of the file, also when you prefer a different style.
- Remove the imports and variables that your change orphaned.
- Leave old dead code in place. Report it.

## Code

- Extract a recurring or meaningful value into a named constant. Keep a
  self-explanatory one-off value inline.
- Use a named constant for a value that comes from a specification, for
  example HTTP 200 OK.
- Keep function names shorter than 30 characters.
- Do not use a boolean as a function parameter. Use a named value that shows
  the mode.
- Reduce indentation. Use early return and continue.
- Always use braces, also on a one-line condition.
- Put an empty line between logical blocks.
- Hide low-level mechanics behind a driver or abstraction layer. Give the rest
  of the code an interface that speaks in domain terms.
- Call only the layer directly below. Do not skip a layer.
- Keep every name private by default. A visibility change is a breaking design
  change. Ask for approval before you make a private name public.

## Comments

- Write a short comment above each block. Say what the block does and why.
  Add an example when it helps.
- Use an ASCII drawing to show a complete system.
- Do not comment a block that you did not write or change.

## Writing

- Use ASD-STE100 Simplified Technical English in comments, commit messages,
  and replies.
- Use as few words as possible. Pick each word with care.
- Do not use superlatives or praise. Give the facts.

## Commits

- Put one blank line between the subject and the body.
- Limit the subject to 50 characters. 72 is the hard limit.
- Start the subject with a capital letter.
- Do not end the subject with a period.
- Write the subject in the imperative. It must complete this sentence:
  "If applied, this commit will ...".
- Wrap the body at 72 characters.
- Use the body for what and why. The code shows how.

## Tests

- If the request is a bug fix, write the test first. Run it. See it fail.
  Then write the fix. Run it. See it pass.
