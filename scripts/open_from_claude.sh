#!/bin/bash

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

# --- CONFIGURATION FROM TMUX OPTIONS ---
# Read settings from the user's .tmux.conf file, providing sensible defaults.
CLAUDE_OUTPUT_PATTERN=$(get_tmux_option "@claude-output-pattern" "Update(")
CLAUDE_PROCESS_NAME=$(get_tmux_option "@claude-process-name" "claude")
NVIM_PROCESS_NAME=$(get_tmux_option "@nvim-process-name" "nvim")

# 1. Find the required panes.
CLAUDE_PANE=$(tmux list-panes -F '#{pane_id} #{pane_current_command}' | grep "$CLAUDE_PROCESS_NAME" | tail -n 1 | cut -d' ' -f1)
NVIM_PANE=$(tmux list-panes -F '#{pane_id} #{pane_current_command}' | grep "$NVIM_PROCESS_NAME" | head -n 1 | cut -d' ' -f1)

if [ -z "$CLAUDE_PANE" ]; then
    tmux display-message "❌ No '$CLAUDE_PROCESS_NAME' pane found. Set with @claude-process-name."
    exit 0
fi
if [ -z "$NVIM_PANE" ]; then
    tmux display-message "❌ No '$NVIM_PROCESS_NAME' pane found. Set with @nvim-process-name."
    exit 0
fi

# 2. Capture the Claude pane's text and extract the last mentioned filename.
LATEST_FILE=$(tmux capture-pane -p -S -1000000 -t "$CLAUDE_PANE" | grep "$CLAUDE_OUTPUT_PATTERN" | tail -n 1 | awk -F'[()]' '{print $2}')

if [ -z "$LATEST_FILE" ]; then
    tmux display-message "❌ No file found with pattern '$CLAUDE_OUTPUT_PATTERN'. Set with @claude-output-pattern."
    exit 0
fi

# 3. Send keys to the Neovim pane to open the file.
COMMAND_TO_SEND=":edit! $LATEST_FILE"
tmux send-keys -t "$NVIM_PANE" "$COMMAND_TO_SEND" C-m
tmux display-message "✅ Opened: $LATEST_FILE"
