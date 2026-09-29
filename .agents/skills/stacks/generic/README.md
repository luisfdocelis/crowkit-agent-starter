# Generic Stack — Add Your Skills Here

This directory is a placeholder for your project's stack-specific skills.

## How to add a custom skill

1. Create a directory: `.agents/skills/<skill-name>/`
2. Create `SKILL.md` following the token budget standard:

```yaml
---
name: my-skill
description: One concise line ≤ 120 chars.
---

# My Skill

## Rules
- Rule 1 (concise, actionable)
- Rule 2

## Examples
See [examples/usage.ext](examples/usage.ext)
```

3. Add code examples to `examples/` (they cost 0 tokens until explicitly read):
```
.agents/skills/<skill-name>/
  SKILL.md          ← rules only, ≤ 5 000 bytes
  examples/
    usage.ext       ← lazy-loaded code example
  templates/
    template.md     ← lazy-loaded template
```

4. Validate with the linter:
```bash
./.agents/scripts/skill-lint.sh <skill-name> --fix-hints
```

## Token Budget Rules (enforced by skill-lint.sh)

| Rule | Limit |
|:---|:---|
| `SKILL.md` size | ≤ 5 000 bytes (soft) / 8 000 bytes (hard) |
| Lines | ≤ 150 (soft) / 250 (hard) |
| Inline code blocks | ≤ 3 (rest → `examples/`) |
| Mermaid diagrams | 0 inline (→ `resources/`) |
| Filename | exactly `SKILL.md` (not `SKILL.MD`) |
| `description:` | 1 line, ≤ 120 chars |
