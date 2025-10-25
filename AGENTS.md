# AGENTS.md

AI coding agents should follow these guidelines when working in this repository.

## Build/Lint/Test Commands

- **Format code**: `treefmt` (available via `nix develop dev/`; formats Nix with nixfmt, Lua with stylua)
- **Build all**: `nix build` (builds all Neovim configurations)
- **Build specific**: `nix build .#<config>` where config is core, dev, deno, go, lua, nix, python, or rust
- **Test in dev mode**: `nix run dev/` (launches Neovim with full dev configuration)
- **No unit tests**: This is a configuration repository; testing is done by running Neovim

## Code Style

- **Lua**: 2 spaces, single quotes (auto-prefer), 100 column width, Unix line endings
- **Nix**: Use nixfmt formatting (automatically applied by treefmt)
- **Indentation**: Always use spaces, never tabs (shiftwidth=2, tabstop=2)
- **LSP**: External formatters preferred over LSP formatting (see nvim/after/ftplugin/lua.lua:10)
- **Imports**: Use `require('module')` in Lua; check existing files for patterns
- **File organization**: Configs in nvim/plugin/, plugin configs in nvim/after/plugin/, filetypes in nvim/after/ftplugin/
- **Naming**: Use snake_case for Lua files, kebab-case for Nix files
- **Comments**: Minimal; Lua uses `--`, Nix uses `#`
- **Architecture**: Follow modular pattern - configs, plugins, filetypes, utils are separate attribute sets
- **Error handling**: Use vim.api functions; check executables before LSP setup (see nvim/lua/my/lsp.lua)
- **Commits**: Use Conventional Commits format: `type(scope): description` (e.g., feat, fix, docs, chore)
