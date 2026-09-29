# 🦅 crowkit-agent-starter

> **Optimized AI agent template** for any software project — token-efficient skills, context-aware loading, and automation scripts ready to use.

## What is this?

A GitHub Template Repository that sets up a complete `.agents/` directory in your project with:

- ✅ **Condensed AGENTS.md** — ~1 900 tokens (vs typical 5 000+)
- ✅ **15 specialized skills** — universal + stack-specific
- ✅ **4 automation scripts** — token audit, skill lint, context builder, lazy loader
- ✅ **Lazy-loaded examples** — code snippets that cost 0 tokens until needed
- ✅ **`init.sh`** — configures the template for your specific stack in seconds

## Quick Start

### Option 1 — GitHub UI
1. Click **"Use this template"** → **"Create a new repository"**
2. Clone your new repo
3. Run `./init.sh`

### Option 2 — GitHub CLI
```bash
gh repo create my-project --template luisfdocelis/crowkit-agent-starter --clone
cd my-project
./init.sh
```

## What `init.sh` configures

```
? Project name: my-api
? Stack:
  ❯ C++20 + Crow Framework
    Generic (language-agnostic)
? CI/CD:
  ❯ GitHub Actions
    None
? Infrastructure:
  ❯ Docker + Terraform
    Docker only
    None
```

Based on your answers, `init.sh`:
- Fills in `{{PROJECT_NAME}}` placeholders in `AGENTS.md`
- Copies the right stack skills into `.agents/skills/`
- Removes unused stack directories
- Makes all scripts executable

## Token Budget (after setup)

| File | Size | ~Tokens |
|:---|:---:|:---:|
| `AGENTS.md` (system prompt) | ~6 700 bytes | **~1 900** |
| Universal skills (all loaded) | ~25 000 bytes | ~7 100 |
| With `context-builder.sh` (selective) | varies | **~200–4 900** |

## Scripts

```bash
# Audit token consumption across all agent files
./.agents/scripts/token-audit.sh [--json] [--fail-on-violations]

# Lint all SKILL.md files against the token budget standard
./.agents/scripts/skill-lint.sh [<skill>] [--fix-hints] [--strict]

# Build minimal context for a specific task type
./.agents/scripts/context-builder.sh <task-type> [--list] [--dry-run]
# Task types: feature bugfix qa ci cd infra git docs review refactor hotfix

# Load a skill on-demand (lazy loading)
./.agents/scripts/lazy-skill.sh <skill-name> [--info] [--example <file>]
./.agents/scripts/lazy-skill.sh --list
```

## Skills Structure

```
.agents/skills/
├── universal/          # Work with ANY project/language
│   ├── git-manager/
│   ├── bug-hunter/
│   ├── feature-planner/
│   ├── code-review-runner/
│   ├── qa-orchestrator/
│   │   └── templates/qa-report.md
│   ├── test-generator/
│   ├── docs-generator/
│   └── refactor-optimizer/
└── stacks/
    ├── cpp-crow/       # C++20 + Crow Framework
    │   ├── cpp/
    │   │   └── examples/   # lazy-loaded C++ snippets
    │   ├── crow-rest-api-architecture/
    │   ├── crud-generator/
    │   ├── ci-manager/
    │   ├── cd-manager/
    │   ├── infra-manager/
    │   └── terraform-manager/
    └── generic/        # Stub — add your own stack skills here
```

## Adding Custom Skills

Every `SKILL.md` must follow the token budget standard:

```yaml
---
name: my-skill
description: One-line description ≤ 120 chars.
---

# My Skill

## Rules
- Rule 1
- Rule 2

## Examples
See [examples/usage.ext](examples/usage.ext)
```

Validate with:
```bash
./.agents/scripts/skill-lint.sh my-skill --fix-hints
```

**Budget rules (enforced by `skill-lint.sh`):**
- `SKILL.md` ≤ 5 000 bytes soft limit / 8 000 bytes hard limit
- ≤ 3 code blocks inline (rest → `examples/`)
- No Mermaid diagrams inline (→ `resources/`)
- Filename must be exactly `SKILL.md` (not `SKILL.MD`)

## License

MIT — use freely in any project.
