#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMMANDS_DIR="${SCRIPT_DIR}/../commands"
SKILLS_DIR="${SCRIPT_DIR}/../.agents/skills"
SKILLS_FILENAME="SKILL.md"

CLAUDE_COMMANDS_DIR="${HOME}/.claude/commands"
CODEX_SKILLS_DIR="${HOME}/.agents/skills"
LEGACY_CODEX_PROMPTS_DIR="${HOME}/.codex/prompts"

if [ ! -d "${COMMANDS_DIR}" ]; then
	echo "Error: commands directory not found at ${COMMANDS_DIR}" >&2
	exit 1
fi

if [ ! -d "${SKILLS_DIR}" ]; then
	echo "Error: skills directory not found at ${SKILLS_DIR}" >&2
	exit 1
fi

ensure_symlink() {
	local source_path="$1"
	local link_path="$2"
	local normalized_source

	normalized_source="$(normalize_path "${source_path}")"

	if [ -L "${link_path}" ]; then
		local existing_target
		existing_target="$(normalized_link_target "${link_path}")"
		if [ "${existing_target}" = "${normalized_source}" ]; then
			echo "Already linked: ${link_path}"
			return
		fi
		echo "Updating symlink: ${link_path} (was → ${existing_target})"
		rm "${link_path}"
	elif [ -e "${link_path}" ]; then
		echo "Skipping: ${link_path} exists and is not a symlink" >&2
		return
	fi

	ln -s "${source_path}" "${link_path}"
	echo "Linked: ${link_path} → ${source_path}"
}

ensure_directory() {
	local dir_path="$1"

	if [ -L "${dir_path}" ]; then
		echo "Replacing symlinked directory: ${dir_path}"
		rm "${dir_path}"
	elif [ -e "${dir_path}" ] && [ ! -d "${dir_path}" ]; then
		echo "Skipping: ${dir_path} exists and is not a directory" >&2
		return 1
	fi

	mkdir -p "${dir_path}"
}

normalize_path() {
	local path="$1"
	local dir_path
	local base_name

	dir_path="$(dirname "${path}")"
	base_name="$(basename "${path}")"

	printf "%s/%s\n" "$(cd "${dir_path}" && pwd -P)" "${base_name}"
}

normalized_link_target() {
	local link_path="$1"
	local raw_target

	raw_target="$(readlink "${link_path}")"

	case "${raw_target}" in
	/*)
		normalize_path "${raw_target}"
		;;
	*)
		normalize_path "$(dirname "${link_path}")/${raw_target}"
		;;
	esac
}

materialize_file() {
	local source_path="$1"
	local target_path="$2"

	if [ -e "${target_path}" ] && [ ! -f "${target_path}" ] && [ ! -L "${target_path}" ]; then
		echo "Skipping: ${target_path} exists and is not a file" >&2
		return 1
	fi

	if [ -L "${target_path}" ]; then
		rm "${target_path}"
	fi

	if [ -f "${target_path}" ] && cmp -s "${source_path}" "${target_path}"; then
		echo "Already materialized: ${target_path}"
		return 0
	fi

	rm -f "${target_path}"

	if ln "${source_path}" "${target_path}" 2>/dev/null; then
		echo "Hard linked: ${target_path} → ${source_path}"
		return 0
	fi

	cp "${source_path}" "${target_path}"
	echo "Copied: ${target_path} ← ${source_path}"
}

sync_skill_support_tree() {
	local source_root="$1"
	local target_root="$2"

	if [ ! -d "${source_root}" ]; then
		return 0
	fi

	while IFS= read -r -d '' source_path; do
		local relative_path
		local target_path
		local base_name

		relative_path="${source_path#"${source_root}/"}"
		target_path="${target_root}/${relative_path}"
		base_name="$(basename "${source_path}")"

		if [ "${base_name}" = "${SKILLS_FILENAME}" ]; then
			continue
		fi

		if [ -d "${source_path}" ]; then
			ensure_directory "${target_path}" || continue
			continue
		fi

		if [ ! -f "${source_path}" ]; then
			echo "Skipping unsupported support entry: ${source_path}" >&2
			continue
		fi

		ensure_directory "$(dirname "${target_path}")" || continue
		materialize_file "${source_path}" "${target_path}"
	done < <(find "${source_root}" -mindepth 1 -print0)
}

remove_legacy_prompt_symlink() {
	local legacy_path="$1"
	local command_target="$2"
	local normalized_existing_target
	local normalized_command_target

	if [ ! -L "${legacy_path}" ]; then
		return
	fi

	normalized_existing_target="$(normalized_link_target "${legacy_path}")"
	normalized_command_target="$(normalize_path "${command_target}")"

	if [ "${normalized_existing_target}" != "${normalized_command_target}" ]; then
		echo "Leaving legacy prompt symlink in place: ${legacy_path} → ${normalized_existing_target}"
		return
	fi

	rm "${legacy_path}"
	echo "Removed legacy prompt symlink: ${legacy_path}"
}

mkdir -p "${CLAUDE_COMMANDS_DIR}"
mkdir -p "${CODEX_SKILLS_DIR}"

for cmd_file in "${COMMANDS_DIR}"/*.md; do
	[ -f "${cmd_file}" ] || continue

	filename="$(basename "${cmd_file}")"
	ensure_symlink "${cmd_file}" "${CLAUDE_COMMANDS_DIR}/${filename}"
done

for cmd_file in "${COMMANDS_DIR}"/*.md; do
	[ -f "${cmd_file}" ] || continue

	skill_name="$(basename "${cmd_file}" .md)"
	skill_dir="${SKILLS_DIR}/${skill_name}"
	target_skill_dir="${CODEX_SKILLS_DIR}/${skill_name}"

	if [ -L "${target_skill_dir}" ]; then
		existing_target="$(normalized_link_target "${target_skill_dir}")"
		expected_legacy_target="$(normalize_path "${skill_dir}")"
		if [ "${existing_target}" = "${expected_legacy_target}" ]; then
			echo "Replacing legacy Codex skill symlink: ${target_skill_dir}"
			rm "${target_skill_dir}"
		else
			echo "Skipping: ${target_skill_dir} is a symlink managed elsewhere (${existing_target})" >&2
			continue
		fi
	fi

	ensure_directory "${target_skill_dir}" || continue
	materialize_file "${cmd_file}" "${target_skill_dir}/${SKILLS_FILENAME}"
	sync_skill_support_tree "${skill_dir}" "${target_skill_dir}"
	remove_legacy_prompt_symlink \
		"${LEGACY_CODEX_PROMPTS_DIR}/${skill_name}.md" \
		"${cmd_file}"
done
