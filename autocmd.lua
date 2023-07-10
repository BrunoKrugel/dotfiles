local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
autocmd("VimResized", {
  pattern = "*",
  command = "tabdo wincmd =",
})

-- Fix semantic tokens for lsp
autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    client.server_capabilities.semanticTokensProvider = nil
  end,
})

-- Update SideBar
autocmd({ "BufAdd", "BufDelete", "BufEnter", "TabEnter", "ModeChanged", "DiagnosticChanged" }, {
  callback = function()
    require("sidebar-nvim").update()
  end,
})

-- Enable it when changing highlights
-- autocmd("BufWritePost", {
--   pattern = "*.lua",
--   callback = function()
--     require("base46").load_all_highlights()
--   end,
-- })

-- Open NvimTree on startup
-- autocmd("VimEnter", {
--   callback = function()
--     require("nvim-tree.api").tree.open()
--   end,
-- })

-- Fix NvimTree not opening on startup when using session restore plugin
-- autocmd({ "BufEnter" }, {
--   pattern = "NvimTree*",
--   callback = function()
--     local api = require "nvim-tree.api"
--     local view = require "nvim-tree.view"
--     if not view.is_visible() then
--       api.tree.open()
--     end
--   end,
-- })

-- Enable this to Auto format on save, bu it will mess with undo history
-- autocmd("BufWritePre", {
--   pattern = { "*.js", "*.java", "*.lua" },
--   callback = function()
--     vim.lsp.buf.format { async = false }
--   end,
-- })
