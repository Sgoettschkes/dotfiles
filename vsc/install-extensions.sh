#!/bin/bash

# Generate package list using code --list-extensions
pkglist=(
# Enabled plugins
GitHub.copilot
GitHub.copilot-chat
zhuangtongfa.material-theme
alefragnani.project-manager
# Disabled plugins
JakeBecker.elixir-ls
eamodio.gitlens
phoenixframework.phoenix
bmewburn.vscode-intelephense-client
bradlc.vscode-tailwindcss
whatwedo.twig
)

for i in ${pkglist[@]}; do
  code --install-extension $i
done
