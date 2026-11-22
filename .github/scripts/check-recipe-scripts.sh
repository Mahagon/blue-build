#!/usr/bin/env bash
# Check that recipes and files/scripts agree. CI tests every script by
# directory, but the image build only runs the ones listed in a recipe,
# so a script missing from a recipe is tested yet never installed.
set -euo pipefail

declare -A dirs=(
  [work]="shared work"
  [gaming]="shared gaming"
)

status=0
for image in "${!dirs[@]}"; do
  recipe="recipes/${image}.yml"
  listed="$(yq '.modules[] | select(.type == "script") | .scripts[]' "$recipe" | sort)"

  for script in $listed; do
    if [[ ! -f "files/scripts/${script}" ]]; then
      echo "::error file=${recipe}::${recipe} lists ${script}, but files/scripts/${script} does not exist"
      status=1
    fi
  done

  for dir in ${dirs[$image]}; do
    for path in files/scripts/"${dir}"/*.sh; do
      [[ -e "$path" ]] || continue
      script="${path#files/scripts/}"
      if ! grep -qxF "$script" <<<"$listed"; then
        echo "::error file=${path}::${script} is not listed under 'type: script' in ${recipe}"
        status=1
      fi
    done
  done
done

exit "$status"
