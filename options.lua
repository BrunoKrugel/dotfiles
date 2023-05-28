local opt = vim.opt
local g = vim.g

opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
opt.backup = false
opt.swapfile = false
opt.scrolloff = 10
opt.relativenumber = false -- Show relative numberline
opt.wrap = false
-- opt.splitkeep = "screen"  -- Maintain code view when splitting
opt.foldcolumn = "1" -- show foldcolumn in nvim 0.9
opt.foldlevel = 1
opt.foldnestmax = 2
opt.foldlevelstart = 99
opt.foldenable = true
opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
opt.signcolumn = "auto:1-2"


g.copilot_assume_mapped = true
g.bookmark_sign = ""
g.bookmark_highlight = "DevIconErb"
g.highlighturl_enabled = true -- highlight URLs by default