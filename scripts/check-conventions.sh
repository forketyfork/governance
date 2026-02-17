#!/usr/bin/env bash
set -euo pipefail

# Validates conventions that are tagged [auto: check-conventions] in
# docs/CONVENTIONS.md.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="${SCRIPT_DIR}/.."

errors=0

error() {
	errors=$((errors + 1))
	printf "ERROR: %s\n" "$1" >&2
}

# ── AGENTS.md symlink ────────────────────────────────────────────────────────

if [ -e "${REPO_ROOT}/AGENTS.md" ]; then
	if [ ! -L "${REPO_ROOT}/AGENTS.md" ]; then
		error "AGENTS.md exists but is not a symlink (must be a symlink to CLAUDE.md)"
	elif [ "$(readlink "${REPO_ROOT}/AGENTS.md")" != "CLAUDE.md" ]; then
		error "AGENTS.md is a symlink but does not point to CLAUDE.md"
	fi
fi

# ── Shell scripts must start with shebang + strict mode ──────────────────────

for f in "${REPO_ROOT}"/scripts/*.sh; do
	[ -e "${f}" ] || continue
	name="$(basename "${f}")"
	line1="$(sed -n '1p' "${f}")"
	line2="$(sed -n '2p' "${f}")"
	if [ "${line1}" != "#!/usr/bin/env bash" ]; then
		error "scripts/${name}: first line must be #!/usr/bin/env bash"
	fi
	if [ "${line2}" != "set -euo pipefail" ]; then
		error "scripts/${name}: second line must be set -euo pipefail"
	fi
done

# ── Command spec line count (max 150, reference files exempt) ────────────────

MAX_LINES=150
for f in "${REPO_ROOT}"/commands/*.md; do
	[ -e "${f}" ] || continue
	name="$(basename "${f}")"
	# Reference files (managing-*.md) are exempt
	if [[ ${name} == managing-* ]]; then
		continue
	fi
	lines="$(wc -l <"${f}")"
	if [ "${lines}" -gt "${MAX_LINES}" ]; then
		error "commands/${name}: ${lines} lines exceeds ${MAX_LINES}-line ceiling"
	fi
done

# ── Day-to-day commands must not reference governance documents ───────────────

DAY_TO_DAY=(bug feature tech implement ship review address)
GOVERNANCE_PATTERN='CONSTITUTION\.md|FEDERATION\.md|ADMITTANCE\.md'

for cmd in "${DAY_TO_DAY[@]}"; do
	f="${REPO_ROOT}/commands/${cmd}.md"
	[ -e "${f}" ] || continue
	if grep -qE "${GOVERNANCE_PATTERN}" "${f}"; then
		error "commands/${cmd}.md: day-to-day command must not reference governance documents"
	fi
	if grep -qwi 'Land' "${f}"; then
		error "commands/${cmd}.md: day-to-day command must not use federation terminology (\"Land\")"
	fi
done

# ── Summary ──────────────────────────────────────────────────────────────────

if [ "${errors}" -gt 0 ]; then
	printf "\ncheck-conventions: %d error(s) found\n" "${errors}" >&2
	exit 1
fi
