#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMMANDS_DIR="${SCRIPT_DIR}/../commands"

TARGET_DIRS=(
	"${HOME}/.claude/commands"
	"${HOME}/.codex/prompts"
)

if [ ! -d "${COMMANDS_DIR}" ]; then
	echo "Error: commands directory not found at ${COMMANDS_DIR}" >&2
	exit 1
fi

for target_dir in "${TARGET_DIRS[@]}"; do
	mkdir -p "${target_dir}"

	for cmd_file in "${COMMANDS_DIR}"/*.md; do
		[ -f "${cmd_file}" ] || continue

		filename="$(basename "${cmd_file}")"
		link_path="${target_dir}/${filename}"

		if [ -L "${link_path}" ]; then
			existing_target="$(readlink "${link_path}")"
			if [ "${existing_target}" = "${cmd_file}" ]; then
				echo "Already linked: ${link_path}"
				continue
			fi
			echo "Updating symlink: ${link_path} (was → ${existing_target})"
			rm "${link_path}"
		elif [ -e "${link_path}" ]; then
			echo "Skipping: ${link_path} exists and is not a symlink" >&2
			continue
		fi

		ln -s "${cmd_file}" "${link_path}"
		echo "Linked: ${link_path} → ${cmd_file}"
	done
done
