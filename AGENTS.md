# AGENTS.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Overview

This is a personal Neovim configuration based on kickstart.nvim - a single-file, well-documented starting point for Neovim configuration. The configuration uses modern Neovim (0.10+) features and Lua for all configuration.

## Architecture

### Configuration Structure

- **init.lua**: Single-file configuration (~1016 lines) containing all core settings, keymaps, and plugin specifications
- **lua/kickstart/plugins/**: Optional plugin modules (debug, neo-tree, autopairs, lint, indent_line, gitsigns) - currently not actively loaded but available
- **lua/custom/plugins/**: Empty directory for user-specific plugin additions

### Plugin Management

Uses `lazy.nvim` as the plugin manager. Plugin specifications are defined in `init.lua` within the `require('lazy').setup()` call starting at line 248.

### Key Plugin Categories

1. **LSP Configuration** (lines 479-737):
   - Uses `nvim-lspconfig` with `mason.nvim` for automatic LSP server installation
   - Mason manages LSP servers, formatters, and linters
   - Currently configured LSP: `lua_ls`
   - Uses `blink.cmp` for completion capabilities

2. **Completion** (lines 780-877):
   - `blink.cmp` for autocompletion
   - `LuaSnip` for snippets
   - Uses 'default' keymap preset (ctrl-y to accept)

3. **Fuzzy Finding** (lines 361-463):
   - Telescope with fzf-native and ui-select extensions
   - Leader-based keybinds for searching (e.g., `<leader>sf` for files, `<leader>sg` for grep)

4. **Formatting** (lines 739-778):
   - `conform.nvim` for autoformatting
   - Format on save enabled (except for C/C++)
   - Currently configured: `stylua` for Lua files

5. **UI Components**:
   - `which-key.nvim` for keymap discovery
   - `mini.nvim` modules (ai, surround, statusline)
   - `tokyonight.nvim` colorscheme (tokyonight-night variant)
   - `nvim-treesitter` for syntax highlighting

## Development Commands

### Plugin Management
```fish
# Inside Neovim - check plugin status
:Lazy

# Update all plugins
:Lazy update

# Check health
:checkhealth
```

### LSP and Tools
```fish
# Inside Neovim - manage LSP servers and tools
:Mason

# Check LSP status for current buffer
:LspInfo
```

### Formatting
```fish
# Inside Neovim - format current buffer
<leader>f
# (Leader is space key)

# Check conform formatter status
:ConformInfo
```

### Treesitter
```fish
# Inside Neovim - update parsers
:TSUpdate

# Check Treesitter status
:TSInstallInfo
```

### Testing Configuration
Launch Neovim to test configuration changes:
```fish
nvim
```

For debugging issues, use `:checkhealth` within Neovim.

## Key Keybindings Reference

### LSP Operations (when LSP is active)
- `grn` - Rename symbol
- `gra` - Code action
- `grr` - Find references (Telescope)
- `grd` - Go to definition (Telescope)
- `gri` - Go to implementation (Telescope)
- `grt` - Go to type definition (Telescope)
- `grD` - Go to declaration
- `gO` - Document symbols (Telescope)
- `gW` - Workspace symbols (Telescope)

### Telescope (Search)
- `<leader>sf` - Find files
- `<leader>sg` - Live grep
- `<leader>sw` - Search word under cursor
- `<leader>sd` - Search diagnostics
- `<leader>sh` - Search help
- `<leader>sk` - Search keymaps
- `<leader>sr` - Resume last search
- `<leader>sn` - Search Neovim config files
- `<leader><leader>` - Find buffers
- `<leader>/` - Fuzzy find in current buffer

### Window Navigation
- `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>` - Move focus between windows

### Formatting
- `<leader>f` - Format buffer (async with LSP fallback)

### Toggles
- `<leader>th` - Toggle inlay hints (if LSP supports)

## Code Style

### Lua Formatting
Stylua is used for Lua code formatting with these settings (.stylua.toml):
- Column width: 160
- Indent: 2 spaces
- Quote style: AutoPreferSingle
- Call parentheses: None

### Code Organization
- Plugin specs use lazy.nvim's declarative format
- Autocommands use `vim.api.nvim_create_autocmd`
- Keymaps use `vim.keymap.set`
- Options use `vim.o` or `vim.opt` (for list/map options)

## Important Configuration Details

### Leader Key
Space is the leader key (`vim.g.mapleader = ' '`)

### Nerd Font
`vim.g.have_nerd_font` is set to `false` - affects icon display in plugins. Set to `true` if a Nerd Font is installed.

### LSP Capabilities
The config uses `blink.cmp` to extend LSP capabilities. When adding new LSP servers, capabilities are automatically configured via `require('blink.cmp').get_lsp_capabilities()`.

### Custom Plugins
To add custom plugins, create files in `lua/custom/plugins/` and uncomment the import line at the end of init.lua (line 987).

### Treesitter Configuration
- Auto-installs missing parsers
- Ruby requires special handling with `additional_vim_regex_highlighting` and disabled indent

## Extending the Configuration

### Adding a New LSP Server
Add to the `servers` table around line 673:
```lua
servers = {
  your_lsp = {
    settings = {
      -- LSP-specific settings
    },
  },
}
```
Add to `ensure_installed` list (line 716) to auto-install via Mason.

### Adding a New Formatter
Add to `formatters_by_ft` in conform.nvim config (line 769):
```lua
formatters_by_ft = {
  your_filetype = { 'formatter_name' },
}
```

### Modular Plugin Approach
While init.lua is currently a single file, kickstart plugins in `lua/kickstart/plugins/` demonstrate the modular approach. These can be enabled by uncommenting the require statements around line 976.

## Notable Configuration Choices

- Format on save is enabled by default (via conform.nvim) but disabled for C/C++
- Diagnostic virtual text shows all severities with source attribution
- Clipboard is synchronized with OS (`vim.o.clipboard = 'unnamedplus'`)
- Relative line numbers are enabled
- Diagnostic signs use Nerd Font icons when available
- Completion uses the 'default' preset (ctrl-y to accept, not tab)
