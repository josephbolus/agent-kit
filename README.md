# agent-kit

`agent-kit` is a source repository for my reusable agent instructions and skills. It
contains:

- coding guidance in [`AGENTS.md`](AGENTS.md);
- specialist agent definitions in [`agents/`](agents/);
- command prompts in [`commands/`](commands/);
- reusable skills in [`skills/`](skills/); and
- scripts for installing skills and validating this repository in [`bin/`](bin/).

The repository has no application runtime or external package dependencies.
Its main artifacts are Markdown files that can be copied into another
repository or loaded by an agent. The included shell scripts install skills and
run repository checks.

## Repository layout

```text
agent-kit/
├── AGENTS.md                  # coding guidance; the source for CLAUDE.md
├── CLAUDE.md -> AGENTS.md     # Claude Code compatibility link
├── agents/                    # specialist agent definitions
├── bin/
│   ├── install-skills.sh      # install skills in personal or project scope
│   └── validate.sh            # validate skill metadata and links
├── commands/                  # reusable command prompts
├── skills/
│   └── <skill-name>/
│       ├── SKILL.md           # metadata and skill instructions
│       └── references/        # supporting material loaded on demand
└── .github/workflows/
    └── validate.yml           # validation and ShellCheck workflow
```

## Requirements

- Bash
- Git
- ShellCheck for the local script check (`bin/validate.sh` does not require
  ShellCheck)

## Use the coding guidance

`AGENTS.md` is the source file for this repository's coding guidance. The
`CLAUDE.md` link keeps the same guidance available to tools that look for that
filename.

To copy the guidance to another repository:

```bash
TARGET_REPO=/path/to/target-repo
cp AGENTS.md "$TARGET_REPO/AGENTS.md"
ln -sfn AGENTS.md "$TARGET_REPO/CLAUDE.md"
```

Edit `AGENTS.md` directly. A copied file does not update automatically.

## Install skills
```
git clone https://github.com/josephbolus/agent-kit
```
The installer accepts `--personal` or `--project`. With no skill name, it
installs every skill. Personal installation creates symlinks; project
installation creates copies under `.agents/skills/`.

```bash
# Preview all personal-scope links.
bin/install-skills.sh --personal --dry-run

# Symlink all skills into ~/.claude/skills.
bin/install-skills.sh --personal

# Install one skill into an existing project.
bin/install-skills.sh --project /path/to/target-repo architecture-decisions
```

Set `CLAUDE_SKILLS_DIR` to change the personal destination. The project
destination is always `<target>/.agents/skills`.

## Commands

Files in [`commands/`](commands/) are prompt definitions, not executable
scripts. Copy the commands needed by a project into that project's command
directory, or use them as source material for an agent workflow. This
repository does not provide a command installer.

Available commands:

| Area | Commands |
| --- | --- |
| Planning and implementation | [`create_plan`](commands/create_plan.md), [`create_plan_generic`](commands/create_plan_generic.md), [`create_plan_nt`](commands/create_plan_nt.md), [`implement_plan`](commands/implement_plan.md), [`validate_plan`](commands/validate_plan.md) |
| Research and continuity | [`research_codebase`](commands/research_codebase.md), [`research_codebase_generic`](commands/research_codebase_generic.md), [`research_codebase_nt`](commands/research_codebase_nt.md), [`create_handoff`](commands/create_handoff.md), [`resume_handoff`](commands/resume_handoff.md) |
| Review and delivery | [`commit`](commands/commit.md), [`ci_commit`](commands/ci_commit.md), [`describe_pr`](commands/describe_pr.md), [`ci_describe_pr`](commands/ci_describe_pr.md), [`local_review`](commands/local_review.md), [`create_worktree`](commands/create_worktree.md) |
| Ticket and workflow automation | [`linear`](commands/linear.md), [`founder_mode`](commands/founder_mode.md), [`ralph_research`](commands/ralph_research.md), [`ralph_plan`](commands/ralph_plan.md), [`ralph_impl`](commands/ralph_impl.md), [`oneshot`](commands/oneshot.md), [`oneshot_plan`](commands/oneshot_plan.md) |
| Troubleshooting | [`debug`](commands/debug.md) |

Some workflow commands reference optional tools or paths from the
HumanLayer development environment, such as `humanlayer`, `thoughts/`, and
Linear. Adapt those steps when using the prompts in another environment.

## Agents

Files in [`agents/`](agents/) define specialist prompts. They describe a
role, its tools, and an output format; they are not skills and are not
executed by this repository.

| Agent | Purpose |
| --- | --- |
| [`codebase-analyzer`](agents/codebase-analyzer.md) | Explain implementation details and data flow |
| [`codebase-locator`](agents/codebase-locator.md) | Locate files and components relevant to a topic |
| [`codebase-pattern-finder`](agents/codebase-pattern-finder.md) | Show existing implementation and testing patterns |
| [`thoughts-analyzer`](agents/thoughts-analyzer.md) | Extract useful decisions and constraints from thought documents |
| [`thoughts-locator`](agents/thoughts-locator.md) | Find and categorize thought documents |
| [`web-search-researcher`](agents/web-search-researcher.md) | Research current information from external sources |

## Skills

Each skill directory contains a `SKILL.md` file with frontmatter and
instructions. Reference files hold larger material that the skill can load
when needed. See the [`skills/`](skills/) directory for the complete inventory.

| Skill | Purpose |
| --- | --- |
| [`agent-browser`](skills/agent-browser/SKILL.md) | Automate browser workflows |
| [`architecture`](skills/architecture/SKILL.md) | Maintain architecture documentation |
| [`architecture-decisions`](skills/architecture-decisions/SKILL.md) | Maintain architecture decision records |
| [`architecture-review`](skills/architecture-review/SKILL.md) | Review technical proposals |
| [`bash-style`](skills/bash-style/SKILL.md) | Write and review Bash scripts |
| [`build-iterated-agentic-loop`](skills/build-iterated-agentic-loop/SKILL.md) | Build an iterated coding-agent loop |
| [`caveman`](skills/caveman/SKILL.md) | Apply simple, direct implementation practices |
| [`cli-tools`](skills/cli-tools/SKILL.md) | Reference local CLI development tools |
| [`codex-issue-coordinator`](skills/codex-issue-coordinator/SKILL.md) | Coordinate batches of GitHub issues |
| [`design`](skills/design/SKILL.md) | Write a technical design |
| [`design-control-loop`](skills/design-control-loop/SKILL.md) | Design and build an agentic control loop |
| [`diagnose`](skills/diagnose/SKILL.md) | Diagnose bugs and performance regressions |
| [`find-skills`](skills/find-skills/SKILL.md) | Discover and install skills |
| [`frontend-design`](skills/frontend-design/SKILL.md) | Design distinctive frontend interfaces |
| [`ghidra`](skills/ghidra/SKILL.md) | Reverse engineer binaries with Ghidra |
| [`github`](skills/github/SKILL.md) | Interact with GitHub using the gh CLI |
| [`google-workspace`](skills/google-workspace/SKILL.md) | Access Google Workspace APIs |
| [`grill-me`](skills/grill-me/SKILL.md) | Resolve plan and design ambiguity |
| [`grill-with-docs`](skills/grill-with-docs/SKILL.md) | Challenge plans and update decision docs |
| [`html-doc`](skills/html-doc/SKILL.md) | Render Markdown plans as static HTML |
| [`improve`](skills/improve/SKILL.md) | Simplify code without behavior changes |
| [`improve-claude-md`](skills/improve-claude-md/SKILL.md) | Improve CLAUDE.md instructions |
| [`improve-codebase-architecture`](skills/improve-codebase-architecture/SKILL.md) | Find architecture deepening opportunities |
| [`internal-comms`](skills/internal-comms/SKILL.md) | Write internal communications |
| [`karpathy-guidelines`](skills/karpathy-guidelines/SKILL.md) | Reduce common mistakes in coding tasks |
| [`mcp-builder`](skills/mcp-builder/SKILL.md) | Create MCP servers |
| [`mysql`](skills/mysql/SKILL.md) | Plan and review MySQL database work |
| [`narrow-react-prop-types`](skills/narrow-react-prop-types/SKILL.md) | Narrow React component prop types |
| [`plan`](skills/plan/SKILL.md) | Turn approved designs into ordered tasks |
| [`progrium`](skills/progrium/SKILL.md) | Apply practical programming guidance |
| [`review`](skills/review/SKILL.md) | Review implementation changes |
| [`roboporter`](skills/roboporter/SKILL.md) | Port observable software behavior across environments |
| [`show-me`](skills/show-me/SKILL.md) | Explain topics with focused visuals |
| [`skill-creator`](skills/skill-creator/SKILL.md) | Create effective agent skills |
| [`task-to-pr`](skills/task-to-pr/SKILL.md) | Deliver tested and reviewed pull requests |
| [`tdd`](skills/tdd/SKILL.md) | Use test-driven development |
| [`test`](skills/test/SKILL.md) | Verify changes against acceptance criteria |
| [`theme-factory`](skills/theme-factory/SKILL.md) | Apply visual themes to artifacts |
| [`to-issues`](skills/to-issues/SKILL.md) | Turn plans into implementation issues |
| [`to-prd`](skills/to-prd/SKILL.md) | Turn context into a project PRD |
| [`triage`](skills/triage/SKILL.md) | Triage issues through a state machine |
| [`unslop`](skills/unslop/SKILL.md) | Remove AI tells from writing |
| [`web-artifacts-builder`](skills/web-artifacts-builder/SKILL.md) | Build complex HTML artifacts |
| [`webapp-testing`](skills/webapp-testing/SKILL.md) | Test local web applications |
| [`write-a-skill`](skills/write-a-skill/SKILL.md) | Create skills with bundled resources |
| [`zoom-out`](skills/zoom-out/SKILL.md) | Provide broader context |

## Validate changes

Run the repository checks from its root:

```bash
bin/validate.sh
shellcheck bin/*.sh
```

`bin/validate.sh` checks that every skill has valid frontmatter and that
relative Markdown links inside skills resolve. The GitHub Actions workflow runs
both checks for pushes and pull requests.

When adding a skill, keep its directory name, frontmatter `name`, and
lowercase kebab-case format aligned. Add large supporting material under that
skill's `references/` directory and use relative links.

## License

See [`LICENSE`](LICENSE).
