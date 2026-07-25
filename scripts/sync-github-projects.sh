#!/bin/bash

set -e

EXCLUDED_FILE=".github/excluded-repos.txt"
MAX_PROJECTS=24
GENERATED_DIR="content/projects/generated"

# Emit a value as a double-quoted YAML scalar with quotes/backslashes escaped.
# YAML is a JSON superset, so jq's JSON string encoding is valid frontmatter and
# keeps a stray " in a repo description from breaking the Hugo build.
yaml_str() {
  jq -n --arg s "$1" '$s'
}

# Read excluded repos into array
EXCLUDED=()
if [ -f "$EXCLUDED_FILE" ]; then
  while IFS= read -r line; do
    [[ "$line" =~ ^#.*$ ]] && continue
    [[ -z "$line" ]] && continue
    EXCLUDED+=("$line")
  done < "$EXCLUDED_FILE"
fi

# Fetch all PUBLIC repositories for adilio
gh repo list adilio --limit 100 --json name,description,updatedAt,url,languages,visibility | \
  jq -r 'sort_by(.updatedAt) | reverse | .[] | select(.visibility == "PUBLIC") | @json' > /tmp/repos.json

# Refresh only machine-generated entries. Curated project stories in
# content/projects/ are intentionally preserved.
mkdir -p "$GENERATED_DIR"
find "$GENERATED_DIR" -maxdepth 1 -type f -name '*.md' -delete

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
      tr -s '[:space:]' ' ' | \
      cut -c1-280 | \
      sed 's/ *$//' | sed 's/$/.../')
  fi

  local DATE=$(echo "$UPDATED" | cut -d'T' -f1)

  # A curated page with the same slug takes precedence over the generated
  # repository summary and should not be duplicated in the catalog.
  if [ -f "content/projects/${NAME}.md" ] || [ -f "content/projects/${NAME,,}.md" ]; then
    echo "Curated: $NAME"
    return 2
  fi

  cat > "${GENERATED_DIR}/${NAME}.md" << EOF
---
title: $(yaml_str "$NAME")
date: $DATE
description: $(yaml_str "$DESCRIPTION")
repo: $(yaml_str "$URL")
language: $(yaml_str "${LANGUAGES:-Unknown}")
project_kind: "open-source"
project_type: "Open source"
order: 1000
generated: true
---

${LONG_DESC}
EOF

  echo "Generated: $NAME"
  return 0
}

# Generate the most recently updated repos, up to MAX_PROJECTS
count=0
while IFS= read -r repo; do
  [ "$count" -ge "$MAX_PROJECTS" ] && break

  NAME=$(echo "$repo" | jq -r '.name')

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
