local autocmd = vim.api.nvim_create_autocmd

-- autocmd({ "ModeChanged" }, {
--   callback = function()
--     local current_mode = vim.fn.mode()
--     if current_mode == "n" then
--       vim.api.nvim_set_hl(0, "SmoothCursor", { fg = "#f8f8f2" })
--       -- vim.fn.sign_define("smoothcursor", { text = "" })
--     elseif current_mode == "v" then
--       vim.api.nvim_set_hl(0, "SmoothCursor", { fg = "#62d6e8" })
--       -- vim.fn.sign_define("smoothcursor", { text = "" })
--     elseif current_mode == "V" then
--       vim.api.nvim_set_hl(0, "SmoothCursor", { fg = "#62d6e8" })
--       -- vim.fn.sign_define("smoothcursor", { text = "" })
--     elseif current_mode == "�" then
--       vim.api.nvim_set_hl(0, "SmoothCursor", { fg = "#62d6e8" })
--       -- vim.fn.sign_define("smoothcursor", { text = "" })
--     elseif current_mode == "i" then
--       vim.api.nvim_set_hl(0, "SmoothCursor", { fg = "#50fa7b" })
--       -- vim.fn.sign_define("smoothcursor", { text = "" })
--     end
--   end,
-- })

-- Auto resize panes when resizing nvim window
autocmd("VimResized", {
  pattern = "*",
  command = "tabdo wincmd =",
})

autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    client.server_capabilities.semanticTokensProvider = nil
  end,
});

-- autocmd BufEnter * silent! lcd %:p:h
-- the same as autochdir but better for nvim-tree and other plugins.
--   autocmd("BufEnter", {
--     pattern = "*",
--     command = "silent! lcd %:p:h",
--   })

-- Auto format on save
-- autocmd("BufWritePre", {
--   pattern = { "*.js", "*.java", "*.lua" },
--   callback = function()
--     vim.lsp.buf.format { async = false }
--   end,
-- })

-- autocmd("BufWritePost", {
--   pattern = "*",
--   callback = function()
--     require('base46').load_all_highlights()
--   end,
-- })

-- autocmd("TextYankPost", {
--   pattern = "*",
--   callback = function()
--     vim.highlight.on_yank {
--       higroup = "IncSearch",
--       timeout = 100,
--     }
--   end,
-- })
