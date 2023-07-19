<h1 align="center">Nvim(Chad) configuration</h1>
<p align="center">Custom config for <a href="https://github.com/NvChad/NvChad">git@github.com:NvChad/NvChad</a><p>
<h3 align="center">

![Lines of code](https://img.shields.io/tokei/lines/github/BrunoKrugel/dotfiles?color=%2381A1C1&label=LINES&logoColor=%2381A1C1&style=for-the-badge)
![Bloat](https://img.shields.io/badge/Bloat-Minimal-c585cf?style=for-the-badge)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/BrunoKrugel/dotfiles?color=e1b56a&style=for-the-badge)
![GitHub Repo stars](https://img.shields.io/github/stars/BrunoKrugel/dotfiles?color=74be88&style=for-the-badge)
![GitHub top language](https://img.shields.io/github/languages/top/BrunoKrugel/dotfiles?color=6d92bf&style=for-the-badge)

<div align="center">
    
![prv-min](./img/prv.png)
</div>

</h3>
<hr>

## Introduction

I do not own anything related to NvChad, this is only my configs that I use with it.

I have been a VSCode user for years and I am slowly moving forward to `NVIM`, so this is my config that mimic `VSCode` key binds and UI, with a goal of removing plugins as I am getting used to it and learning more about `NVIM`.

## Installation guide

1. Same as [NvChad](https://nvchad.com/docs/quickstart/install)
2. After installing NvChad, clone this repo inside your custom NvChad folder.
3. Download and install [CTAGS](https://github.com/universal-ctags/ctags) (for a better Go To Definition)
4. I am using `Hack Nerd Font`
5. My terminal is `WezTerm`
6. My neovim version is `Nightly`
7. I am using a M1, so, some things may not work out of the box for you

## Help

For questions feel free to open an issue or you can find me in the [NvChad discord](https://discord.com/invite/gADmkJb9Fb) server.

## Configured environments

- [x] Lua
- [x] Go ([go.nvim](https://github.com/ray-x/go.nvim))
- [x] Web development (JS, TS, HTML, CSS, React, Astro)
- [x] Markdown

TreeSitter is enabled and will automatically install parsers for you.

## CMP fully integrated with AI completions

<div align="center">

![cmp](./img/cmp.png)

</div>

Cmp will not open automatically, to trigger it, press `<C-Space>`.

You can navigate between the options with `<Up>` and `<Down>` and select with `<CR>`.

If Cmp is visible, you can use `<Esc>` to close it without leaving `Insert` mode.

If the copilot suggestion is active, you can use `<Tab>` to select the copilot option.

## Code foldable in a VSCode style

<div align="center">

![fold](./img/fold.png)

_With [UFO](https://github.com/kevinhwang91/nvim-ufo), [Pretty Fold](https://github.com/anuvyklack/pretty-fold.nvim)_

</div>

These plugins are currently disabled, because a custom fold plugin is active in `status.lua`, but fell free to activate again.

## Diagnostics in a VSCode style

### Diagnostics Tab

<div align="center">

![diagnostics](./img/diagnostics.png)

_With [Trouble](https://github.com/folke/trouble.nvim)_

</div>

### Diagnostics in the gutter

<div align="center">

![error](./img/error_lens.png)

_With [Error Lens](https://github.com/chikko80/error-lens.nvim)_

</div>

### Diagnostics with LSP Lines

<div align="center">

![scrollbar](./img/lsp.png)

_With [lsp-lines](https://github.com/ErichDonGubler/lsp_lines.nvim)_

</div>

LSP Lines is only enabled for Go, so it may need some tweaking for other languages.

### Diagnostics in scrollbar

<div align="center">

![scrollbar](./img/discroll.png)

_With [nvim-scrollbar](https://github.com/petertriho/nvim-scrollbar)_

</div>

## Winbar

<div align="center">

![navic](./img/navic.png)

_With [LSPSaga](https://github.com/nvimdev/lspsaga.nvim) or [Dropbar](https://github.com/Bekaboo/dropbar.nvim)_

</div>

Dropbar currently only work in neovim `nightly` and is disabled by default, if you want to use it, enable the plugin `dropbar.lua` and then disable the lspsaga winbar in `lspsaga.lua`.

## Word highlight

<div align="center">

![word](./img/word.png)

_With [Illuminate](https://github.com/RRethy/vim-illuminate)_

</div>

## TODO Tracking

<div align="center">

![todo](./img/todo.png)

_With [Todo-comments](https://github.com/folke/todo-comments.nvim)_

</div>

## Context

<div align="center">

![context](./img/context.png)

_With [Biscuits](https://github.com/code-biscuits/nvim-biscuits)_

![fcontext](./img/fcontext.png)

_With [ts-context](https://github.com/nvim-treesitter/nvim-treesitter-context)_

</div>

## Search and replace

### Local Search

<div align="center">

![search](./img/search.png)

_With [SearchBox](https://github.com/VonHeikemen/searchbox.nvim)_

</div>

### Local Rename

<div align="center">

![rename](./img/rename.png)

_With [IncRename](https://github.com/smjonas/inc-rename.nvim)_

</div>

### Global rename

<div align="center">

![muren](./img/muren.png)

_With [Muren](https://github.com/AckslD/muren.nvim)_

</div>

## Bookmarks

<div align="center">

![bookmark](./img/bookmark.png)

_With [Bookmark](https://github.com/MattesGroeger/vim-bookmarks)_

</div>

## Telescope Integrations

- Telescope frequent files `<leader>fr` (with [telescope-frecency](https://github.com/nvim-telescope/telescope-frecency.nvim))
- Telescope undo tree `<leader>fu` (with [telescope-undo](https://github.com/debugloop/telescope-undo.nvim))
- Telescope fuzzy native (with [telescope-fzf-native](https://github.com/nvim-telescope/telescope-fzf-native.nvim))

## Custom Statusline icons

<div align="center">

![status](./img/Statusline.png)

</div>

From left to right:

1. Github copilot status (it shows if copilot is active or not)
2. Harpoon file navigation (it shows if harpoon is harpooned or not)
3. Battery status (usefull when using in fullscreen)
4. Session status (icon for Possession plugin)

## Custom Tabufline icons

<div align="center">

![status](./img/tabufline.png)

</div>

From left to right:

1. GitHub UI (on click will open `LazyGit` window)
2. Compiler and Run (on click will open `Compiler.nvim`)
3. Split window button (on click will split the current window vertically)

## References

<div align="center">

![Reference](./img/reference.png)

_With [Glance](https://github.com/DNLHC/glance.nvim)_

</div>


## Keybinds

All the keybinds are available in the `mappings.lua` file, and also described in the NVCheatSheet, you can access it with `<leader>ch`.

Commom Text keybinds are also available:

- Ctrl + A Select All
- Ctrl + X Cut
- Ctrl + C Copy
- Ctrl + V Paste
- Ctrl + Z Undo

## Formatting

I do not like format on save, so my config is set to format on `<leader>fm` only, but you can change it to whatever you want, to do it, just uncomment the autocmd in the `autocmd.lua` file.

For `.go` files, you can use `<leader>fi` to complete imports.

## Improved GoToDefinition

I am using universal CTAGS to have a better GoToDefinition, the tags are generated automatically with [guttentags](https://github.com/ludovicchabant/vim-gutentags).
Keybind to use is `<C-]>`.

## Github

<div align="center">

![LazyGit](./img/lazygit.png)

_With [LazyGit](https://github.com/kdheepak/lazygit.nvim)_

</div>

## Colorpicker tool

<div align="center">

![Colorpicker](./img/colorpicker.png)

_With [Colortils](https://github.com/nvim-colortils/colortils.nvim)_

</div>

## Theme

I have adapted the [Evondev Dracula](https://github.com/evondev/evondev-dracula) theme from VSCode to Neovim, you can find it in the `theme` folder.

<div align="center">

![theme](./img/theme.png)

![theme2](./img/theme2.png)

</div>

## Neovide

Config ready for neovide, options are available in the `neovide.lua` file.

## Other plugins

- Auto save with [auto-save](https://github.com/Pocco81/auto-save.nvim)
- UI overhaul with [Noice](https://github.com/folke/noice.nvim)
- UI Improvement with [Telescope-ui-select](https://github.com/nvim-telescope/telescope-ui-select.nvim)
- Arguments highlights with [hlargs](https://github.com/m-demare/hlargs.nvim)
- Quick file navigation with [Harpoon](https://github.com/ThePrimeagen/harpoon)
- Dim unused buffers with [Tint](https://github.com/levouh/tint.nvim)
- Minimap with [Codewindow](https://github.com/gorbit99/codewindow.nvim)
