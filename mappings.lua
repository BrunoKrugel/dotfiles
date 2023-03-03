local M = {}

M.accelerated_jk = {
    n = {
        j = { "<Plug>(accelerated_jk_gj)", "accelerated gj movement" },
        k = { "<Plug>(accelerated_jk_gk)", "accelerated gk movement" },
    },
}
  
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
  
M.general = {
    i = {
    -- Move line up and down
        ["<C-Up>"] = { "<cmd> :m-2<CR>", "move up" },
        ["<C-Down>"] = { "<cmd> :m+<CR>", "move up" },
    },

    n = {
        -- Toggle blame line
        ["<leader>bl"] = {"<cmd> :ToggleBlameLine <CR>", "toggle blame line" },
        ["<leader>g"] = { "<cmd> :GoDef <CR>", "Go to definition" },
        ["<leader>t"] = { "<cmd>TroubleToggle<cr>" },
    },
}

M.Telescope = {
	n = {
		["<leader>ft"] = { ":TodoTelescope<cr>", "   Open Todo Telescope" },
        ["<leader>fs"] = { "<cmd> Telescope lsp_document_symbols symbol_width=50 <CR>", "lsp document symbols" },
	},
}

M.nvterm = {
    t = {
       -- toggle in terminal mode
       ["<leader>h"] = {
          function()
             require("nvterm.terminal").toggle "horizontal"
          end,
          "   toggle horizontal term",
       },
    },
 
    n = {
       -- toggle in normal mode
       ["<leader>h"] = {
          function()
             require("nvterm.terminal").toggle "horizontal"
          end,
          "   toggle horizontal term",
       },
    },
 }

return M