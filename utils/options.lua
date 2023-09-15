local opt = vim.opt
local g = vim.g
local o = vim.o

vim.wo.statuscolumn = ""

opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
opt.backup = false
opt.swapfile = false
opt.scrolloff = 10 -- always show minimum n lines after current line
opt.relativenumber = false -- Show relative numberline
opt.wrap = false
opt.iskeyword:append "-"
opt.termguicolors = true -- True color support

-- Map in dotyfile
g.mapleader = " "
g.maplocalleader = " "

-- Folding settings
-- zc fold block
-- zo unfold block
-- zM fold all blocks
-- zR unfold all blocks
-- za toggle folding
opt.foldenable = true

-- UFO
opt.foldcolumn = "1" -- show foldcolumn in nvim 0.9
opt.foldlevel = 1
opt.conceallevel = 2
opt.foldnestmax = 1
opt.foldlevelstart = 99
opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

-- CUSTOM
-- vim.o.foldmethod = "expr"
-- vim.o.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.o.signcolumn = "yes"
-- vim.o.foldcolumn = "2"
-- vim.o.signcolumn = "number"
o.number = true
o.numberwidth = 2

-- Spell
-- opt.spell = true
-- opt.spelllang = { 'en_us' }

-- Copilot
g.copilot_assume_mapped = true

-- Bookmark
g.bookmark_sign = ""
g.bookmark_highlight = "CopilotHl"

o.statuscolumn = "%=%l%s%C"
o.emoji = false
o.cursorline = true
o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

if g.neovide then
  -- opt.guifont = "Hack Nerd Font:h12"
  opt.guifont = "JetbrainsMono Nerd Font:h12"
  g.neovide_refresh_rate = 120
  g.neovide_remember_window_size = true
  g.neovide_cursor_antialiasing = true
  g.neovide_input_macos_alt_is_meta = true
  g.neovide_input_use_logo = false
  g.neovide_padding_top = 0
  g.neovide_padding_bottom = 0
  g.neovide_padding_right = 0
  g.neovide_padding_left = 0
end
