# File managed by Sgoettschkes/dotfiles
# Do not change

SPACESHIP_TIME_SHOW=true
SPACESHIP_TIME_FORMAT='%D %*'

SPACESHIP_EXEC_TIME_ELAPSED=10

SPACESHIP_BATTERY_SHOW=false

SPACESHIP_EXIT_CODE_SHOW=true

# Git branch truncation
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
