# Fish Shell Configuration

Personal Fish shell configuration with custom functions, completions, and plugins.

## 🚀 Features

- **Custom Git Functions**: Streamlined git workflow with functions like `gwip`, `gunwip`, `gbage`, `gbda`, and more
- **Plugin Management**: Uses [Fisher](https://github.com/jorgebucaran/fisher) for plugin management
- **Node Version Management**: Integrated with [nvm.fish](https://github.com/jorgebucaran/nvm.fish)
- **System Utilities**: Custom functions for display toggling, sketchybar, and aerospace padding
- **Completions**: Tab completions for fisher, nvm, and bun

## 📁 Structure

```
.
├── config.fish           # Main configuration file
├── fish_plugins          # Fisher plugin list
├── functions/            # Custom functions
│   ├── __git.*.fish     # Git utility functions
│   ├── g*.fish          # Git workflow functions
│   ├── nvm.fish         # Node version manager
│   └── toggle_*.fish    # System utility functions
├── completions/          # Tab completions
│   ├── fisher.fish
│   ├── nvm.fish
│   └── bun.fish
└── .gitignore           # Excludes secrets and system files
```

## 🛠 Installation

1. **Backup your current config** (if you have one):
   ```fish
   mv ~/.config/fish ~/.config/fish.backup
   ```

2. **Clone this repository**:
   ```fish
   git clone https://github.com/RichardBray/fish-config.git ~/.config/fish
   ```

3. **Install Fisher** (if not already installed):
   ```fish
   curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
   ```

4. **Install plugins**:
   ```fish
   fisher update
   ```

5. **Create secrets file** (optional):
   ```fish
   touch ~/.config/fish/secrets.fish
   ```
   Add your API keys and sensitive environment variables to this file.

## 🔧 Custom Functions

### Git Workflow
- `gwip` - Create a work-in-progress commit
- `gunwip` - Undo the last WIP commit
- `gbage` - Delete merged branches
- `gbda` - Delete all branches except main/master
- `grename` - Rename current branch
- `grt` - Go to repository root
- `gtl` - Show git log tree
- `glp` - Git log with patches
- `gtest` - Run tests in git repository

### System Utilities
- `toggle_display` - Toggle external display settings
- `toggle_sketchybar` - Toggle sketchybar visibility
- `toggle_aerospace_padding` - Toggle aerospace window padding

## 🔒 Security

- `secrets.fish` is excluded from version control
- `fish_variables` (system-specific settings) is excluded
- Always review the code before using sensitive functions

## 📦 Plugins

- [Fisher](https://github.com/jorgebucaran/fisher) - Plugin manager
- [nvm.fish](https://github.com/jorgebucaran/nvm.fish) - Node version manager
- [plugin-git](https://github.com/jhillyerd/plugin-git) - Git utilities

## 🤝 Contributing

Feel free to fork this repository and customize it for your own needs. Pull requests for improvements are welcome!

## 📄 License

This configuration is provided as-is for personal use. Feel free to adapt and modify as needed.
