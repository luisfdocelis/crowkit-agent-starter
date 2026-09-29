# Agent Orchestrator Guide — {{PROJECT_NAME}} 🦅

> Detailed flows, sequence diagrams and interaction matrix: read `.agents/WORKFLOWS.md` only when needed.

---

## 📌 Project Context

- **Project:** {{PROJECT_NAME}}
- **Stack:** *(configured by init.sh)*
- **Key dirs:** `src/` · `tests/` · `docs/` · `.agents/`
- **Doc refs:** `docs/backlog/` · `docs/roadmap/` · `docs/features/` · `docs/plans/` · `docs/reports/`

---

## 🏛️ Available Skills

| Skill | Purpose |
| :--- | :--- |
| **qa-orchestrator** | QA: test pyramid, quality gates, gap analysis |
| **feature-planner** | Planning, technical impact, contracts, rollback |
| **code-review-runner** | Code review, PR audit, vulnerability detection |
| **test-generator** | Unit tests, integration tests, test suites |
| **git-manager** | Branches, commits, PRs, merge flows |
| **bug-hunter** | RCA, log debugging, crash analysis |
| **docs-generator** | OpenAPI, diagrams, technical documentation |
| **refactor-optimizer** | SOLID, tech debt, algorithmic optimization |

> Load a skill on demand: `./.agents/scripts/lazy-skill.sh <name>`
> Minimal context by task: `./.agents/scripts/context-builder.sh <type> --list`

---

## 🗂️ Task Sizing (S / M / L)

| Size | Scope | Branch | Docs |
| :--- | :--- | :--- | :--- |
| **S** Fast-Track | < 50 lines. Fixes, chores, local tweaks. | `fix/` `chore/` `refactor/` `test/` | Commit + PR body only. |
| **M** Standard | 50–250 lines. Module extensions, new endpoints. | `feat/<name>` from `main` | 1 consolidated plan doc in `docs/plans/`. |
| **L** Greenfield | > 250 lines. New libs, architecture changes. | `feat/<name>` or `doc/<name>` | 4 docs: `analysis`, `implementation-plan`, `rollback-plan`, `walkthrough`. |

---

## 🔄 Two-Pause Protocol

**⏸️ PAUSE 1** — Before coding: present size, scope, and design. Wait for user approval.

**Autonomous loop (no interruptions):**
1. Create branch → `start-branch.sh <type> "<name>"`
2. Write technical docs (per S/M/L)
3. Implement code (SOLID, clean architecture)
4. Write tests
5. Run `verify.sh` (build + tests + quality gates)
6. Update `docs/backlog/` and `docs/reports/`
7. Push + PR
8. Monitor CI

**🛑 PAUSE 2 [MANDATORY]** — Green checks: present summary and wait for explicit merge confirmation. **NEVER merge autonomously.**

After merge: `git checkout main && git pull origin main`

---

## 🌿 Branch Prefixes

`feat/` `fix/` `doc/` `test/` `refactor/` `chore/` `release/` `patch/` `hotfix/` `perf/` `ci/` `build/` `sec/` `deps/` `revert/`

**Rules before modifying code:**
1. Define size (S/M/L) and required docs.
2. Confirm scope with user (Pause 1).
3. Create branch with `start-branch.sh` — verify it is NOT `main` or `development`.

> [!IMPORTANT]
> The agent **NEVER** merges autonomously. Always wait for explicit user confirmation.

---

## 🏷️ Chat Naming

Format: `[Phase] - [Version] - [EPIC] - [TASK-ID]: [Title]`

Sync with: `./.agents/scripts/sync-chat-name.sh "<Title>"`

---

## 🆕 Greenfield

1. Clarify requirements and technical constraints.
2. Create `docs/features/XX-module-name.md`.
3. Update `docs/backlog/`.
4. Get approval (Pause 1) → start autonomous loop (Size L).

---

## 📋 Welcome Menu

| # | Option | Skill / Branch |
|:--|:---|:---|
| 1 | New Greenfield feature | `feature-planner` → `feat/` |
| 2 | Implement Backlog item | full S/M/L cycle |
| 3 | Quick fix / Maintenance | Fast-Track → `fix/` `chore/` |
| 4 | QA & local verification | `qa-orchestrator` |
| 5 | Review Backlog & status | read `docs/backlog/` |
| 6 | Update documentation | `docs-generator` → `doc/` |
| 7 | Critical hotfix | `bug-hunter` → `hotfix/` |
| 8 | Functional bugfix | `bug-hunter` → `fix/` |
| 9 | Minor patch | → `patch/` |
| 10 | Performance optimization | `refactor-optimizer` → `perf/` |
| 11 | Security hardening | → `sec/` |
| 12 | Revert changes | → `revert/` |

---

## 🔧 Agent Scripts

```bash
./.agents/scripts/token-audit.sh [--json]             # token consumption audit
./.agents/scripts/skill-lint.sh [<skill>] [--fix-hints] # SKILL.md linter
./.agents/scripts/context-builder.sh <task> [--list]  # minimal context by task
./.agents/scripts/lazy-skill.sh <name> [--info]       # load skill on demand
./.agents/scripts/sync-chat-name.sh "<Title>"         # persist chat name
```
