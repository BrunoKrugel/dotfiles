local opt = vim.opt
local g = vim.g

opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

opt.backup = false
opt.swapfile = false

opt.scrolloff = 10
opt.relativenumber = false -- Show relative numberline
opt.wrap = false
opt.splitkeep = "screen"  -- Maintain code view when splitting
opt.foldcolumn = "1" -- show foldcolumn in nvim 0.9
opt.foldlevel = 1 -- set high foldlevel for nvim-ufo
opt.foldnestmax = 2
opt.foldlevelstart = 99
opt.foldenable = true
opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

-- Avoid conflict with nvim-cmp's tab fallback
-- g.copilot_no_tab_map = true
g.copilot_assume_mapped = true
-- g.copilot_tab_fallback = ''
-- vim.keymap.set('i', '<Tab>', [[copilot#Accept('')]], { noremap = true, silent = true, expr = true })

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- disable underline in diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  underline = false,
  signs = true,
  update_in_insert = false,
})

g.bookmark_sign = ""
g.bookmark_highlight = "DevIconErb"
g.highlighturl_enabled = true -- highlight URLs by default

vim.fn.sign_define("DapBreakpoint", {
  text = "",
  texthl = "NeotestAdapterName",
  linehl = "",
  numhl = "",
})

require "custom.autocmd"
require "custom.usrcmd"
require "custom.neovide"
