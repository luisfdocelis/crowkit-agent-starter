# Development Flows & Agent Interactions — {{PROJECT_NAME}} 🦅

> **Read this file only when you need detailed flow diagrams or the agent interaction matrix.**
> For day-to-day rules, see `.agents/AGENTS.md`.

---

## 1. Feature Development Flow (Size M & L)

**Phases:**
1. **Pause 1 — Design approval:** agent presents size (M/L) and technical plan → user approves.
2. **Autonomous loop:** branch → docs → code → tests → verify → PR → CI monitor.
3. **Pause 2 — Merge:** all CI green → agent stops → waits for explicit user confirmation → merge.

**Scripts:**
```bash
./.agents/scripts/start-branch.sh feat "<feature-name>"
# ... implement ...
./.agents/scripts/pr-flow.sh "<title>" "<description>"
```

---

## 2. Fast-Track Flow (Size S)

For `fix/`, `chore/`, `refactor/` with < 50 lines:

```
start-branch.sh → edit (<50 lines) → verify.sh → pr-flow.sh → CI green → [PAUSE] user confirms → merge
```

No `docs/plans/` files required. Justification goes in commit message + PR body.

---

## 3. Hotfix Flow

```
Create hotfix/<slug> from main →
bug-hunter (RCA) →
design regression test (fails without fix) →
apply minimal fix →
regression test passes →
qa-orchestrator verifies gates →
PR to main → [PAUSE] user confirms → merge →
cherry-pick to development →
postmortem in docs/reports/bugs.md
```

---

## 4. Greenfield Flow

```
Clarify requirements →
Create docs/features/XX-module.md →
Update docs/backlog/ →
[PAUSE 1] User approves →
feat/<name> branch →
Full Size L cycle
```

---

## 5. Agent Interaction Matrix

| Sender | Receiver | Trigger | Output |
|:---|:---|:---|:---|
| Orchestrator | `feature-planner` | New feature or Greenfield | Plan doc in `docs/plans/` |
| Orchestrator | `qa-orchestrator` | Pre-push validation | Quality gates report |
| Orchestrator | `git-manager` | Branch, commit, PR | Branch created / PR opened |
| `qa-orchestrator` | `test-generator` | Missing tests detected | New test files |
| `qa-orchestrator` | `bug-hunter` | Test failure / crash | RCA + regression test |
| `qa-orchestrator` | `code-review-runner` | Risk audit | Findings by severity |

---

## 6. Mandatory Guardrails

1. **Never push if verify.sh fails** (exit code ≠ 0).
2. **Never merge autonomously** — always pause and request explicit user confirmation.
3. **Never commit secrets** — `.tfstate`, tokens, private keys → always in `.gitignore`.
4. **Close docs before opening PR** — update `docs/backlog/` and `docs/reports/` first.
