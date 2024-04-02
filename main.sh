#!/bin/bash

set -euo pipefail

git branch -a
git remote -v

if [ -z "$SOURCE_REMOTE" ] && [ -z "$SOURCE_BRANCH" ]; then
  source_refs=$GITHUB_REF
elif [ -z "$SOURCE_REMOTE" ] || [ -z "$SOURCE_BRANCH" ]; then
  echo "If you specify source-remote or source-branch, you need to set both of them."
  exit 1
else
  source_refs="refs/remotes/$SOURCE_REMOTE/$SOURCE_BRANCH"
  git fetch --depth=1 --quiet "$SOURCE_REMOTE" "$SOURCE_BRANCH"
fi

if [ -z "$TARGET_REMOTE" ] && [ -z "$TARGET_BRANCH" ]; then
  target_refs=$GITHUB_REF
elif [ -z "$TARGET_REMOTE" ] || [ -z "$TARGET_BRANCH" ]; then
  echo "If you specify target-remote or target-branch, you need to set both of them."
  exit 1
else
  target_refs="refs/remotes/$TARGET_REMOTE/$TARGET_BRANCH"
  git fetch --depth=1 --quiet "$TARGET_REMOTE" "$TARGET_BRANCH"
fi

echo "Using $source_refs for source"
echo "Using $target_refs for target"

echo
echo "================================================"
echo "| source-refs: $source_refs                     "
echo "| target-refs: $target_refs                     "
echo "| target-file: $TARGET_FILE                     "
echo "================================================"
echo

echo "$TARGET_FILE" | tr ',' '\n' | while read -r file; do
  file=$(printf '%q' "$file")
  git_diff_ret_code=0
  git diff --exit-code "$target_refs..$source_refs" -- "$file" || git_diff_ret_code=$?
  if [ $git_diff_ret_code != 1 ]; then
            echo "$file is not updated."
            exit 1
          fi
        done
