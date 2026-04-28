#!/bin/bash

set -e

EXCLUDED_FILE=".github/excluded-repos.txt"
INCLUDED_FILE=".github/include-repos.txt"
MAX_PROJECTS=10

# Read excluded repos into array
EXCLUDED=()
if [ -f "$EXCLUDED_FILE" ]; then
  while IFS= read -r line; do
    [[ "$line" =~ ^#.*$ ]] && continue
    [[ -z "$line" ]] && continue
    EXCLUDED+=("$line")
  done < "$EXCLUDED_FILE"
fi

# Read included repos into array
INCLUDED=()
if [ -f "$INCLUDED_FILE" ]; then
  while IFS= read -r line; do
    [[ "$line" =~ ^#.*$ ]] && continue
    [[ -z "$line" ]] && continue
    INCLUDED+=("$line")
  done < "$INCLUDED_FILE"
fi

# Fetch all PUBLIC repositories for adilio
gh repo list adilio --limit 100 --json name,description,updatedAt,url,languages,stargazerCount,visibility | \
  jq -r 'sort_by(.updatedAt) | reverse | .[] | select(.visibility == "PUBLIC") | @json' > /tmp/repos.json

# Clear existing project files (keep _index.md)
rm -rf content/projects/*.md 2>/dev/null || true

# Helper function to generate a project file
generate_project() {
  local repo="$1"
  local NAME=$(echo "$repo" | jq -r '.name')
  local DESCRIPTION=$(echo "$repo" | jq -r '.description // empty')

  if [ -z "$DESCRIPTION" ]; then
    return 1
  fi

  local UPDATED=$(echo "$repo" | jq -r '.updatedAt')
  local URL=$(echo "$repo" | jq -r '.url')
  local LANGUAGES=$(echo "$repo" | jq -r '[.languages[].node.name] | join(", ")')

  # Fetch README for longer description
  LONG_DESC=""
  if README=$(gh api "repos/adilio/$NAME/readme" --jq '.content' 2>/dev/null); then
    LONG_DESC=$(echo "$README" | base64 -d 2>/dev/null | tr '\r' '\n' | \
      awk '/^## / {exit} /^> / {next} /^[^#\[]/ {print}' | \
      tr '\n' ' ' | \
      perl -pe 's/\s+/ /g' | \
      cut -c1-280 | \
      sed 's/ *$//' | sed 's/$/.../')
  fi

  local DATE=$(echo "$UPDATED" | cut -d'T' -f1)

  cat > "content/projects/${NAME}.md" << EOF
---
title: "$NAME"
date: $DATE
description: "$DESCRIPTION"
link: "$URL"
language: "${LANGUAGES:-Unknown}"
---

${LONG_DESC}
EOF

  echo "Generated: $NAME"
  return 0
}

# First, generate any included repos
count=0
if [ ${#INCLUDED[@]} -gt 0 ]; then
  for repo_name in "${INCLUDED[@]}"; do
    [ "$count" -ge "$MAX_PROJECTS" ] && break

    # Check if excluded (exclusion takes precedence)
    for excluded in "${EXCLUDED[@]}"; do
      if [[ "$repo_name" == *"$excluded"* ]]; then
        continue 2
      fi
    done

    # Fetch this specific repo's data
    if repo_data=$(gh repo view adilio/"$repo_name" --json name,description,updatedAt,url,languages,stargazerCount,visibility --jq 'select(.visibility == "PUBLIC")' 2>/dev/null); then
      if [ -n "$repo_data" ]; then
        if generate_project "$repo_data"; then
          count=$((count + 1))
        fi
      fi
    fi
  done
fi

# Then fill the rest with most recently updated
while IFS= read -r repo; do
  [ "$count" -ge "$MAX_PROJECTS" ] && break

  NAME=$(echo "$repo" | jq -r '.name')

  # Skip if already included (check if file exists)
  [ -f "content/projects/${NAME}.md" ] && continue

  # Check if excluded
  for excluded in "${EXCLUDED[@]}"; do
    if [[ "$NAME" == *"$excluded"* ]]; then
      continue 2
    fi
  done

  if generate_project "$repo"; then
    count=$((count + 1))
  fi
done < /tmp/repos.json

rm -f /tmp/repos.json
echo "Synced $count projects from GitHub"
