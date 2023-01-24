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
-- vim.keymap.set('i', '<C-j>', [[copilot#Accept('')]], { noremap = true, silent = true, expr = true })

autocmd("BufWritePre", {
--   pattern = "*.go",
  callback = function()
    vim.lsp.buf.format { async = false }
  end,
})

-- Run gofmt on save
vim.api.nvim_exec([[ autocmd BufWritePre *.go :silent! lua require('go.format').gofmt() ]], false)
