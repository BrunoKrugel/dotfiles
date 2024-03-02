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
  fold = " ",
  foldopen = "",
  -- foldopen = '◡',
  foldsep = " ",
  foldclose = "",
  -- foldclose = '▹',
  -- foldclose = '◠',
  -- [eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
  stl = " ",
  eob = " ",
}
-- opt.foldmethod = "expr"
-- opt.foldexpr = "nvim_treesitter#foldexpr()"
-- opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- opt.foldexpr = ""

-- go to previous/next line with h,l,left arrow and right arrow when cursor reaches end/beginning of line
opt.whichwrap:append "<>[]hl"

-- Copilot
g.copilot_assume_mapped = true

opt.emoji = false
opt.cursorline = true

if vim.fn.has "nvim-0.10" == 1 then
  opt.smoothscroll = true
end

if vim.env.TMUX then
  vim.opt.laststatus = 0
else
  vim.opt.laststatus = 3
end

if g.neovide then
  opt.guifont = "Hack Nerd Font:h12"
  -- opt.guifont = "JetbrainsMono Nerd Font:h12"
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
  g.neovide_floating_shadow = true
  g.neovide_floating_z_height = 40
  g.neovide_light_angle_degrees = 45
  g.neovide_light_radius = 10
  g.neovide_scroll_animation_length = 0.5
  g.neovide_scroll_animation_far_lines = 1
  vim.g.neovide_hide_mouse_when_typing = true
  vim.cmd("NeovideFocus")
end
