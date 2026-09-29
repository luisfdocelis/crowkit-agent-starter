#!/usr/bin/env bash
# =============================================================================
# init.sh — crowkit-agent-starter initializer
# =============================================================================
# Configures the .agents/ template for your specific project.
# Run once after cloning or using this template.
#
# Usage:
#   ./init.sh
#   ./init.sh --name my-project --stack cpp-crow --ci github-actions --infra docker-terraform
#   ./init.sh --non-interactive  (uses defaults: generic stack, github actions, no infra)
# =============================================================================
set -euo pipefail

# ─── Colors ───────────────────────────────────────────────────────────────────
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

AGENTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.agents"
STACKS_DIR="${AGENTS_DIR}/skills/stacks"

# ─── Defaults ─────────────────────────────────────────────────────────────────
PROJECT_NAME=""
STACK="generic"
CI="github-actions"
INFRA="none"
NON_INTERACTIVE=false

# ─── Parse flags ──────────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --name)          PROJECT_NAME="$2"; shift 2 ;;
    --stack)         STACK="$2"; shift 2 ;;
    --ci)            CI="$2"; shift 2 ;;
    --infra)         INFRA="$2"; shift 2 ;;
    --non-interactive) NON_INTERACTIVE=true; shift ;;
    *) shift ;;
  esac
done

# ─── Banner ───────────────────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}║   🦅 crowkit-agent-starter — Project Initializer        ║${NC}"
echo -e "${BOLD}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""

# ─── Interactive prompts ───────────────────────────────────────────────────────
if [[ "$NON_INTERACTIVE" == "false" ]]; then

  # Project name
  if [[ -z "$PROJECT_NAME" ]]; then
    default_name=$(basename "$(pwd)")
    read -rp "$(echo -e "${CYAN}? Project name${NC} [${default_name}]: ")" input
    PROJECT_NAME="${input:-$default_name}"
  fi

  # Stack
  echo ""
  echo -e "${CYAN}? Stack:${NC}"
  echo "  1) C++20 + Crow Framework"
  echo "  2) Generic (language-agnostic)"
  read -rp "  Choice [2]: " stack_choice
  case "${stack_choice:-2}" in
    1) STACK="cpp-crow" ;;
    *) STACK="generic" ;;
  esac

  # CI/CD
  echo ""
  echo -e "${CYAN}? CI/CD:${NC}"
  echo "  1) GitHub Actions"
  echo "  2) None"
  read -rp "  Choice [1]: " ci_choice
  case "${ci_choice:-1}" in
    1) CI="github-actions" ;;
    *) CI="none" ;;
  esac

  # Infrastructure
  echo ""
  echo -e "${CYAN}? Infrastructure:${NC}"
  echo "  1) Docker + Terraform"
  echo "  2) Docker only"
  echo "  3) None"
  read -rp "  Choice [3]: " infra_choice
  case "${infra_choice:-3}" in
    1) INFRA="docker-terraform" ;;
    2) INFRA="docker" ;;
    *) INFRA="none" ;;
  esac

fi

case "$STACK" in
  cpp-crow) STACK_LABEL="C++20 + Crow Framework" ;;
  generic)  STACK_LABEL="Generic (language-agnostic)" ;;
  *) echo "Error: unsupported stack '$STACK' (use cpp-crow or generic)" >&2; exit 2 ;;
esac
case "$CI" in
  github-actions|none) ;;
  *) echo "Error: unsupported CI option '$CI' (use github-actions or none)" >&2; exit 2 ;;
esac
case "$INFRA" in
  docker-terraform|docker|none) ;;
  *) echo "Error: unsupported infrastructure option '$INFRA'" >&2; exit 2 ;;
esac

# Use the current directory name when a non-interactive run omits --name.
if [[ -z "$PROJECT_NAME" ]]; then
  PROJECT_NAME=$(basename "$(pwd)")
fi
if [[ "$PROJECT_NAME" == *$'\n'* ]]; then
  echo "Error: project name must be a single line" >&2
  exit 2
fi
PROJECT_NAME_ESCAPED=$(printf '%s\n' "$PROJECT_NAME" | sed 's/[\/&|\\]/\\&/g')

# ─── Apply project name ───────────────────────────────────────────────────────
echo ""
echo -e "  ${BOLD}Configuring for: ${PROJECT_NAME}${NC}"

# Replace {{PROJECT_NAME}} placeholder in AGENTS.md
if [[ -f "${AGENTS_DIR}/AGENTS.md" ]]; then
  sed -i "s|{{PROJECT_NAME}}|${PROJECT_NAME_ESCAPED}|g" "${AGENTS_DIR}/AGENTS.md"
  sed -i "s|{{STACK_NAME}}|${STACK_LABEL}|g" "${AGENTS_DIR}/AGENTS.md"
  echo -e "  ${GREEN}✓${NC} AGENTS.md configured"
fi

if [[ -f "${AGENTS_DIR}/WORKFLOWS.md" ]]; then
  sed -i "s|{{PROJECT_NAME}}|${PROJECT_NAME_ESCAPED}|g" "${AGENTS_DIR}/WORKFLOWS.md"
fi

# ─── Apply stack ──────────────────────────────────────────────────────────────
STACK_DIR="${STACKS_DIR}/${STACK}"
UNIVERSAL_DIR="${AGENTS_DIR}/skills/universal"
SKILLS_DIR="${AGENTS_DIR}/skills"

# Move selected stack skills into .agents/skills/
if [[ -d "$STACK_DIR" ]]; then
  cp -r "${STACK_DIR}/." "${SKILLS_DIR}/"
  echo -e "  ${GREEN}✓${NC} Stack '${STACK}' skills installed"
else
  echo -e "  ${YELLOW}⚠${NC} Stack '${STACK}' not found — using universal skills only"
fi

# Move universal skills into .agents/skills/
cp -r "${UNIVERSAL_DIR}/." "${SKILLS_DIR}/"
rm -rf "$UNIVERSAL_DIR"
echo -e "  ${GREEN}✓${NC} Universal skills installed"

# Clean up stacks directory (no longer needed)
rm -rf "${STACKS_DIR}"

# ─── Remove infra skills if not needed ───────────────────────────────────────
if [[ "$INFRA" == "none" ]]; then
  rm -rf "${SKILLS_DIR}/infra-manager" "${SKILLS_DIR}/terraform-manager" 2>/dev/null || true
  echo -e "  ${GREEN}✓${NC} Infrastructure skills removed (not needed)"
elif [[ "$INFRA" == "docker" ]]; then
  rm -rf "${SKILLS_DIR}/terraform-manager" 2>/dev/null || true
  echo -e "  ${GREEN}✓${NC} Terraform skills removed (Docker only)"
fi

# ─── Make scripts executable ──────────────────────────────────────────────────
chmod +x "${AGENTS_DIR}/scripts/"*.sh 2>/dev/null || true
echo -e "  ${GREEN}✓${NC} Scripts made executable"

# The context builder discovers installed skills dynamically.
echo -e "  ${GREEN}✓${NC} Context builder will use the installed skills"

# ─── Summary ─────────────────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}║   ✅ Setup complete!                                     ║${NC}"
echo -e "${BOLD}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  Project:     ${BOLD}${PROJECT_NAME}${NC}"
echo -e "  Stack:       ${STACK}"
echo -e "  CI/CD:       ${CI}"
echo -e "  Infra:       ${INFRA}"
echo ""
echo -e "  ${CYAN}Skills installed:${NC}"
find "${SKILLS_DIR}" -maxdepth 1 -mindepth 1 -type d -exec basename {} \; | sort | \
  while read -r skill; do
    printf "    ✓  %s\n" "$skill"
  done
echo ""
echo -e "  ${CYAN}Next steps:${NC}"
echo "    ./.agents/scripts/token-audit.sh          # check token budget"
echo "    ./.agents/scripts/lazy-skill.sh --list    # see all skills"
echo "    ./.agents/scripts/context-builder.sh feature --dry-run"
echo ""
echo -e "  ${YELLOW}Tip:${NC} Delete this init.sh after setup — it's no longer needed."
echo ""
