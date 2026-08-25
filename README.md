# agent-kit

Source of truth for agent skills and for the `AGENTS.md` 

## Layout

```text
agent-kit/
├── AGENTS.md                  # the one file. copy it to any repo root.
├── CLAUDE.md -> AGENTS.md
├── skills/
│   └── <skill-name>/
│       ├── SKILL.md           # frontmatter name must equal the directory name
│       └── references/        # large material, loaded on demand
├── bin/
│   ├── install-skills.sh
│   └── validate.sh
└── .github/workflows/validate.yml
```

## Use

```bash
# Check every skill.
bin/validate.sh

# Put the rules in another repository.
cp AGENTS.md ../db-platform-ops/AGENTS.md
cd ../db-platform-ops && ln -sfn AGENTS.md CLAUDE.md

# Symlink every skill into personal scope. An edit here takes effect at once.
bin/install-skills.sh --personal

# Copy one skill into a project. CI cannot follow a symlink out of the repository.
bin/install-skills.sh --project ../db-platform-ops architecture-decisions
```

`AGENTS.md` governs work on this repository and is also the file you copy out. There is no
generator. Edit it directly.

A copy can drift from this repository. Check with `diff`:

```bash
diff AGENTS.md ../db-platform-ops/AGENTS.md
```

## What `bin/validate.sh` checks

1. Each skill directory has a `SKILL.md`.
2. The frontmatter `name` equals the parent directory name.
3. The `name` matches `^[a-z0-9-]+$`.
4. The `description` exists and is under the length limit.
5. Relative markdown links inside a skill resolve on disk.

Checks 2 and 5 catch a bad skill rename, where the directory changes but the frontmatter or a
relative link does not.
