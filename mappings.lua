---@type MappingsTable
local M = {}

M.accelerated_jk = {
  n = {
      j = { "<Plug>(accelerated_jk_gj)", "accelerated gj movement" },
      k = { "<Plug>(accelerated_jk_gk)", "accelerated gk movement" },
  },
}

M.general = {
  i = {
    -- Move line up and down
        ["<C-Up>"] = { "<cmd> :m-2<CR>", "move up" },
        ["<C-Down>"] = { "<cmd> :m+<CR>", "move up" },
        -- ["F2"] = { "<cmd> :lua require('renamer').rename()<CR>", "Rename" },
    },

  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["<leader>bl"] = {"<cmd> :ToggleBlameLine <CR>", "Toggle blame line" },
    ["<leader>g"] = { "<cmd> :GoDef <CR>", "Go to definition" },
    ["<leader>t"] = { "<cmd>TroubleToggle<cr>", "Toggle warnings" },
    ["<leader>vs"] = {"<cmd>:AskVisualStudioCode<CR>", "Ask Visual Code"},
    -- Move line up and down
    ["<C-Up>"] = { "<cmd> :m-2<CR>", "move up" },
    ["<C-Down>"] = { "<cmd> :m+<CR>", "move up" },
    -- Renamer
    ["<leader>rn"] = { "<cmd> :lua require('renamer').rename()<CR>", "Rename" },
    -- Debug in GO
    ["<leader>tt"] = { "<cmd> :GoBreakToggle<CR>", "Rename" },
  },
}

-- more keybinds!
M.hop = {
  n = {
    ["<leader><leader>w"] = { "<cmd> HopWord <CR>", "hint all words" },
    ["<leader><leader>l"] = { "<cmd> HopLine <CR>", "hint line" },
    ["<leader>hl"] = { ":HopLineStart<CR>" },
    ["<leader>hw"] = { ":HopWordCurrentLine<CR>" },
  },
}


M.searchbox = {
  n = {
    ["<leader><leader>f"] = { "<cmd> SearchBoxIncSearch<CR>", "Search first occurence" },
    ["<C-F>"] = { "<cmd> SearchBoxMatchAll clear_matches=true<CR>", "Search matching all" },
    ["<C-R>"] = { "<cmd> SearchBoxReplace confirm=menu<CR>", "Replace" },
  },
}

M.lspsaga = {
  n = {
   ["<leader>ca"] = { "<cmd>Lspsaga code_action<CR>", "Code Action" },
  --  ["gd"] = {
  --     function()
  --         vim.cmd("Lspsaga lsp_finder")
  --     end,
  --     "Go to definition",
  -- },
  -- ["<leader>lp"] = {
  --     "<cmd>Lspsaga peek_definition<cr>",
  --     "Peek definition",
  -- },
  -- ["<leader>k"] = {
  --     "<Cmd>Lspsaga hover_doc<cr>",
  --     "Hover lsp",
  -- },
  },
}
M.eft = {
  n = {
    f = { "<Plug>(eft-f)", "eft-f" },
    F = { "<Plug>(eft-F)", "eft-F" },
    t = { "<Plug>(eft-t)", "eft-t" },
    T = { "<Plug>(eft-T)", "eft-T" },
    [";"] = { "<Plug>(eft-repeat)", "eft-repeat" },
  },
}

return M
