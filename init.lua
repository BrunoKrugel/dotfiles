local opt = vim.opt
local autocmd = vim.api.nvim_create_autocmd

opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

opt.backup = false
opt.swapfile = false

opt.scrolloff = 10
opt.relativenumber = false
opt.wrap = false

-- autocmd("BufWritePre", {
--   pattern = "*.go",
--   callback = function()
--     vim.lsp.buf.format { async = false }
--   end,
-- })

-- Run gofmt on save
vim.api.nvim_exec([[ autocmd BufWritePre *.go :silent! lua require('go.format').gofmt() ]], false)
