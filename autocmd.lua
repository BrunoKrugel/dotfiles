local autocmd = vim.api.nvim_create_autocmd

-- Change cursor color on mode change
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

-- Inlay hints
-- vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
-- vim.api.nvim_create_autocmd("LspAttach", {
--   group = "LspAttach_inlayhints",
--   callback = function(args)
--     if not (args.data and args.data.client_id) then
--       return
--     end

--     local bufnr = args.buf
--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--     require("lsp-inlayhints").on_attach(client, bufnr)
--   end,
-- })

-- Fix semantic tokens for lsp
autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    client.server_capabilities.semanticTokensProvider = nil
  end,
})

-- Auto Command for removing scrolloff for certain filetypes
autocmd({ "BufEnter" }, {
  callback = function ()
    vim.o.scrolloff = (
      vim.bo.filetype == "NvimTree" or
      vim.bo.filetype == "nvdash"   or
      vim.bo.filetype == "terminal")
      and 0 or 10
  end
})

-- the same as autochdir but better for nvim-tree and other plugins.
--   autocmd("BufEnter", {
--     pattern = "*",
--     command = "silent! lcd %:p:h",
--   })

-- Auto format on save (mess with undo history)
-- autocmd("BufWritePre", {
--   pattern = { "*.js", "*.java", "*.lua" },
--   callback = function()
--     vim.lsp.buf.format { async = false }
--   end,
-- })

-- Load highlights on save
autocmd("BufWritePost", {
  pattern = "*.lua",
  callback = function()
    require('base46').load_all_highlights()
  end,
})

-- Highlight yanked text
-- autocmd("TextYankPost", {
--   pattern = "*",
--   callback = function()
--     vim.highlight.on_yank {
--       higroup = "IncSearch",
--       timeout = 100,
--     }
--   end,
-- })
