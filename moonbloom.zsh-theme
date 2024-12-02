# Moonbloom Theme v1.0.0
#
# Github: https://github.com/moonbloom-theme/zsh
# Website: https://moonbloom.teplostanski.dev
#
# Copyright 2024, All rights reserved
# Code licensed under the MIT license
#
# @author Igor Teplostanski <igor@teplostanski.dev>
# @maintainer Igor Teplostanski <igor@teplostanski.dev>

# Resolve the current path with special handling for root and home directories
process_path() {
  local full_path="$1"

  # Root directory: no further processing needed
  if [[ "$full_path" == "/" ]]; then
    echo "/"
    return
  fi

  # Home directory: show as ~
  if [[ "$full_path" == "$HOME" ]]; then
    echo "~"
    return
  fi

  # Paths under home: replace $HOME with ~
  if [[ "$full_path" == "$HOME/"* ]]; then
    echo "~${full_path#$HOME}"
    return
  fi

  # Ensure absolute paths retain the leading slash
  if [[ "$full_path" == /* ]]; then
    echo "$full_path"
    return
  fi
}

# Apply color highlighting to the processed path
colorize_path() {
  local processed_path="$1"

  # Split the path into parent (tail) and current directory
  local current_dir="${processed_path##*/}"
  local parent_path="${processed_path%/*}"

  # Special cases: root and home directories
  if [[ "$processed_path" == "/" ]]; then
    echo "%F{blue}/%f"
  elif [[ "$processed_path" == "~" ]]; then
    echo "%F{blue}~%f"
  else
    # General case: parent is white, current directory is blue
    echo "%F{white}${parent_path}/%F{blue}${current_dir}%f"
  fi
}

# Generate the custom prompt path with colors
custom_prompt_path() {
  local processed_path
  processed_path="$(process_path "$PWD")"
  colorize_path "$processed_path"
}

PS1='$(custom_prompt_path)$(git_prompt_info) %F{magenta}%(!.#.>)%f '

# Secondary prompt
PS2="%F{red}\\ %f"

# Right prompt: return code and virtualenv
RPS1="%(?..%F{red}%? ↵%f)"
if (( $+functions[virtualenv_prompt_info] )); then
  RPS1+='$(virtualenv_prompt_info)'
fi

# Git settings
ZSH_THEME_GIT_PROMPT_PREFIX=" %B%F{cyan}[%b%F{green}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="%B%F{yellow}%b*%f"
ZSH_THEME_GIT_PROMPT_SUFFIX="%B%F{cyan}]%b%f"

# Hg settings
ZSH_THEME_HG_PROMPT_PREFIX=" %B%F{cyan}[%b%F{green}"
ZSH_THEME_HG_PROMPT_CLEAN=""
ZSH_THEME_HG_PROMPT_DIRTY="%B%F{yellow}%b*%f"
ZSH_THEME_HG_PROMPT_SUFFIX="%B%F{cyan}]%b%f"

# Virtualenv settings
ZSH_THEME_VIRTUALENV_PREFIX=" %F{cyan}{"
ZSH_THEME_VIRTUALENV_SUFFIX="}%f"
