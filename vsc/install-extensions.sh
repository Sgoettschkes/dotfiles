#!/bin/bash

# Generate package list using code --list-extensions
pkglist=(
JakeBecker.elixir-ls
eamodio.gitlens
shd101wyy.markdown-preview-enhanced
mjmlio.vscode-mjml
zhuangtongfa.material-theme
phoenixframework.phoenix
bmewburn.vscode-intelephense-client
alefragnani.project-manager
bradlc.vscode-tailwindcss
whatwedo.twig
)

for i in ${pkglist[@]}; do
  code --install-extension $i
done
