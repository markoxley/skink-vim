# skink-vim

Vim/Neovim support for the [Skink](https://github.com/markoxley/skink-lang) programming language.

Features:

- Filetype detection for `*.skink` files
- Syntax highlighting (comments, strings with `{expr}` interpolation, keywords, builtin types, numeric literals, operators)
- Brace-based auto-indentation, including `case`/`default` handling in `switch` blocks

## Installation

### vim-plug

Add to your `.vimrc` / `init.vim`:

```vim
Plug 'markoxley/skink-vim'
```

Then run `:PlugInstall`.

### lazy.nvim (Neovim)

```lua
{ "markoxley/skink-vim" }
```

### packer.nvim (Neovim)

```lua
use "markoxley/skink-vim"
```

### Vundle

```vim
Plugin 'markoxley/skink-vim'
```

Then run `:PluginInstall`.

### Pathogen

```sh
git clone https://github.com/markoxley/skink-vim.git ~/.vim/bundle/skink-vim
```

### Vim 8+ native packages

```sh
git clone https://github.com/markoxley/skink-vim.git \
    ~/.vim/pack/plugins/start/skink-vim
```

### Neovim native packages

```sh
git clone https://github.com/markoxley/skink-vim.git \
    ~/.local/share/nvim/site/pack/plugins/start/skink-vim
```

### Manual install

Copy the plugin directories into your Vim runtime directory:

```sh
# Vim
cp -r ftdetect syntax indent ~/.vim/

# Neovim
cp -r ftdetect syntax indent ~/.config/nvim/
```

## Usage

Open any `.skink` file — filetype detection, highlighting, and indentation are enabled automatically:

```sh
vim hello.skink
```

To verify the filetype was detected:

```vim
:set filetype?
" should print: filetype=skink
```

If a file isn't detected automatically, set the filetype manually:

```vim
:set filetype=skink
```

## Language Server (LSP)

`skink-lsp` (in `tools/skink-lsp/` of the compiler repo) provides
completion, hover, diagnostics, go-to-definition, references, rename,
formatting and semantic tokens over stdio.

**Neovim ≥ 0.8** — `plugin/skink-lsp.vim` auto-starts it on
`FileType skink` (project root = nearest `skink.toml`, else the file's
dir). No extra config needed once `skink-lsp` is on `PATH`.

Manual/programmatic start:

```lua
require('skink_lsp').setup()                  -- defaults
require('skink_lsp').setup{cmd={'/path/to/skink-lsp'}}
```

**nvim-lspconfig** — register a custom server:

```lua
local lspconfig = require('lspconfig')
local configs = require('lspconfig.configs')
configs.skink_lsp = {
  default_config = {
    cmd = {'skink-lsp'},
    filetypes = {'skink'},
    root_dir = lspconfig.util.root_pattern('skink.toml', '.git'),
  },
}
lspconfig.skink_lsp.setup{}
```

**Vim 8 / other clients** — any LSP client works; the server is plain
stdio `skink-lsp`:

```vim
" vim-lsp
au User lsp_setup call lsp#register_server({
  \ 'name': 'skink-lsp',
  \ 'cmd': {server_info->['skink-lsp']},
  \ 'allowlist': ['skink'],
  \ })

" coc.nvim (coc-settings.json)
"   "languageserver": { "skink": { "command": "skink-lsp",
"     "filetypes": ["skink"] } }
