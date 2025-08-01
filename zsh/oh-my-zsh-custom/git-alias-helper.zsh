# File managed by Sgoettschkes/dotfiles
# Do not change

# Unalias g if it exists (from oh-my-zsh git plugin)
unalias g 2>/dev/null

# Git wrapper function to suggest aliases
g() {
    # Define mappings of full commands to their aliases
    local -A git_alias_suggestions=(
        "add ." "aa"
        "add" "a"
        "status --short" "st"
        "status" "st"
        "diff" "d"
        "commit" "ci"
        "commit --message" "cim"
        "commit --no-verify --message" "cinvm"
        "checkout" "co"
        "checkout -b" "cob"
        "branch" "br"
        "merge" "me"
        "mergetool" "met"
        "stash" "s"
        "push -u origin" "pu"
        "push -u origin --no-verify" "punv"
        "pull --all --prune --tags --verbose" "pa"
        "reset HEAD" "re"
        "reset HEAD~1 --mixed" "undo"
    )
    
    # Get the git command arguments
    local cmd_args="$*"
    
    # Check if there's a suggestion for this command
    for full_cmd alias_name in ${(kv)git_alias_suggestions}; do
        if [[ "$cmd_args" == "$full_cmd"* ]]; then
            echo "💡 Tip: You can use 'g $alias_name' instead of 'g $full_cmd'" >&2
            break
        fi
    done
    
    # Execute the actual git command
    command git "$@"
}