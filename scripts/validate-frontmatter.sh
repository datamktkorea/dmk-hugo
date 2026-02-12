#!/usr/bin/env bash
# Validate author and tags in post front matter against allowed values.
# Usage: bash scripts/validate-frontmatter.sh

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
AUTHORS_FILE="$REPO_ROOT/data/authors.yml"
TAGS_FILE="$REPO_ROOT/data/tags.yml"

errors=0

# Load allowed authors into an array
allowed_authors=()
while IFS= read -r line; do
  # Strip leading "- " from YAML list items and trim whitespace
  value="${line#- }"
  value="${value#"${value%%[![:space:]]*}"}"
  value="${value%"${value##*[![:space:]]}"}"
  [[ -n "$value" ]] && allowed_authors+=("$value")
done < "$AUTHORS_FILE"

# Load allowed tags into an array
allowed_tags=()
while IFS= read -r line; do
  value="${line#- }"
  value="${value#"${value%%[![:space:]]*}"}"
  value="${value%"${value##*[![:space:]]}"}"
  [[ -n "$value" ]] && allowed_tags+=("$value")
done < "$TAGS_FILE"

# Check if a value exists in an array
contains() {
  local needle="$1"
  shift
  for item in "$@"; do
    [[ "$item" == "$needle" ]] && return 0
  done
  return 1
}

# Iterate over all posts
for post in "$REPO_ROOT"/content/posts/*/index.md; do
  [[ -f "$post" ]] || continue
  rel_path="${post#"$REPO_ROOT"/}"

  # Extract TOML front matter block (between +++ delimiters)
  frontmatter=$(sed -n '/^+++$/,/^+++$/p' "$post" | sed '1d;$d')

  # Extract author values: author = ['Name1', 'Name2']
  author_line=$(echo "$frontmatter" | grep -E '^author\s*=' || true)
  if [[ -n "$author_line" ]]; then
    # Parse values inside brackets
    authors_raw=$(echo "$author_line" | sed "s/.*\[//;s/\].*//")
    IFS=',' read -ra author_entries <<< "$authors_raw"
    for entry in "${author_entries[@]}"; do
      # Strip quotes and whitespace
      author=$(echo "$entry" | sed "s/^[[:space:]]*['\"]//;s/['\"][[:space:]]*$//")
      [[ -z "$author" ]] && continue
      if ! contains "$author" "${allowed_authors[@]}"; then
        echo "ERROR: $rel_path"
        echo "  Invalid author: '$author'"
        echo "  Allowed authors: ${allowed_authors[*]}"
        echo ""
        errors=$((errors + 1))
      fi
    done
  fi

  # Extract tag values: tags = ['Tag1', 'Tag2']
  tags_line=$(echo "$frontmatter" | grep -E '^tags\s*=' || true)
  if [[ -n "$tags_line" ]]; then
    tags_raw=$(echo "$tags_line" | sed "s/.*\[//;s/\].*//")
    IFS=',' read -ra tag_entries <<< "$tags_raw"
    for entry in "${tag_entries[@]}"; do
      tag=$(echo "$entry" | sed "s/^[[:space:]]*['\"]//;s/['\"][[:space:]]*$//")
      [[ -z "$tag" ]] && continue
      if ! contains "$tag" "${allowed_tags[@]}"; then
        echo "ERROR: $rel_path"
        echo "  Invalid tag: '$tag'"
        echo "  Allowed tags: ${allowed_tags[*]}"
        echo ""
        errors=$((errors + 1))
      fi
    done
  fi
done

if [[ $errors -gt 0 ]]; then
  echo "Validation failed: $errors error(s) found."
  exit 1
fi

echo "Front matter validation passed."
exit 0
