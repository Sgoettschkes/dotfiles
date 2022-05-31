#!/bin/bash

# Generate package list using code --list-extensions
pkglist=(
alefragnani.project-manager
JakeBecker.elixir-ls
josecfreittas.livebook
phoenixframework.phoenix
shd101wyy.markdown-preview-enhanced
zhuangtongfa.material-theme
)

for i in ${pkglist[@]}; do
  code --install-extension $i
done