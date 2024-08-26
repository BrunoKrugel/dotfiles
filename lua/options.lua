local opt = vim.opt
local g = vim.g
local o = vim.o

-- vim.wo.statuscolumn = ""

opt.encoding = "utf-8"
opt.backup = false --- Recommended by coc
opt.swapfile = false
opt.scrolloff = 10 -- always show minimum n lines after current line
opt.relativenumber = false -- Show relative numberline
opt.wrap = false
opt.iskeyword:append "-"
opt.termguicolors = true -- True color support
opt.autoindent = true --- Good auto indent
opt.backspace = "indent,eol,start" --- Making sure backspace works
opt.laststatus = 3 -- global statusline
opt.showmode = false
opt.smoothscroll = true

o.mousemoveevent = true
vim.opt.sessionoptions="blank,buffers,curdir,tabpages,winsize,winpos,terminal,localoptions"

opt.clipboard = "unnamedplus"
opt.cursorline = true
opt.cursorlineopt = "number"

-- Indenting
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.tabstop = 2
opt.softtabstop = 2

opt.fillchars = { eob = " " }
opt.ignorecase = true
opt.smartcase = true
opt.mouse = "a"

-- Numbers
opt.number = true
opt.numberwidth = 2
opt.ruler = false

-- disable nvim intro
opt.shortmess:append "sI"

opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.timeoutlen = 400
opt.undofile = true

-- interval for writing swap file to disk, also used by gitsigns
opt.updatetime = 250

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append "<>[]hl"

-- Map in dotyfile
g.mapleader = " "
g.maplocalleader = " "
g.dap_virtual_text = true
g.bookmark_sign = ""
vim.g.query_lint_on = { "BufWrite" }

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
opt.smoothscroll = true

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
  g.neovide_input_macos_option_key_is_meta = "both"
  g.neovide_input_use_logo = false
  g.neovide_padding_top = 0
  g.neovide_padding_bottom = 0
  g.neovide_padding_right = 0
  g.neovide_padding_left = 0
  g.neovide_floating_blur_amount_x = 0.0
  g.neovide_floating_blur_amount_y = 0.0
  g.neovide_floating_shadow = false
  g.neovide_floating_z_height = 40
  g.neovide_light_angle_degrees = 45
  g.neovide_light_radius = 10
  g.neovide_scroll_animation_length = 0.5
  g.neovide_scroll_animation_far_lines = 1
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_underline_automatic_scaling = true

  -- See https://github.com/neovide/neovide/issues/2330
  vim.schedule(function()
    vim.cmd "NeovideFocus"
  end)

  -- https://github.com/neovide/neovide/issues/1771
  vim.api.nvim_create_autocmd({ "BufLeave", "BufNew" }, {
    callback = function()
      vim.g.neovide_scroll_animation_length = 0
      vim.g.neovide_cursor_animation_length = 0
    end,
  })

  vim.api.nvim_create_autocmd({ "BufEnter", "BufNew" }, {
    callback = function()
      vim.fn.timer_start(32, function()
        vim.g.neovide_scroll_animation_length = 0.3
        vim.g.neovide_cursor_animation_length = 0.08
      end)
    end,
  })
end
