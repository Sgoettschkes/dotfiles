# File managed by Sgoettschkes/dotfiles
# Do not change

# Unalias g if it exists (from oh-my-zsh git plugin)
unalias g 2>/dev/null

# Git wrapper function to suggest aliases
g() {
    # Get the git command arguments
    local cmd_args="$*"
    
    # Dynamically load git aliases from gitconfig and check for matches
    local found_alias=""
    local found_expansion=""
    
    # Parse git config to get all aliases
    while IFS=' ' read -r key value; do
        # Extract alias name from the key (format: alias.name)
        local alias_name="${key#alias.}"
        # The value is everything after the first space
        
        # Check if the command matches this alias expansion
        if [[ "$cmd_args" == "$value"* ]]; then
            found_alias="$alias_name"
            found_expansion="$value"
            break
        fi
        
        # Also check if the base command matches (e.g., "status" matches "status --short")
        local base_cmd="${cmd_args%% *}"
        local alias_base="${value%% *}"
        if [[ "$base_cmd" == "$alias_base" ]] && [[ "$value" != "$base_cmd" ]]; then
            found_alias="$alias_name"
            found_expansion="$value"
            # Don't break here, keep looking for exact matches
        fi
    done < <(git config --get-regexp '^alias\.' 2>/dev/null)
    
    # Show suggestion if found
    if [[ -n "$found_alias" ]]; then
        echo "💡 Tip: You can use 'g $found_alias' for 'g $found_expansion'" >&2
    fi
    
    # Execute the actual git command
    command git "$@"
}