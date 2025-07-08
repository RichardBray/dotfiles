# My NvChad Configuration

This repository contains my personal NvChad configuration files for Neovim. It's designed to be easily cloned and set up on a new machine, providing a consistent development environment across different computers.

## Prerequisites

Before using this configuration, ensure you have:

1. [Neovim](https://neovim.io/) (v0.9.0 or later) installed
2. [NvChad](https://github.com/NvChad/NvChad) base installation
3. [Git](https://git-scm.com/) installed
4. A terminal with a [Nerd Font](https://www.nerdfonts.com/) installed for proper icons

## Installation

Follow these steps to set up this configuration:

1. First, install NvChad following the [official instructions](https://nvchad.com/docs/quickstart/install)

2. Backup your existing configuration (if any):
   ```bash
   mv ~/.config/nvim ~/.config/nvim.bak
   ```

3. Clone this repository:
   ```bash
   git clone https://github.com/YourUsername/nvchad-config.git ~/.config/nvim
   ```

4. Start Neovim to install all plugins:
   ```bash
   nvim
   ```
   
   The first launch might show some errors, which should resolve after all plugins are installed.

## Features

### Theme Configuration
- Uses the `tokyonight` theme with dark variant for a clean and modern look

### Custom Keybindings
- `jk` in insert mode to escape
- Move selected text up/down with `Shift+K` and `Shift+J` in visual mode
- Buffer navigation:
  - `<leader>x` to close current buffer
  - `Alt+Left/Right` to navigate between previous/next buffers
  - `Alt+Up/Down` to navigate to first/last buffer
- Telescope shortcuts:
  - `<leader>ff` to find files
  - `<leader>fg` for live grep
  - `<leader>fb` to search buffers
  - `<leader>fh` for help tags
- LSP navigation:
  - `gd` to go to definition
  - `gD` to go to declaration
  - `K` for hover documentation
  - `<leader>ca` for code actions
  - `<leader>rn` to rename symbols

### LSP Configuration
- Go support with gopls:
  - Static checking
  - Unused parameter analysis
  - Code formatting with gofumpt
- TypeScript support with ts_ls
- Diagnostic configuration:
  - Virtual text enabled
  - Floating diagnostics
  - Signs in the gutter
  - Underlines for issues

### Custom Plugins
- NvimTree file explorer (positioned on the right side)
- Telescope for fuzzy finding
- Treesitter for better syntax highlighting
- Comment.nvim for easy code commenting
- Conform.nvim for code formatting
- Noice.nvim for enhanced UI
- Neoscroll for smooth scrolling
- Various other plugins for improved development experience

### Spell Checking
- English (GB) spell checking enabled by default
- Custom dictionary with technical terms like "kubernetes", "OpenSearch", "json", etc.

## Structure

Here's an overview of the important files and directories in this configuration:

- `init.lua`: Main configuration file that loads everything else
- `lua/chadrc.lua`: NvChad theme configuration
- `lua/mappings.lua`: Custom key mappings
- `lua/options.lua`: Neovim options and settings
- `lua/plugins/`: Directory containing plugin configurations
  - `init.lua`: Basic plugin setup
  - `lspconfig.lua`: Language Server Protocol configuration
  - `nvim-tree.lua`: File explorer configuration
  - `neoscroll.lua`: Smooth scrolling configuration
  - `noice.lua`: UI enhancements
  - `avante.lua`: Custom theme adjustments
- `lua/configs/`: Additional configuration files for plugins
- `spell/`: Custom spell checking dictionaries
- `lazy-lock.json`: Lock file for plugin versions

## Updating

To update all plugins:

```bash
:Lazy sync
```

## Customization

Feel free to modify this configuration to suit your needs. The most common files to edit are:

- `lua/mappings.lua` for custom keybindings
- `lua/plugins/` to add/remove plugins
- `lua/chadrc.lua` to change themes

## Troubleshooting

If you encounter any issues:

1. Make sure Neovim is up to date
2. Try running `:checkhealth` inside Neovim
3. Update plugins with `:Lazy sync`
4. Check for errors with `:messages`

**This repo is supposed to used as config by NvChad users!**

- The main nvchad repo (NvChad/NvChad) is used as a plugin by this repo.
- So you just import its modules , like `require "nvchad.options" , require "nvchad.mappings"`
- So you can delete the .git from this repo ( when you clone it locally ) or fork it :)

# Credits

1) Lazyvim starter https://github.com/LazyVim/starter as nvchad's starter was inspired by Lazyvim's . It made a lot of things easier!
