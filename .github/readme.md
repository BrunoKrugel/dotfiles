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

I have been a VSCode user for years and I am slowly moving forward to `NVIM`, so this is my config that mimic `VSCode` keybinds and UI, with a goal from removing plugins as I am getting used to it and learning more about `NVIM`.

## Instalation guide

1. Same as [NvChad](https://nvchad.com/docs/quickstart/install)
2. Download and install [CTAGS](https://github.com/universal-ctags/ctags)
3. I am using `Hack Nerd Font`
4. My terminal is `WezTerm`
5. My neovim version is `nightly`
6. I am using a M1, so some things may not work out of the box for you

## Help

For questions feel free to open an issue or you can find me in the [NvChad discord](https://discord.com/invite/gADmkJb9Fb) server.

## Configured environments

- [x] Lua
- [x] Go ([go.nvim](https://github.com/ray-x/go.nvim))
- [x] JavaScript

## CMP fully integrated with AI completion

<div align="center">

![cmp](./img/cmp.png)

</div>

You can navigate between the options with `<Up>` and `<Down>` and select with `<CR>`.

If copilot suggestion is active, you can use `<Tab>` to select the copilot option.

## Code foldable in a VSCode style

<div align="center">

![fold](./img/fold.png)

_With [UFO](https://github.com/kevinhwang91/nvim-ufo), [Pretty Fold](https://github.com/anuvyklack/pretty-fold.nvim)_

</div>

## Diagnostics in a VSCode style

### Diagnostics tab

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

If you do not use neovim `nightly`, you should disable the plugin `dropbar.lua` and then enable the lspsaga winbar in `lspsaga.lua`.

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

## Keybinds

All the keybinds are available in the `mappings.lua` file, and also described in the NVCheatSheet, you can access it with `<leader>ch`.

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

## Theme

I have adapted the Evondev Dracula theme from VSCode to Neovim, you can find it in the `theme` folder.

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
