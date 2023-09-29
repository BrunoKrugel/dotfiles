local opt = vim.opt
local g = vim.g
local o = vim.o

vim.wo.statuscolumn = ""

opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
opt.backup = false --- Recommended by coc
opt.swapfile = false
opt.scrolloff = 10 -- always show minimum n lines after current line
opt.relativenumber = false -- Show relative numberline
opt.wrap = false
opt.iskeyword:append "-"
opt.termguicolors = true -- True color support
opt.autoindent = true --- Good auto indent
opt.backspace = "indent,eol,start" --- Making sure backspace works

-- Map in dotyfile
g.mapleader = " "
g.maplocalleader = " "

opt.conceallevel = 2
opt.concealcursor = "" --- Set to an empty string to expand tailwind class when on cursorline

-- Folds
opt.foldenable = true
opt.foldcolumn = "auto" -- show foldcolumn in nvim 0.9
opt.foldnestmax = 0
opt.foldlevel = 99
opt.foldlevelstart = 99
vim.opt.fillchars = {
  -- horiz     = '━',
  -- horizup   = '┻',
  -- horizdown = '┳',
  -- vert      = '┃',
  -- vertleft  = '┫',
  -- vertright = '┣',
  -- verthoriz = '╋',
  fold      = ' ',
  foldopen  = '',
  foldsep   = ' ',
  foldclose = '',
  stl       = ' ',
  eob       = ' ',
}
opt.foldmethod = "expr"
-- opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldexpr = ""

-- Copilot
g.copilot_assume_mapped = true

-- Bookmark
g.bookmark_sign = ""
g.bookmark_highlight = "CopilotHl"

opt.emoji = false
opt.cursorline = true

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
  g.neovide_floating_blur_amount_x = 3.0
  g.neovide_floating_blur_amount_y = 3.0
end
