# Moonbloom theme for Zsh
#
# Github: https://github.com/moonbloom-theme/zsh
# Website: https://moonbloom.teplostan.ski
#
# Copyright 2024-present, All rights reserved
# Code licensed under the MIT license
#
# @author Igor Teplostanski <igor@teplostan.ski>
# @maintainer Igor Teplostanski <igor@teplostan.ski>

# /!\ DON'T TOUCH
_path_prefix_home="~"
_path_prefix_root="/"
_config_name="moonbloom.conf"

_ssh_indicator_text="ssh"
_ssh_indicator_color="blue"
_show_ssh_indicator="true"

_custom_prompt_symbol=">"
_custom_prompt_symbol_super_user="#"
_custom_prompt_symbol_color="magenta"

_current_dir_color="blue"
_tail_path_color="white"

_virtualenv_color="cyan"

_hg_prompt_brackets_color="cyan"
_hg_prompt_branch_color="green"
_hg_prompt_asterisk_color="yellow"

_git_prompt_brackets_color="cyan"
_git_prompt_branch_color="green"
_git_prompt_asterisk_color="yellow"

_right_prompt_color="white"
_show_username="false"
_show_host="false"
_show_remote_server_ip="false"

# SSH Indicator
SSH_INDICATOR_TEXT="${_ssh_indicator_text}"
SSH_INDICATOR_COLOR="${_ssh_indicator_color}"
SHOW_SSH_INDICATOR="${_show_ssh_indicator}"

# Prompt Symbol
CUSTOM_PROMPT_SYMBOL="${_custom_prompt_symbol}"
CUSTOM_PROMPT_SYMBOL_SUPER_USER="${_custom_prompt_symbol_super_user}"
CUSTOM_PROMPT_SYMBOL_COLOR="${_custom_prompt_symbol_color}"

# Path Colors
CURRENT_DIR_COLOR="${_current_dir_color}"
TAIL_PATH_COLOR="${_tail_path_color}"

# Extentions
GIT_PROMPT_BRACKETS_COLOR="${_git_prompt_brackets_color}"
GIT_PROMPT_BRANCH_COLOR="${_git_prompt_branch_color}"
GIT_PROMPT_ASTERISK_COLOR="${_git_prompt_asterisk_color}"

HG_PROMPT_BRACKETS_COLOR="${_hg_prompt_brackets_color}"
HG_PROMPT_BRANCH_COLOR="${_hg_prompt_branch_color}"
HG_PROMPT_ASTERISK_COLOR="${_hg_prompt_asterisk_color}"

VIRTUALENV_COLOR="${_virtualenv_color}"

# Right Prompt
RIGHT_PROMPT_COLOR="${_right_prompt_color}"
SHOW_USERNAME="${_show_username}"
SHOW_HOST="${_show_host}"
SHOW_REMOTE_SERVER_IP="${_show_remote_server_ip}"

# Config
CONFIG_FILE="${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/themes/$_config_name"
if [ -f "$CONFIG_FILE" ]; then
  source "$CONFIG_FILE"
fi

typeset -A valid_colors=(
  black 1 red 1 green 1 yellow 1 blue 1 magenta 1 cyan 1 white 1
  gray 1 grey 1
)

is_valid_color() {
  local color="$1"
  # 8bit
  if [[ -n "${valid_colors[$color]}" ]]; then
    return 0
  fi
  # 16bit
  if [[ "$color" =~ ^[0-9]+$ ]]; then
    if (( color >= 0 && color <= 255 )); then
      return 0
    else
      return 1
    fi
  fi
  # hex
  if [[ "$color" =~ ^#([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$ ]]; then
    return 0
  fi
  return 1
}

is_valid_boolean() {
  local val="$1"
  [[ "$val" == "true" || "$val" == "false" ]]
}

print_warning() {
  local varname=$1
  local fallback=$2
  local val=${(P)varname}
  
  echo "WARNING: In config $CONFIG_FILE"
  echo "$varname=\"$val\" is invalid, fallback to default \"$fallback\""
}

# Universal validation function
validate_config_value() {
  local var_name=$1
  local default_value=$2
  local validator_func=$3
  
  # Input validation
  if [[ -z "$var_name" || -z "$default_value" || -z "$validator_func" ]]; then
    echo "ERROR: validate_config_value() called with missing parameters" >&2
    return 1
  fi
  
  # Check if validator function exists
  if ! command -v "$validator_func" >/dev/null 2>&1; then
    echo "ERROR: Validator function '$validator_func' does not exist" >&2
    return 1
  fi
  
  if ! $validator_func "${(P)var_name}"; then
    print_warning $var_name "$default_value"
    eval "$var_name='$default_value'"
  fi
  
  return 0
}

# Validation
validate_config_value SSH_INDICATOR_COLOR "$_ssh_indicator_color" is_valid_color
validate_config_value CUSTOM_PROMPT_SYMBOL_COLOR "$_custom_prompt_symbol_color" is_valid_color
validate_config_value CURRENT_DIR_COLOR "$_current_dir_color" is_valid_color
validate_config_value TAIL_PATH_COLOR "$_tail_path_color" is_valid_color
validate_config_value GIT_PROMPT_BRACKETS_COLOR "$_git_prompt_brackets_color" is_valid_color
validate_config_value GIT_PROMPT_BRANCH_COLOR "$_git_prompt_branch_color" is_valid_color
validate_config_value GIT_PROMPT_ASTERISK_COLOR "$_git_prompt_asterisk_color" is_valid_color
validate_config_value HG_PROMPT_BRACKETS_COLOR "$_hg_prompt_brackets_color" is_valid_color
validate_config_value HG_PROMPT_BRANCH_COLOR "$_hg_prompt_branch_color" is_valid_color
validate_config_value HG_PROMPT_ASTERISK_COLOR "$_hg_prompt_asterisk_color" is_valid_color
validate_config_value VIRTUALENV_COLOR "$_virtualenv_color" is_valid_color
validate_config_value RIGHT_PROMPT_COLOR "$_right_prompt_color" is_valid_color
validate_config_value SHOW_SSH_INDICATOR "$_show_ssh_indicator" is_valid_boolean
# End Validation

get_connection_prefix() {
  if [[ "$SHOW_SSH_INDICATOR" == "true" ]] && [ -n "$SSH_CONNECTION" ]; then
    echo "%F{${SSH_INDICATOR_COLOR}}${SSH_INDICATOR_TEXT} %f"
  else
    echo ""
  fi
}

# Resolve the current path with special handling for root and home directories
process_path() {
  local full_path="$1"
  
  # Input validation
  if [[ -z "$full_path" ]]; then
    echo "ERROR: process_path() called with empty path" >&2
    echo "$_path_prefix_home"
    return 1
  fi
  
  # Ensure HOME is set
  if [[ -z "$HOME" ]]; then
    echo "ERROR: HOME environment variable is not set" >&2
    echo "$full_path"
    return 1
  fi

  # Root directory: no further processing needed
  if [[ "$full_path" == "/" ]]; then
    echo "$_path_prefix_root"
    return 0
  fi

  # Home directory: show as ~
  if [[ "$full_path" == "$HOME" ]]; then
    echo "$_path_prefix_home"
    return 0
  fi

  # Paths under home: replace $HOME with ~
  if [[ "$full_path" == "$HOME/"* ]]; then
    echo "$_path_prefix_home${full_path#$HOME}"
    return 0
  fi

  # Ensure absolute paths retain the leading slash
  if [[ "$full_path" == /* ]]; then
    echo "$full_path"
    return 0
  fi
  
  # Fallback for relative paths
  echo "$full_path"
  return 0
}

# Apply color highlighting to the processed path
colorize_path() {
  local processed_path="$1"
  
  # Input validation
  if [[ -z "$processed_path" ]]; then
    echo "ERROR: colorize_path() called with empty path" >&2
    echo ""
    return 1
  fi
  
  # Validate color variables
  if [[ -z "${CURRENT_DIR_COLOR}" || -z "${TAIL_PATH_COLOR}" ]]; then
    echo "ERROR: Color variables are not set" >&2
    echo "$processed_path"
    return 1
  fi

  # Split the path into parent (tail) and current directory
  local current_dir="${processed_path##*/}"
  local parent_path="${processed_path%/*}"

  # Special cases: root and home directories
  if [[ "$processed_path" == "$_path_prefix_root" ]]; then
    echo "%F{$CURRENT_DIR_COLOR}/%f"
    return 0
  elif [[ "$processed_path" == "$_path_prefix_home" ]]; then
    echo "%F{$CURRENT_DIR_COLOR}$_path_prefix_home%f"
    return 0
  else
    # General case: parent is $TAIL_PATH_COLOR, current directory is $CURRENT_DIR_COLOR
    echo "%F{$TAIL_PATH_COLOR}${parent_path}/%F{$CURRENT_DIR_COLOR}${current_dir}%f"
    return 0
  fi
}

# Generate the custom prompt path with colors and prepend ssh if needed
custom_prompt_path() {
  # Validate PWD is set
  if [[ -z "$PWD" ]]; then
    echo "ERROR: PWD environment variable is not set" >&2
    echo ""
    return 1
  fi
  
  local processed_path
  local connection_prefix
  local colored_path
  
  # Process path with error handling
  if ! processed_path="$(process_path "$PWD")"; then
    echo "ERROR: Failed to process path" >&2
    echo ""
    return 1
  fi
  
  # Get connection prefix
  connection_prefix="$(get_connection_prefix)"
  
  # Colorize path with error handling
  if ! colored_path="$(colorize_path "$processed_path")"; then
    echo "ERROR: Failed to colorize path" >&2
    echo "$connection_prefix$processed_path"
    return 1
  fi
  
  echo "$connection_prefix$colored_path"
  return 0
}

# Get SSH connection IP address
get_ssh_ip() {
  # Validate SSH_CONNECTION format
  if [[ -n "$SSH_CONNECTION" ]]; then
    local ip="${SSH_CONNECTION[(w)3]}"
    
    # Validate IP is not empty and looks like an IP address
    if [[ -n "$ip" && "$ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
      echo "$ip"
      return 0
    else
      echo "ERROR: Invalid SSH_CONNECTION format or IP address" >&2
      echo ""
      return 1
    fi
  else
    echo ""
    return 0
  fi
}

# Build right prompt components
build_rprompt_components() {
  # Validate configuration variables
  if [[ -z "${SHOW_USERNAME}" || -z "${SHOW_HOST}" || -z "${SHOW_REMOTE_SERVER_IP}" ]]; then
    echo "ERROR: Required configuration variables are not set" >&2
    echo ""
    return 1
  fi
  
  local components=()
  local username="%n"
  local host="%m"
  local ip=""
  
  # Get IP if SSH connection exists and IP display is enabled
  if [[ "${SHOW_REMOTE_SERVER_IP}" == "true" ]]; then
    if ! ip="$(get_ssh_ip)"; then
      # Log error but continue without IP
      echo "WARNING: Failed to get SSH IP, continuing without it" >&2
      ip=""
    fi
  fi
  
  # Build user@host part if both are enabled
  if [[ "${SHOW_USERNAME}" == "true" && "${SHOW_HOST}" == "true" ]]; then
    components+=("${username}@${host}")
  else
    # Add individual components if only one is enabled
    [[ "${SHOW_USERNAME}" == "true" ]] && components+=("$username")
    [[ "${SHOW_HOST}" == "true" ]] && components+=("$host")
  fi
  
  # Add IP if available and enabled
  if [[ -n "$ip" ]]; then
    components+=("$ip")
  fi
  
  echo "${(j: :)components}"
  return 0
}

# Build the right prompt string
local rprompt_str
if ! rprompt_str="$(build_rprompt_components)"; then
  echo "ERROR: Failed to build right prompt components" >&2
  rprompt_str=""
fi

PS1="\$(custom_prompt_path)\$(git_prompt_info) %F{${CUSTOM_PROMPT_SYMBOL_COLOR}}%(!.${CUSTOM_PROMPT_SYMBOL_SUPER_USER}.${CUSTOM_PROMPT_SYMBOL})%f "

# Secondary prompt
PS2="%F{red}\\ %f"

# Right prompt: return code and virtualenv
RPS1="%(?..%F{red}%? ↵%f)"
if (( $+functions[virtualenv_prompt_info] )); then
  RPS1+='$(virtualenv_prompt_info)'
fi

RPS1=" %F{$RIGHT_PROMPT_COLOR}${rprompt_str}%{$reset_color%}"

# Git settings
ZSH_THEME_GIT_PROMPT_PREFIX=" %B%F{${GIT_PROMPT_BRACKETS_COLOR}}[%b%F{${GIT_PROMPT_BRANCH_COLOR}}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="%B%F{${GIT_PROMPT_ASTERISK_COLOR}}%b*%f"
ZSH_THEME_GIT_PROMPT_SUFFIX="%B%F{${GIT_PROMPT_BRACKETS_COLOR}}]%b%f"

# Hg settings
ZSH_THEME_HG_PROMPT_PREFIX=" %B%F{${HG_PROMPT_BRACKETS_COLOR}}[%b%F{${HG_PROMPT_BRANCH_COLOR}}"
ZSH_THEME_HG_PROMPT_CLEAN=""
ZSH_THEME_HG_PROMPT_DIRTY="%B%F{${HG_PROMPT_ASTERISK_COLOR}}%b*%f"
ZSH_THEME_HG_PROMPT_SUFFIX="%B%F{${HG_PROMPT_BRACKETS_COLOR}}]%b%f"

# Virtualenv settings
ZSH_THEME_VIRTUALENV_PREFIX=" %F{${VIRTUALENV_COLOR}}{"
ZSH_THEME_VIRTUALENV_SUFFIX="}%f"
