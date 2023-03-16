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
    ["<leader>td"] = {"<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", "Todo/Fix/Fixme (Trouble)" },
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

M.git = {
	n = {
		["<leader>gc"] = { "<cmd>Telescope git_commits<CR>", "  git commits" },
		["<leader>gb"] = { "<cmd>Telescope git_branches<CR>", "  git branches" },
		["<leader>gs"] = { "<cmd>Telescope git_status<CR>", "  git status" },
		["<leader>gg"] = { "<cmd>LazyGit<CR>", "  LazyGit" },
	},
}

M.telescope = {
	n = {
		["<leader>fk"] = { "<cmd>Telescope keymaps<CR>", " find keymaps" },
		["<leader>fs"] = { "<cmd>Telescope lsp_document_symbols<CR>", " find document symbols" },
		["<leader>fr"] = { "<cmd>Telescope frecency<CR>", "Recent files" },
	},
}

M.tabufline = {
  plugin = true,

  n = {
    -- cycle through buffers
    ["<TAB>"] = {
      function()
        require("nvchad_ui.tabufline").tabuflineNext()
      end,
      "goto next buffer",
    },

    ["<S-Tab>"] = {
      function()
        require("nvchad_ui.tabufline").tabuflinePrev()
      end,
      "goto prev buffer",
    },

    -- close buffer + hide terminal buffer
    ["<C-x>"] = {
      function()
        require("nvchad_ui.tabufline").close_buffer()
      end,
      "close buffer",
    },
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

M.lspconfig = {
	i = {
		["<C-e>"] = {
			"copilot#Accept('<CR>')",
			"   copilot accept",
			opts = { expr = true, silent = true, replace_keycodes = false },
		},
	},
	n = {
		["<leader>o"] = { "<cmd>Lspsaga outline<CR>", "   Show Outline" },
		--  LSP
		["gr"] = { "<cmd>Telescope lsp_references<CR>", "  lsp references" },
		["[d"] = { "<cmd>Lspsaga diagnostic_jump_prev<CR>", "  Prev Diagnostic" },
		["]d"] = { "<cmd>Lspsaga diagnostic_jump_next<CR>", "  Next Diagnostic" },
		["<leader>la"] = { "<cmd>Lspsaga code_action<CR>", "   Show Code Actions" },
		["<leader>lf"] = { "<cmd>Lspsaga lsp_finder<CR>", "   Lsp Finder" },
		["<leader>lr"] = {
			function()
				require("nvchad_ui.renamer").open()
			end,
			"   Lsp Rename",
		},
		["<leader>lq"] = {
			function()
				vim.diagnostic.setloclist()
			end,
			"   Lsp Quickfix",
		},
	},
}

-- M.copilot = {
--   i = {
--     ["<C-j>"] = { 'copilot#Accept("<CR>")', "Accept completition", opts = { silent = true, expr = true } },
--   }
-- }

return M
