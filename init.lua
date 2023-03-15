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
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics,
  {
    underline = false,
    virtual_text = {
      spacing = 4,
      prefix = "",
    },
    signs = true,
    update_in_insert = false,
  }
)

autocmd("BufWritePre", {
--   pattern = "*.go",
  callback = function()
    vim.lsp.buf.format { async = false }
  end,
})

-- Run gofmt on save
vim.api.nvim_exec([[ autocmd BufWritePre *.go :silent! lua require('go.format').gofmt() ]], false)

-- Auto resize panes when resizing nvim window
autocmd("VimResized", {
  pattern = "*",
  command = "tabdo wincmd =",
})
