local opt = vim.opt
local g = vim.g
local o = vim.o

opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
opt.backup = false
opt.swapfile = false
opt.scrolloff = 10 -- always show minimum n lines after current line
opt.relativenumber = false -- Show relative numberline
opt.wrap = false
-- g.highlighturl_enabled = true -- highlight URLs by default
-- opt.splitkeep = "screen"  -- Maintain code view when splitting

-- Folding settings
-- zc fold block
-- zo unfold block
-- zM fold all blocks
-- zR unfold all blocks
-- za toggle folding
opt.foldcolumn = "1" -- show foldcolumn in nvim 0.9
opt.foldlevel = 1
opt.foldnestmax = 1
opt.foldlevelstart = 99
opt.foldenable = true
opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

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