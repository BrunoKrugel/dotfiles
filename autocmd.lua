local autocmd = vim.api.nvim_create_autocmd
local settings = require("custom.chadrc").settings

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

autocmd("FileType", {
  pattern = { "NvimTree" },
  callback = function(args)
    vim.api.nvim_create_autocmd("VimLeavePre", {
      callback = function()
        vim.api.nvim_buf_delete(args.buf, { force = true })
        return true
      end,
    })
  end,
})

autocmd("BufEnter", {
  nested = true,
  callback = function()
    local api = require('nvim-tree.api')
    if #vim.api.nvim_list_wins() == 1 and api.tree.is_tree_buf() then
      vim.defer_fn(function()
        api.tree.toggle({find_file = true, focus = true})
        api.tree.toggle({find_file = true, focus = true})
        vim.cmd("wincmd p")
      end, 0)
    end
  end
})

local prefetch = vim.api.nvim_create_augroup("prefetch", { clear = true })
autocmd("BufRead", {
  group = prefetch,
  pattern = "*.go",
  callback = function()
    require("cmp_tabnine"):prefetch(vim.fn.expand "%:p")
  end,
})

autocmd({ "FileType", "BufWinEnter" }, {
  callback = function()
    local ft_ignore = {
      "man",
      "help",
      "neo-tree",
      "starter",
      "TelescopePrompt",
      "Trouble",
      "NvimTree",
    }

    local b = vim.api.nvim_get_current_buf()
    local f = vim.api.nvim_buf_get_option(b, "filetype")
    for _, e in ipairs(ft_ignore) do
      if f == e then
        vim.api.nvim_win_set_option(0, "statuscolumn", "")
        return
      end
    end
  end,
})

-- Disable colorcolumn in blacklisted filetypes
autocmd({ "FileType" }, {
  callback = function()
    if vim.g.ccenable then
      vim.opt_local.cc = (vim.tbl_contains(settings.blacklist, vim.bo.ft) and "0" or settings.cc_size)
    end
  end,
})

-- Disable scrolloff in blacklisted filetypes
autocmd({ "BufEnter" }, {
  callback = function()
    vim.o.scrolloff = (vim.tbl_contains(settings.blacklist, vim.bo.ft) and 0 or settings.so_size)
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

-- Enable this to Auto format on save, bu it will mess with undo history
-- autocmd("BufWritePre", {
--   pattern = { "*.js", "*.java", "*.lua" },
--   callback = function()
--     vim.lsp.buf.format { async = false }
--   end,
-- })
