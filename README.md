# Neovim Configuration

A modular Neovim configuration built with Nix flakes, designed to create different Neovim variants optimized for various development environments.

## Features

- **Modular Architecture**: Extensible configuration system with reusable components
- **Language-Specific Variants**: Optimized configurations for different programming languages
- **Nix Flakes**: Reproducible builds and dependency management
- **Development Environment**: Complete dev setup with formatting and pre-commit hooks

## Quick Start

### Try It Out

```bash
# Run the lightweight core configuration
nix run github:hasundue/nvim#core

# Or run the full configuration with all plugins
nix run github:hasundue/nvim#full

# Or try a language-specific variant
nix run github:hasundue/nvim#python
```

### Installation

Add to your `flake.nix`:

```nix
{
  inputs.nvim.url = "github:hasundue/nvim";
  
  outputs = { nvim, ... }: {
    # Use as a package
    environment.systemPackages = [ nvim.packages.${system}.full ];
    
    # Or in a development shell
    devShells.default = pkgs.mkShell {
      buildInputs = [ nvim.packages.${system}.python ];
    };
  };
}
```

## Configuration Variants

| Variant | Description | Language Servers | Use Case |
|---------|-------------|------------------|----------|
| `core` | Minimal base configuration | None | Basic editing |
| `full` | Complete development setup | All supported | Full development |
| `deno` | TypeScript/JavaScript with Deno | Built-in Deno LSP | Deno projects |
| `go` | Go development | gopls | Go projects |
| `lua` | Lua development | lua-language-server | Lua/Neovim config |
| `nix` | Nix development | nil | Nix expressions |
| `python` | Python development | pyright | Python projects |
| `rust` | Rust development | rust-analyzer | Rust projects |

## Usage

### Basic Commands

```bash
# Run a neovim variant
nix run .#nix

# Enter a development shell with a specific variant
nix develop .#lua
```

### Development Environment

```bash
# Enter development environment
nix develop dev/

# Run the full variant in development mode
nix run dev/
```

This provides:
- Full Neovim configuration with all plugins
- Code formatting tools (nixfmt, stylua)
- Pre-commit hooks
- Live reloading during development


## Architecture

### Core Components

- **Overlays** (`overlays/`): Nix overlays defining the modular architecture
- **Configurations** (`nvim/plugin/`): Core Neovim settings and options
- **Plugin Configs** (`nvim/after/plugin/`): Individual plugin configurations
- **Language Support** (`nvim/after/ftplugin/`): Filetype-specific settings
- **Utilities** (`nvim/lua/my/`): Custom Lua utilities and helpers

### Plugin Highlights

- **LSP**: Native LSP client with language-specific configurations
- **Completion**: blink.cmp for fast autocompletion
- **UI**: Kanagawa theme, Lualine status line, Noice command line
- **Navigation**: Telescope fuzzy finder, Oil file manager
- **Git**: Gitsigns for git integration
- **Editing**: Treesitter for syntax highlighting, nvim-surround for text objects

## Project Structure

```
.
├── flake.nix              # Main flake definition
├── overlays/              # Nix overlays
│   ├── nvim.nix          # Core architecture
│   └── plugins.nix       # Plugin customizations
├── nvim/                  # Neovim configuration
│   ├── plugin/           # Core settings
│   ├── after/plugin/     # Plugin configs
│   ├── after/ftplugin/   # Filetype configs
│   └── lua/my/           # Custom utilities
├── pkgs/                  # Nix packages
└── dev/                   # Development environment
```

## License

This project is released into the public domain under the [Unlicense](LICENSE).
