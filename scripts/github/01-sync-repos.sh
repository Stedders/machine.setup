#!/usr/bin/env bash
# Sync all GitHub repos: clone missing, fetch existing.
#
# Clones into ~/code/github.com/{owner}/{repo} using SSH.
# Covers: owned repos, forks, org repos, and collaborator repos.
#
# Requires: gh (authenticated), git
#
# Run: bash scripts/github/01-sync-repos.sh

set -euo pipefail

BASE_DIR="${HOME}/code/github.com"

echo "=== GitHub Repo Sync ==="
echo "Base directory: ${BASE_DIR}"
echo ""

# Gather all repos the authenticated user has access to
# --json provides structured output; affiliations cover owner, collaborator, and org member
echo "Fetching repo list from GitHub..."
REPOS=$(gh api user/repos --paginate --jq '.[] | "\(.full_name) \(.ssh_url)"')

# Also fetch org repos (gh api user/repos may miss some org repos depending on permissions)
ORGS=$(gh api user/memberships/orgs --jq '.[].organization.login' 2>/dev/null || true)
for org in ${ORGS}; do
    ORG_REPOS=$(gh api "orgs/${org}/repos" --paginate --jq '.[] | "\(.full_name) \(.ssh_url)"' 2>/dev/null || true)
    if [[ -n "${ORG_REPOS}" ]]; then
        REPOS=$(printf '%s\n%s' "${REPOS}" "${ORG_REPOS}")
    fi
done

# Deduplicate
REPOS=$(echo "${REPOS}" | sort -u)

CLONED=0
FETCHED=0
FAILED=0
TOTAL=0

while IFS=' ' read -r full_name ssh_url; do
    [[ -z "${full_name}" ]] && continue
    TOTAL=$((TOTAL + 1))

    owner="${full_name%%/*}"
    repo="${full_name##*/}"
    repo_dir="${BASE_DIR}/${owner}/${repo}"

    if [[ -d "${repo_dir}/.git" ]]; then
        echo "  fetch  ${full_name}"
        if git -C "${repo_dir}" fetch --all --prune --quiet 2>/dev/null; then
            FETCHED=$((FETCHED + 1))
        else
            echo "  FAIL   ${full_name} (fetch failed)"
            FAILED=$((FAILED + 1))
        fi
    else
        echo "  clone  ${full_name}"
        mkdir -p "${BASE_DIR}/${owner}"
        if git clone --quiet "${ssh_url}" "${repo_dir}" 2>/dev/null; then
            CLONED=$((CLONED + 1))
        else
            echo "  FAIL   ${full_name} (clone failed)"
            FAILED=$((FAILED + 1))
        fi
    fi
done <<< "${REPOS}"

echo ""
echo "=== Done ==="
echo "Total: ${TOTAL} | Cloned: ${CLONED} | Fetched: ${FETCHED} | Failed: ${FAILED}"
