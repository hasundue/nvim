# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

This repository uses Nix flakes for development and building:

- **Development environment**: `nix develop dev/` - Sets up development shell with Neovim and formatting tools  
- **Run development Neovim**: `nix run dev/` - Launches Neovim with full development configuration
- **Format code**: `nix run dev/#treefmt` - Formats all code using nixfmt and stylua
- **Build packages**: `nix build` - Builds all Neovim configurations
- **Build specific config**: `nix build .#<config>` where `<config>` is core, dev, deno, go, lua, nix, python, or rust

The dev environment includes pre-commit hooks that automatically format code on commit.

## Architecture Overview

This is a modular Neovim configuration built with Nix flakes, designed to create different Neovim variants for different development environments.

### Core Structure

- **Flake-based**: Uses Nix flakes for reproducible builds and dependency management
- **Modular design**: Configurations are composed from reusable components (configs, plugins, filetypes, packages, utilities)
- **Language-specific variants**: Separate configurations optimized for different programming languages
- **Development vs production**: Separate overlays for development and production environments

### Key Components

**Overlays** (`overlays/`):
- `nvim.nix`: Main overlay defining the modular Neovim architecture with extensible configurations
- `plugins.nix`: Plugin customizations and external plugin definitions (like im-switch-nvim)

**Configurations** (`nvim/plugin/`):
- `opt.lua`: Core Neovim options and UI settings
- `lsp.lua`: LSP client configuration  
- `clipboard.lua`, `terminal.lua`: Additional functionality configs
- Plugin configurations in `nvim/after/plugin/`

**Language Support** (`nvim/after/ftplugin/`):
- Filetype-specific configurations for go, lua, nix, python, typescript

**Utilities** (`nvim/lua/my/`):
- `lsp.lua`: Utility functions for LSP setup with executable checks

**Wrapper** (`pkgs/wrapper.nix`):
- Custom Neovim wrapper that handles runtime path configuration
- Supports both development mode (using local files) and production mode (using nix store)
- Automatically generates plugin configuration files based on plugin names

### Configuration Variants

- **core**: Minimal configuration with essential plugins
- **dev**: Full development configuration with all plugins and tools
- **Language-specific**: Extensions for deno, go, lua, nix, python, rust with appropriate LSP servers and treesitter parsers

### Development Workflow

The repository supports both local development and external consumption:
- Development flake (`dev/`) provides testing environment and formatting tools
- Main flake exports packages for different Neovim configurations
- Pre-commit hooks ensure code quality with treefmt integration