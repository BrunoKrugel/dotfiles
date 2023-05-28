<h1 align="center">Nvim(Chad) configuration</h1>
<p align="center">Custom config for <a href="https://github.com/NvChad/NvChad">git@github.com:NvChad/NvChad</a><p>
<h3 align="center">

<div align="center">
    
![prv-min](./img/prv.png)
</div>

</h3>
<hr>

## Introduction

I have been a VSCode user for years and I am slowly moving forward to `NVIM`, so this is my config that mimic `VSCode` keybinds and UI, with a goal from removing plugins as I am getting used to it and learning more about `NVIM`.

## Instalation guide

1. Same as [NvChad](https://nvchad.com/docs/quickstart/install)
2. I am using `Hack Nerd Font`
3. My terminal is `WezTerm`
4. I am using a M1, so some things may not work out of the box for you

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

You can navigate between the options with `<Up>` and `<Down>` and select with `<CR>`, if copilot is active, you can use `<Tab>` to select the copilot option.

## Code foldable in a VSCode style

<div align="center">

![fold](./img/fold.png)

_With [UFO](https://github.com/kevinhwang91/nvim-ufo)_

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

## Winbar

<div align="center">

![navic](./img/navic.png)

_With [LSPSaga](https://github.com/nvimdev/lspsaga.nvim)_

</div>

## Word highlight

<div align="center">

![word](./img/word.png)

_With [Illuminate](https://github.com/RRethy/vim-illuminate)_

<div>

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
3. Baterry status (usefull when using in fullscreen)
4. Session status (icon for Possession plugin)

## Keybinds

All the keybinds are available in the `mappings.lua` file, and also described in the NVCheatSheet, you can access it with `<leader>ch`.

## Formatting

I do not like format on save, so my config is set to format on `<leader>fm` only, but you can change it to whatever you want, to do it, just uncomment the autocmd in the `autocmd.lua` file.

For `.go` files, you can use `<leader>fi` to complete imports.

## Github

<div align="center">

![LazyGit](./img/lazygit.png)

_With [LazyGit](https://github.com/kdheepak/lazygit.nvim)_

</div>

## Neovide

Config ready for neovide, options are available in the `neovide.lua` file.
