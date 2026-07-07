# File managed by Sgoettschkes/dotfiles
# Do not change

SPACESHIP_TIME_SHOW=true
SPACESHIP_TIME_FORMAT='%*'

SPACESHIP_DIR_MAX_LENGTH=30

SPACESHIP_GIT_BRANCH_MAX_LENGTH=20

# Plain arrows read easier than the default ⇡⇣⇕
SPACESHIP_GIT_STATUS_AHEAD='↑'
SPACESHIP_GIT_STATUS_BEHIND='↓'
SPACESHIP_GIT_STATUS_DIVERGED='↕'

SPACESHIP_NODE_SHOW=true
SPACESHIP_BUN_SHOW=false
SPACESHIP_PYTHON_SHOW=false
SPACESHIP_RUST_SHOW=false
SPACESHIP_GOLANG_SHOW=false
SPACESHIP_PERL_SHOW=false
SPACESHIP_PHP_SHOW=false
SPACESHIP_RUBY_SHOW=false
SPACESHIP_ELIXIR_SHOW=true
SPACESHIP_ERLANG_SHOW=false
SPACESHIP_ELM_SHOW=false
SPACESHIP_HASKELL_SHOW=false
SPACESHIP_LUA_SHOW=true
SPACESHIP_OCAML_SHOW=false
SPACESHIP_ZIG_SHOW=false
SPACESHIP_GLEAM_SHOW=false
SPACESHIP_TERRAFORM_SHOW=false
SPACESHIP_DOCKER_SHOW=false
# gcloud is only installed for gws auth; the active project is noise
SPACESHIP_GCLOUD_SHOW=false

# Only surface duration for slow commands (mix compile/test, migrations)
SPACESHIP_EXEC_TIME_SHOW=true
SPACESHIP_EXEC_TIME_ELAPSED=5

SPACESHIP_BATTERY_SHOW=false

SPACESHIP_EXIT_CODE_SHOW=true

# Move the timestamp to the right prompt to keep the left side focused on
# dir + git. Sourced after Spaceship sets the default orders, so the left
# order already contains `time` and can be filtered here.
SPACESHIP_PROMPT_ORDER=(${SPACESHIP_PROMPT_ORDER:#time})
SPACESHIP_RPROMPT_ORDER=(time)

# ============================================================================
# CUSTOM TRUNCATION FUNCTIONS
# ============================================================================

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
      local truncation_indicator="${SPACESHIP_DIR_TRUNC_PREFIX:-}"
      if [[ -z "$first_part" && ${#path_parts[@]} -gt 3 ]]; then
        dir="${truncation_indicator}/${path_parts[2]}/.../${last_part}"
      elif [[ -n "$first_part" ]]; then
        dir="${truncation_indicator}${first_part}/.../${last_part}"
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

# Custom git status that separates indicators with spaces for readability.
# The stock section concatenates symbols (e.g. [↑$!?]); joining an array
# with spaces is the only way to avoid a stray space at one bracket edge.
spaceship_git_status_spaced() {
  [[ $SPACESHIP_GIT_STATUS_SHOW == false ]] && return

  spaceship::is_git || return

  local INDEX git_branch="$vcs_info_msg_0_"
  local -a parts
  INDEX=$(command git status --porcelain -b 2> /dev/null)

  # Leftmost: divergence from upstream
  local ahead=$(command git rev-list --count ${git_branch}@{upstream}..HEAD 2>/dev/null)
  local behind=$(command git rev-list --count HEAD..${git_branch}@{upstream} 2>/dev/null)
  if (( ${ahead:-0} )) && (( ${behind:-0} )); then
    parts+=("$SPACESHIP_GIT_STATUS_DIVERGED")
  elif (( ${ahead:-0} )); then
    parts+=("$SPACESHIP_GIT_STATUS_AHEAD")
  elif (( ${behind:-0} )); then
    parts+=("$SPACESHIP_GIT_STATUS_BEHIND")
  fi

  echo "$INDEX" | command grep -E '^(U[UDA]|AA|DD|[DA]U) ' &> /dev/null \
    && parts+=("$SPACESHIP_GIT_STATUS_UNMERGED")

  # refs/stash is a single global stack, so match only entries whose
  # recorded branch (WIP on <branch>: / On <branch>:) is the current one.
  # Resolve the branch directly: vcs_info_msg_0_ is empty in the async worker.
  local stash_branch=$(command git rev-parse --abbrev-ref HEAD 2> /dev/null)
  command git stash list 2> /dev/null \
    | command grep -qE "^stash@\{[0-9]+\}: (WIP on|On) ${stash_branch}: " \
    && parts+=("$SPACESHIP_GIT_STATUS_STASHED")

  echo "$INDEX" | command grep -E '^([MARCDU ]D|D[ UM]) ' &> /dev/null \
    && parts+=("$SPACESHIP_GIT_STATUS_DELETED")

  echo "$INDEX" | command grep -E '^R[ MD] ' &> /dev/null \
    && parts+=("$SPACESHIP_GIT_STATUS_RENAMED")

  echo "$INDEX" | command grep -E '^[ MARC]M ' &> /dev/null \
    && parts+=("$SPACESHIP_GIT_STATUS_MODIFIED")

  echo "$INDEX" | command grep -E '^(A[ MDAU]|M[ MD]|UA) ' &> /dev/null \
    && parts+=("$SPACESHIP_GIT_STATUS_ADDED")

  # Rightmost: untracked
  echo "$INDEX" | command grep -E '^\?\? ' &> /dev/null \
    && parts+=("$SPACESHIP_GIT_STATUS_UNTRACKED")

  [[ ${#parts[@]} -eq 0 ]] && return

  spaceship::section \
    --color "$SPACESHIP_GIT_STATUS_COLOR" \
    "$SPACESHIP_GIT_STATUS_PREFIX${(j: :)parts}$SPACESHIP_GIT_STATUS_SUFFIX"
}

# ============================================================================
# HOOK SETUP - Override functions after spaceship loads
# ============================================================================

autoload -Uz add-zsh-hook

# Combined override function for all customizations
spaceship_apply_customizations() {
  functions[spaceship_git_branch]=$functions[spaceship_git_branch_truncated]
  functions[spaceship_dir]=$functions[spaceship_dir_truncated]
  functions[spaceship_git_status]=$functions[spaceship_git_status_spaced]
}

# Apply customizations on each prompt
add-zsh-hook precmd spaceship_apply_customizations
