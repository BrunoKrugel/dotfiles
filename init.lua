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
  texthl = "NeotestAdapterName",
  linehl = "",
  numhl = "",
})

require "custom.autocmd"
require "custom.usrcmd"
require "custom.neovide"
require "custom.options"
