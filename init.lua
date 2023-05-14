local opt = vim.opt
local autocmd = vim.api.nvim_create_autocmd

opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

opt.backup = false
opt.swapfile = false

opt.scrolloff = 10
opt.relativenumber = false
opt.wrap = false

-- Avoid conflict with nvim-cmp's tab fallback
-- vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
-- vim.g.copilot_tab_fallback = ''
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

vim.g.bookmark_sign = ""
vim.g.bookmark_highlight = "DevIconErb"

vim.o.foldcolumn = "1"
vim.o.foldlevel = 1
vim.o.foldnestmax = 2
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

vim.fn.sign_define('DapBreakpoint', {
  text = "",
  texthl = 'NeotestAdapterName',
  linehl = '',
  numhl = '',
})

require("custom.autocmd")
require("custom.usrcmd")