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
opt.wildignore = {
  "*node_modules/**",
  "*.o",
  "*.obj",
  "*.dll",
  "*.jar",
  "*.pyc",
  "*.rbc",
  "*.class",
  "*.gif",
  "*.ico",
  "*.jpg",
  "*.jpeg",
  "*.png",
  "*.avi",
  "*.wav",
  "*.swp",
  ".lock",
  ".DS_Store",
  "tags.lock",
}
-- g.highlighturl_enabled = true -- highlight URLs by default
-- opt.splitkeep = "screen"  -- Maintain code view when splitting

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
vim.o.number = true
vim.o.numberwidth = 2

-- Spell
-- opt.spell = true
-- opt.spelllang = { 'en_us' }

-- Copilot
g.copilot_assume_mapped = true

-- Bookmark
g.bookmark_sign = ""
g.bookmark_highlight = "DevIconErb"

-- visual-multi
g.VM_show_warnings = 0
g.VM_default_mappings = 0
g.VM_maps = {
  ["Find Under"] = "gb",
  ["Find Subword Under"] = "gb",
}

o.statuscolumn = "%=%l%s%C"
o.emoji = false
