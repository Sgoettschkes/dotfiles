#!/bin/bash

# Generate package list using code --list-extensions
pkglist=(
JakeBecker.elixir-ls
eamodio.gitlens
josecfreittas.livebook
shd101wyy.markdown-preview-enhanced
zhuangtongfa.material-theme
phoenixframework.phoenix
zobo.php-intellisense
alefragnani.project-manager
bradlc.vscode-tailwindcss
whatwedo.twig
)

for i in ${pkglist[@]}; do
  code --install-extension $i
done
