#!/bin/bash

# Find the directory where this script is located. This is a robust way
# to make sure we can always find the helper scripts.
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPT_PATH="$CURRENT_DIR/scripts/open_from_claude.sh"

# Helper function to get a tmux option or return a default value.
get_tmux_option() {
  local option_name="$1"
  local default_value="$2"
  local option_value=$(tmux show-options -gqv "$option_name")
  if [ -z "$option_value" ]; then
    echo "$default_value"
  else
    echo "$option_value"
  fi
}

# Read the user's custom keybinding from .tmux.conf, with 'J' as the default.
KEY_BINDING=$(get_tmux_option "@claude-opener-key" "J")

# Bind the key to run our script.
tmux bind-key "$KEY_BINDING" "run-shell 'bash -c \"$SCRIPT_PATH\"'"
