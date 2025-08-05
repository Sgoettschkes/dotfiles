# File managed by Sgoettschkes/dotfiles
# Do not change

SPACESHIP_TIME_SHOW=true
SPACESHIP_TIME_FORMAT='%D %*'

SPACESHIP_EXEC_TIME_ELAPSED=10

SPACESHIP_BATTERY_SHOW=false

SPACESHIP_EXIT_CODE_SHOW=true

SPACESHIP_GIT_BRANCH_MAX_LENGTH=20

# Custom git branch function to truncate long branch names
spaceship_git_branch_truncated() {
  [[ $SPACESHIP_GIT_BRANCH_SHOW == false ]] && return

  vcs_info

  local git_current_branch="$vcs_info_msg_0_"
  [[ -z "$git_current_branch" ]] && return

  git_current_branch="${git_current_branch#heads/}"
  git_current_branch="${git_current_branch/.../}"

  # Truncate branch name if it exceeds max length
  local max_length="${SPACESHIP_GIT_BRANCH_MAX_LENGTH:-50}"
  if [[ ${#git_current_branch} -gt $max_length ]]; then
    git_current_branch="${git_current_branch:0:$((max_length-3))}..."
  fi

  spaceship::section \
    --color "$SPACESHIP_GIT_BRANCH_COLOR" \
    "$SPACESHIP_GIT_BRANCH_PREFIX$git_current_branch$SPACESHIP_GIT_BRANCH_SUFFIX"
}

# Override the git_branch function after spaceship loads all sections
# This ensures our custom function isn't overwritten by the built-in one
autoload -Uz add-zsh-hook
override_git_branch() {
  functions[spaceship_git_branch]=$functions[spaceship_git_branch_truncated]
}
add-zsh-hook precmd override_git_branch

SPACESHIP_DIR_MAX_LENGTH=30

# Custom directory function with smart truncation
spaceship_dir_truncated() {
  [[ $SPACESHIP_DIR_SHOW == false ]] && return

  local dir trunc_prefix

  # Original logic for git repo handling
  if [[ $SPACESHIP_DIR_TRUNC_REPO == true ]] && spaceship::is_git; then
    local git_root=$(git rev-parse --show-toplevel)

    if (cygpath --version) >/dev/null 2>/dev/null; then
      git_root=$(cygpath -u $git_root)
    fi

    if [[ $git_root:h == / ]]; then
      trunc_prefix=/
    else
      trunc_prefix=$SPACESHIP_DIR_TRUNC_PREFIX
    fi

    dir="$trunc_prefix$git_root:t${${PWD:A}#$~~git_root}"
  else
    if [[ SPACESHIP_DIR_TRUNC -gt 0 ]]; then
      trunc_prefix="%($((SPACESHIP_DIR_TRUNC + 1))~|$SPACESHIP_DIR_TRUNC_PREFIX|)"
    fi

    dir="$trunc_prefix%${SPACESHIP_DIR_TRUNC}~"
  fi

  # Smart truncation based on character length
  local max_length="${SPACESHIP_DIR_MAX_LENGTH:-40}"
  local dir_expanded="${(%)dir}"  # Expand prompt sequences to get actual string

  if [[ ${#dir_expanded} -gt $max_length ]]; then
    # Split the path into components
    local -a path_parts
    path_parts=("${(@s:/:)dir_expanded}")

    # If we have more than 2 parts, keep first and last
    if [[ ${#path_parts[@]} -gt 2 ]]; then
      local first_part="${path_parts[1]}"
      local last_part="${path_parts[-1]}"

      # Handle case where first part is empty (absolute path)
      if [[ -z "$first_part" && ${#path_parts[@]} -gt 3 ]]; then
        dir="/${path_parts[2]}/.../${last_part}"
      elif [[ -n "$first_part" ]]; then
        dir="${first_part}/.../${last_part}"
      else
        # Fallback to original if edge case
        dir="$dir_expanded"
      fi
    fi
  fi

  local suffix="$SPACESHIP_DIR_SUFFIX"

  if [[ ! -w . ]]; then
    suffix="%F{$SPACESHIP_DIR_LOCK_COLOR}${SPACESHIP_DIR_LOCK_SYMBOL}%f${SPACESHIP_DIR_SUFFIX}"
  fi

  spaceship::section \
    --color "$SPACESHIP_DIR_COLOR" \
    --prefix "$SPACESHIP_DIR_PREFIX" \
    --suffix "$suffix" \
    "$dir"
}

# Override the dir function after spaceship loads
override_dir() {
  functions[spaceship_dir]=$functions[spaceship_dir_truncated]
}
add-zsh-hook precmd override_dir
