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

vim.fn.sign_define("DapBreakpoint", {
  text = "",
  texthl = "DapBreakpoint",
  linehl = "",
  numhl = "",
})

vim.highlight.priorities.semantic_tokens = 95 -- Or any number lower than 100, treesitter's priority level

require "custom.utils.autocmd"
require "custom.utils.usercmd"
require "custom.utils.neovide"
require "custom.utils.options"
-- require "custom.configs.statuscolumn"
