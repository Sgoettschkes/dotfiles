# File managed by Sgoettschkes/dotfiles  
# Do not change

# Zsh command wrapper function to suggest aliases
preexec() {
    # Get the command that's about to be executed
    local cmd="$1"
    local first_word="${cmd%% *}"
    
    # Load aliases dynamically from aliases.zsh (simplified approach)
    local -A zsh_alias_suggestions
    
    # Use the actual zsh aliases that are currently loaded
    for alias_name in ${(k)aliases}; do
        local full_command="${aliases[$alias_name]}"
        zsh_alias_suggestions[$full_command]="$alias_name"
    done
    
    # Check for single-word command matches
    if [[ -n "${zsh_alias_suggestions[$first_word]}" ]]; then
        echo "💡 Tip: You can use '${zsh_alias_suggestions[$first_word]}' instead of '$first_word'" >&2
        return
    fi
    
    # Check for multi-word command matches  
    for full_cmd alias_name in ${(kv)zsh_alias_suggestions}; do
        if [[ "$cmd" == "$full_cmd"* ]]; then
            echo "💡 Tip: You can use '$alias_name' instead of '$full_cmd'" >&2
            return
        fi
    done
}