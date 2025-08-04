# Tmux Claude Opener

A tmux plugin to instantly open the file modified by an AI coding assistant (like Claude Code) in your Neovim pane.

It works by capturing the text from your AI assistant's pane, finding the name of the file it just updated, and sending a command to Neovim to open it.

## Prerequisites

- `tmux`
- An AI coding assistant that runs in a terminal and prints the name of the file it modifies.
- `neovim` (or `vim`) running in another pane.

## Installation with TPM

1.  Add the plugin to your list of TPM plugins in `.tmux.conf`:

    ```tmux
    set -g @plugin 'your-github-username/tmux-claude-opener'
    ```

2.  Press `prefix + I` to fetch the plugin and source it.

## Configuration

You must configure the plugin in your `.tmux.conf` so it can find your AI assistant's output. Place these lines *before* the `run '~/.tmux/plugins/tpm/tpm'` line.

```tmux
# The unique text your AI tool prints right before the filename.
# This example is for a tool that prints "Update(path/to/file.js)".
set -g @claude-output-pattern "Update("

# The process name of your AI assistant's command.
set -g @claude-process-name "claude"

# (Optional) The process name for your editor if it's not 'nvim'.
set -g @nvim-process-name "nvim"

# (Optional) Customize the keybinding.
set -g @claude-opener-key "J"
```

## Usage

1.  Ensure your AI assistant and Neovim are running in separate tmux panes in the same window.
2.  Let the AI modify a file.
3.  Press `prefix + J` (or your custom key).
4.  The modified file will instantly open in your Neovim pane.
