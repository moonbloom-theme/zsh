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

# Function to colorize the path and replace home directory with ~
custom_prompt_path() {
  local full_path="$PWD"

  # Check if the path is the home directory
  if [[ "$full_path" == "$HOME" ]]; then
    echo "%F{blue}~%f"
    return
  fi

  # Replace the home directory with ~ for all paths except the root home directory
  local home_replaced="$full_path"
  if [[ "$full_path" == $HOME/* ]]; then
    home_replaced="~${full_path#$HOME}"
  fi

  # Split the path into base name and parent directory
  local base_name="${home_replaced##*/}"  # Last part of the path (current directory)
  local parent_path="${home_replaced%/*}"  # Everything before the last part of the path

  # If the parent path is empty, only show the base name
  if [[ -z "$parent_path" ]]; then
    echo "%F{blue}${base_name}%f"
  else
    # Show the full path with the home directory replaced by ~
    echo "%F{white}${parent_path}/%F{blue}${base_name}%f"
  fi
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
