#!/bin/bash

global_versions_file="$HOME/.tool-versions"

for plugin in $(asdf plugin list); do
  echo "Checking $plugin..."

  # Get version from global .tool-versions file
  global_version=$(grep "^$plugin " "$global_versions_file" 2>/dev/null | cut -d' ' -f2 || echo "none")

  # List all installed versions
  for version in $(asdf list $plugin 2>/dev/null); do
    # Remove the * and any leading/trailing whitespace
    clean_version=$(echo "$version" | sed 's/^\*\s*//g' | xargs)

    if [[ "$clean_version" != "$global_version" ]]; then
      echo "Removing unused $plugin $clean_version"
      asdf uninstall $plugin "$clean_version"
    fi
  done
done
