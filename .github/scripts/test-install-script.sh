#!/usr/bin/env bash
# Run one install script as root and fail unless it put something new
# under /usr or /opt. Install scripts end in /usr/bin, /usr/lib or
# /usr/share, so an empty result means the script silently did nothing.
set -euo pipefail

script="${1:?usage: $0 <install-script>}"

marker="$(mktemp)"
installed="$(mktemp)"
trap 'rm -f "$marker" "$installed"' EXIT

sudo bash "$script"

# ctime changes on create, extract and mv, unlike mtime, which tar and
# unzip restore from the archive. Only find needs root, not the output file.
# shellcheck disable=SC2024
sudo find /usr /opt -cnewer "$marker" \( -type f -o -type l \) \
  2>/dev/null >"$installed" || true

count="$(wc -l <"$installed")"
if [[ "$count" -eq 0 ]]; then
  echo "::error file=${script}::${script} did not install anything under /usr or /opt"
  exit 1
fi

echo "${script} installed ${count} file(s):"
head -n 20 "$installed"
