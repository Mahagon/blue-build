#!/usr/bin/env bash

chart_tag() {
  local chart=$1
  local version=$2
  git tag -a -f "release/chart/$chart/$version" -m "Release $chart version $version"
  git push origin -f "release/chart/$chart/$version"
  echo "Chart $chart tagged with version $version."
  read -r -n 1 -p "Press 'y' to promote the chart: " REPLY
  echo
  if [[ "$REPLY" == "y" ]]; then
    chart_promote "$chart" "$version"
  else
    echo "Chart promotion skipped."
  fi
}

image_tag() {
  local image=$1
  local version=$2
  git tag -a -f "release/image/$image/$version" -m "Release $image version $version"
  git push origin -f "release/image/$image/$version"
  echo "Image $image tagged with version $version."
  read -r -n 1 -p "Press 'y' to promote the image: " REPLY
  echo
  if [[ "$REPLY" == "y" ]]; then
    image_promote "$image" "$version"
  else
    echo "Image promotion skipped."
  fi
}

chart_promote() {
  local chart=$1
  local tag=$2
  local organization="https://dev.azure.com/zvoove/"
  local project="zvoove Platform Engineering"
  local branch="refs/heads/master"
  local pipeline_ids=(211 267 54 55)

  for pipeline_id in "${pipeline_ids[@]}"; do
    local run_id
    run_id=$(az pipelines run \
      --organization "$organization" \
      --project "$project" \
      --branch "$branch" \
      --id "$pipeline_id" \
      --parameters CHART_NAME="$chart" CHART_VERSION="$tag" \
      --query "id" \
      --output tsv)

    echo "Pipeline $pipeline_id started. Waiting for completion..."

    local pipeline_status=""
    while [[ "$pipeline_status" != "completed" ]]; do
      local run_status
      run_status=$(az pipelines runs show \
        --organization "$organization" \
        --project "$project" \
        --id "$run_id" \
        --query "status" \
        --output tsv)

      if [[ "$run_status" == "completed" ]]; then
        local result
        result=$(az pipelines runs show \
          --organization "$organization" \
          --project "$project" \
          --id "$run_id" \
          --query "result" \
          --output tsv)

        if [[ "$result" != "succeeded" ]]; then
          echo "Pipeline $pipeline_id failed with result: $result"
          return 1
        fi

        echo "Pipeline $pipeline_id completed successfully."
        pipeline_status="completed"
      else
        echo "Waiting for pipeline $pipeline_id to complete..."
        sleep 10
      fi
    done
  done
}

image_promote() {
  local image=$1
  local tag=$2
  local organization="https://dev.azure.com/zvoove/"
  local project="zvoove Platform Engineering"
  local branch="refs/heads/master"
  local pipeline_ids=(210 198 157 158)

  for pipeline_id in "${pipeline_ids[@]}"; do
    local run_id
    run_id=$(az pipelines run \
      --organization "$organization" \
      --project "$project" \
      --branch "$branch" \
      --id "$pipeline_id" \
      --parameters IMAGE_NAME="$image" IMAGE_VERSION="$tag" \
      --query "id" \
      --output tsv)

    echo "Pipeline $pipeline_id started. Waiting for completion..."

    local pipeline_status=""
    while [[ "$pipeline_status" != "completed" ]]; do
      local run_status
      run_status=$(az pipelines runs show \
        --organization "$organization" \
        --project "$project" \
        --id "$run_id" \
        --query "status" \
        --output tsv)

      if [[ "$run_status" == "completed" ]]; then
        local result
        result=$(az pipelines runs show \
          --organization "$organization" \
          --project "$project" \
          --id "$run_id" \
          --query "result" \
          --output tsv)

        if [[ "$result" != "succeeded" ]]; then
          echo "Pipeline $pipeline_id failed with result: $result"
          return 1
        fi

        echo "Pipeline $pipeline_id completed successfully."
        pipeline_status="completed"
      else
        echo "Waiting for pipeline $pipeline_id to complete..."
        sleep 10
      fi
    done
  done
}

if [[ -n "${BASH_VERSION:-}" ]]; then
  _chart_subfolders() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local subfolders
    subfolders=$(find ./charts -maxdepth 1 -mindepth 1 -type d -exec basename {} \; 2>/dev/null)
    mapfile -t COMPREPLY < <(compgen -W "$subfolders" -- "$cur")
  }

  _image_subfolders() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local subfolders
    subfolders=$(find ./images -maxdepth 1 -mindepth 1 -type d -exec basename {} \; 2>/dev/null)
    mapfile -t COMPREPLY < <(compgen -W "$subfolders" -- "$cur")
  }

  _chart_complete() {
    case $COMP_CWORD in
      1) _chart_subfolders ;;
    esac
  }

  _image_complete() {
    case $COMP_CWORD in
      1) _image_subfolders ;;
    esac
  }

  complete -F _chart_complete chart_tag chart_promote
  complete -F _image_complete image_tag image_promote
fi
