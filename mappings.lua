---@type MappingsTable
local M = {}

-- <C> -> Ctrl
-- <leader> -> Space
-- <A> -> alt
-- <S> -> shift
-- <M> -> meta (cmd key on mac)
-- <D> -> super (windows key on windows)
-- <kPoint> -> Keypad Point (.)
-- <kEqual> -> Keypad Equal (=)
-- <kPlus> -> Keypad Plus (+)
-- <kMinus> -> Keypad Minus (-)

M.disabled = {
  n = {
    ["<leader>b"] = "",
  },
}

M.rest = {
  n = {
    ["<leader>rs"] = {
      function()
        require("rest-nvim").run()
      end,
      "󰖟 RestNvim Run",
    },
  },
}

M.comment = {
  plugin = true,

  -- toggle comment in both modesx
  n = {
    ["<A-/>"] = {
      function()
        require("Comment.api").toggle.linewise.current()
      end,
      "  Toggle comment",
    },
    ["<D-/>"] = {
      function()
        require("Comment.api").toggle.linewise.current()
      end,
      "  Toggle comment",
    },
  },

  v = {
    ["<A-/>"] = {
      "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
      "  Toggle comment",
    },
  },
}

M.accelerated_jk = {
  n = {
    k = { "<Plug>(accelerated_jk_gk)", " Accelerated up movement" },
    j = { "<Plug>(accelerated_jk_gj)", " Accelerated down movement" },
  },
}

M.text = {
  i = {
    -- Move line up and down
    ["<C-Up>"] = { "<cmd> :m-2<CR>", " Move up" },
    ["<C-Down>"] = { "<cmd> :m+<CR>", " Move down" },
    -- Navigate
    ["<A-Left>"] = { "<ESC>I", " Move to beginning of line" },
    ["<A-Right>"] = { "<ESC>A", " Move to end of line" },
    ["<A-d>"] = { "<ESC>diw", " Delete word" },
  },

  n = {
    ["<leader>cc"] = { "<cmd> CCToggle <CR>", " Toggle ColorColumn display" },
    -- Navigate
    ["<A-Left>"] = { "<ESC>_", "󰜲 Move to beginning of line" },
    ["<A-Right>"] = { "<ESC>$", "󰜵 Move to end of line" },
    ["<F3>"] = { "N", " Next" },
    ["<S-F3>"] = { "n", " Previous" },
    -- Operations
    ["<C-z>"] = { "<cmd>2u<CR>", "󰕌 Undo" },
    ["<C-r>"] = { "<cmd>redo<CR>", "󰑎 Redo" },
    ["<C-x>"] = { "dd", "󰆐 Cut" },
    ["<C-v>"] = { "p", "󰆒 Paste" },
    ["<C-c>"] = { "y", " Copy" },
    ["<A-d>"] = { "viw", " Select word" },
    ["<leader>d"] = { "viwxi", " Delete word" },
    -- Move line up and down
    ["<C-Up>"] = { "<cmd> :m-2<CR>", "󰜸 Move line up" },
    ["<C-Down>"] = { "<cmd> :m+<CR>", "󰜯 Move line down" },
    -- Renamer
    ["<C-R>"] = { "<cmd>:MurenFresh<CR>", "󱝪 Toggle Search" },
    ["<leader>rn"] = { "<cmd> :lua require('renamer').rename()<CR>", "󰑕 Rename" },
    ["<leader>re"] = {
      function()
        return ":IncRename " .. vim.fn.expand "<cword>"
      end,
      -- ":IncRename "
      "󰑕 Rename",
      opts = { expr = true },
    },
    ["<leader>it"] = {
      function()
        require("nvim-toggler").toggle()
      end,
      "󰌁 Invert text",
    },
    --
    ["<Esc>"] = { ":noh <CR>", " Clear highlights", opts = { silent = true } },

    ["<leader>bc"] = {
      function()
        require("nvim-biscuits").toggle_biscuits()
      end,
      "󰆘 Toggle biscuits",
    },
    ["<Leader>bb"] = {
      "<cmd>:Bionic<CR>",
      "󱄽 Toggle Bionic",
    },
    ["<leader>fi"] = { " <cmd>:GoImport<CR>", " Format imports", opts = { silent = true } },
    ["<leader>fm"] = {
      function()
        vim.lsp.buf.format { async = true }
      end,
      " Lsp formatting",
    },
  },

  v = {
    ["<C-Up>"] = { ":m'<-2<CR>gv=gv", "󰜸 Move selection up", opts = { silent = true } },
    ["<C-Down>"] = { ":m'>+1<CR>gv=gv", "󰜯 Move selection down", opts = { silent = true } },
    ["<Home>"] = { "gg", "Home" },
    ["<End>"] = { "G", "End" },
    -- Indent backward/forward:
    ["<"] = { "<gv", " Ident backward", opts = { silent = false } },
    [">"] = { ">gv", " Ident forward", opts = { silent = false } },
  },

  c = {
    -- Autocomplete for brackets:
    ["("] = { "()<left>", "Auto complete (", opts = { silent = false } },
    ["<"] = { "<><left>", "Auto complete <", opts = { silent = false } },
    ['"'] = { '""<left>', [[Auto complete "]], opts = { silent = false } },
    ["'"] = { "''<left>", "Auto complete '", opts = { silent = false } },
  },
}

M.general = {
  n = {
    [";"] = { ":", "󰘳 Enter command mode", opts = { nowait = true } },
    ["<leader>q"] = { "<cmd> qa! <CR>", "󰗼 Exit" },

    -- Keep cursor in the center line when C-D / C-U
    ["<C-d>"] = { "<C-d>zz", " Scroll down", opts = { silent = true } },
    ["<C-u>"] = { "<C-u>zz", " Scroll up", opts = { silent = true } },

    -- Split
    ["<C-h>"] = { "<cmd>vs <CR>", "󰤼 Vertical split", opts = { nowait = true } },
    ["<C-y>"] = { "<cmd>sp <CR>", "󰤻 Horizontal split", opts = { nowait = true } },

    ["<leader>cs"] = { "<cmd>SymbolsOutline<cr>", " Symbols Outline" },
    ["<leader>tr"] = {
      function()
        require("base46").toggle_transparency()
      end,
      "󰂵 Toggle transparency",
    },
    ["<leader>w"] = {
      function()
        require("nvchad_ui.tabufline").close_buffer()
      end,
      "Close buffer",
    },
  },
}

M.diagnostics = {
  n = {
    ["<leader>t"] = { "<cmd>TroubleToggle<cr>", "󰔫 Toggle warnings" },
    ["<leader>td"] = { "<cmd>TodoTrouble keywords=TODO,FIX,FIXME,BUG,TEST,NOTE<cr>", " Todo/Fix/Fixme" },
    ["<leader>el"] = { "<cmd>ErrorLensToggle<cr>", "󱇭 Toggle error lens" },
    ["<leader>ft"] = { "<cmd>:TodoTelescope<cr>", " Telescope TODO" },
    ["<Leader>ls"] = {
      function()
        require("lsp_lines").toggle()
      end,
      "Toggle lsp_lines",
    },
  },
}

M.minimap = {
  n = {
    ["<leader>mm"] = {
      function()
        require("codewindow").toggle_minimap()
      end,
      " Toggle minimap",
    },
  },
}

M.node = {
  n = {
    ["<leader>ns"] = {
      "<cmd> lua require('package-info').show() <CR>",
      "󰎙 Show package info",
    },
    ["<leader>nd"] = {
      "<cmd> lua require('package-info').delete() <CR>",
      "󰎙 Delete package",
    },
    ["<leader>np"] = {
      "<cmd> lua require('package-info').change_version() <CR>",
      "󰎙 install package",
    },
  },
}

M.treesitter = {
  n = {
    ["<leader>cu"] = { "<cmd> TSCaptureUnderCursor <CR>", " Find media" },
  },
}

M.debug = {
  n = {
    ["<leader>tt"] = { "<cmd> :GoBreakToggle<CR>", " Toggle breakpoint" },
    ["<F5>"] = { "<cmd> :DapContinue <CR>", " Continue" },
    ["<F10>"] = { "<cmd> :DapStepOver <CR>", " Step over" },
    ["<F11>"] = { "<cmd> :DapStepInto <CR>", " Step into" },
    ["<F12>"] = { "<cmd> :DapStepOut <CR>", " Step out" },
  },
}

M.git = {
  n = {
    ["<leader>gc"] = { "<cmd>Telescope git_commits<CR>", "  Git commits" },
    ["<leader>gb"] = { "<cmd>Telescope git_branches<CR>", "  Git branches" },
    ["<leader>gs"] = { "<cmd>Telescope git_status<CR>", "  Git status" },
    ["<leader>gg"] = { "<cmd>LazyGit<CR>", "  LazyGit" },
    ["<leader>gl"] = {
      function()
        package.loaded.gitsigns.blame_line()
      end,
      "  Blame line",
    },
    ["<leader>gvd"] = { "<cmd> DiffviewOpen<CR>", "  Show git diff" },
    ["<leader>gvf"] = { "<cmd> DiffviewFileHistory %<CR>", "  Show file history" },
    ["<leader>gvp"] = { "<cmd> DiffviewOpen --cached<CR>", "  Show staged diffs" },
    ["<leader>gvr"] = { "<cmd> DiffviewRefresh<CR>", "  Refresh diff view" },
    ["<leader>gvc"] = { "<cmd> DiffviewClose<CR>", "  Close diff view" },
  },
}

M.telescope = {
  n = {
    ["<leader>fk"] = { "<cmd>Telescope keymaps<CR>", " Find keymaps" },
    ["<leader>fs"] = { "<cmd>Telescope lsp_document_symbols<CR>", " Find document symbols" },
    ["<leader>fr"] = { "<cmd>Telescope frecency<CR>", " Recent files" },
    ["<leader>fu"] = { "<cmd>Telescope undo<CR>", " Undo tree" },
    ["<leader>fz"] = {
      "<cmd>Telescope current_buffer_fuzzy_find fuzzy=false case_mode=ignore_case<CR>",
      " Find current file",
    },
  },
}

M.tabufline = {
  plugin = true,

  n = {
    -- cycle through buffers
    ["<tab>"] = {
      function()
        require("nvchad_ui.tabufline").tabuflineNext()
      end,
      " Goto next buffer",
    },

    ["<S-tab>"] = {
      function()
        require("nvchad_ui.tabufline").tabuflinePrev()
      end,
      " Goto prev buffer",
    },

    -- close buffer + hide terminal buffer
    ["<C-x>"] = {
      function()
        require("nvchad_ui.tabufline").close_buffer()
      end,
      " Close buffer",
    },
  },
}

M.test = {
  n = {
    ["<leader>nt"] = {
      function()
        require("neotest").run.run(vim.fn.expand "%")
      end,
      "󰤑 Run neotest",
    },
  },
}

M.nvimtree = {
  n = {
    ["<C-b>"] = { "<cmd> NvimTreeToggle <CR>", "󰔱 Toggle nvimtree" },
  },
  i = {
    ["<C-b>"] = { "<cmd> NvimTreeToggle <CR>", "󰔱 Toggle nvimtree" },
  },
}

M.session = {
  n = {
    ["<leader>sl"] = {
      function()
        require("nvim-possession").list()
      end,
      " List session",
    },
    ["<leader>sn"] = {
      function()
        require("nvim-possession").new()
      end,
      " New session",
    },
    ["<leader>sd"] = {
      function()
        require("nvim-possession").delete()
      end,
      " Delete session",
    },
  },
}

M.hop = {
  n = {
    ["<leader><leader>w"] = { "<cmd> HopWord <CR>", "󰸱 Hint all words" },
    ["<leader><leader>l"] = { "<cmd> HopLine <CR>", "󰸱 Hint line" },
    ["<leader>hl"] = { ":HopLineStart<CR>", "󰕭 Hint Columns" },
    ["<leader>hw"] = { ":HopWordCurrentLine<CR>", "󰗉 Hint Words" },
  },
}

M.searchbox = {
  n = {
    ["<C-F>"] = { "<cmd> SearchBoxMatchAll clear_matches=true<CR>", "󱘟 Search matching all" },
    ["<A-R>"] = { "<cmd> SearchBoxReplace confirm=menu<CR>", " Replace" },
  },
}

M.bookmark = {
  n = {
    ["<leader>ba"] = { "<cmd> BookmarkToggle<CR>", "󰃅 Add bookmark" },
    ["<leader>bn"] = { "<cmd> BookmarkNext<CR>", "󰮰 Next bookmark" },
    ["<leader>bp"] = { "<cmd> BookmarkPrev<CR>", "󰮲 Prev bookmark" },
    ["<leader>bc"] = { "<cmd> BookmarkClear<CR>", "󰃢 Clear bookmark" },
    ["<leader>bm"] = { "<cmd>Telescope vim_bookmarks all<CR>", " Bookmark Menu" },
  },
}

-- M.smartsplits = {
-- 	n = {
-- 		["<A-Up>"] = { "<cmd>lua require('smart-splits').resize_up()<CR>", "Resize window up" },
-- 		["<A-Down>"] = { "<cmd>lua require('smart-splits').resize_down()<CR>", "Resize window down" },
-- 		["<A-Left>"] = { "<cmd>lua require('smart-splits').resize_left()<CR>", "Resize window left" },
-- 		["<A-Right>"] = { "<cmd>lua require('smart-splits').resize_right()<CR>", "Resize window right" },
-- 		["<leader>h"] = { "<cmd>lua require('smart-splits').swap_buf_left()<CR>", "Swap buffer left" },
-- 		["<leader>j"] = { "<cmd>lua require('smart-splits').swap_buf_down()<CR>", "Swap buffer down" },
-- 		["<leader>k"] = { "<cmd>lua require('smart-splits').swap_buf_up()<CR>", "Swap buffer up" },
-- 		["<<leader>l"] = { "<cmd>lua require('smart-splits').swap_buf_right()<CR>", "Swap buffer right" },
-- 	},
-- }

-- M.navigator = {
--   n = {
--     ["<C-h>"] = { "<cmd> NavigatorLeft <CR>", "navigate left" },
--     ["<C-j>"] = { "<cmd> NavigatorDown <CR>", "navigate down" },
--     ["<C-k>"] = { "<cmd> NavigatorUp <CR>", "navigate up" },
--     ["<C-l>"] = { "<cmd> NavigatorRight <CR>", "navigate right" },
--   },
--   t = {
--     ["<C-h>"] = { "<cmd> NavigatorLeft <CR>", "navigate left" },
--     ["<C-j>"] = { "<cmd> NavigatorDown <CR>", "navigate down" },
--     ["<C-k>"] = { "<cmd> NavigatorUp <CR>", "navigate up" },
--     ["<C-l>"] = { "<cmd> NavigatorRight <CR>", "navigate right" },
--   },
-- }

M.lspsaga = {
  n = {
    ["<leader>."] = { "<cmd>Lspsaga code_action<CR>", "󰅱 Code Action" },
    ["gh"] = {
      function()
        vim.cmd "Lspsaga lsp_finder"
      end,
      "Go to definition",
    },
    ["gd"] = {
      "<cmd>Lspsaga goto_definition<cr>",
      "Go to definition",
    },
    ["<leader>lp"] = {
      "<cmd>Lspsaga peek_definition<cr>",
      "Peek definition",
    },
    ["<leader>k"] = {
      "<Cmd>Lspsaga hover_doc<cr>",
      "Hover lsp",
    },
    ["<leader>o"] = { "<cmd>Lspsaga outline<CR>", " Show Outline" },
    --  LSP
    ["gr"] = { "<cmd>Telescope lsp_references<CR>", " Lsp references" },
    ["[d"] = { "<cmd>Lspsaga diagnostic_jump_prev<CR>", " Prev Diagnostic" },
    ["]d"] = { "<cmd>Lspsaga diagnostic_jump_next<CR>", " Next Diagnostic" },
    ["<leader>lq"] = {
      function()
        vim.diagnostic.setloclist()
      end,
      "󰁨 Lsp Quickfix",
    },
  },
}

M.nvterm = {
  t = {
    -- toggle in terminal mode
    ["<leader>h"] = {
      function()
        require("nvterm.terminal").toggle "horizontal"
      end,
      " Toggle horizontal term",
    },
    ["C-c"] = { [[<C-\><C-c>]], "󰜺 Send SigInt" },
  },

  n = {
    -- toggle in normal mode
    ["<leader>h"] = {
      function()
        require("nvterm.terminal").toggle "horizontal"
      end,
      " Toggle horizontal term",
    },
  },
}

M.harpoon = {
  n = {
    ["<leader>ha"] = {
      function()
        require("harpoon.mark").add_file()
      end,
      "󱡁 Harpoon Add file",
    },
    ["<leader>ta"] = { "<cmd>Telescope harpoon marks<CR>", "󱡀 Toggle quick menu" },
    ["<leader>hb"] = {
      function()
        require("harpoon.ui").toggle_quick_menu()
      end,
      "󱠿 Harpoon Menu",
    },
    ["<leader>1"] = {
      function()
        require("harpoon.ui").nav_file(1)
      end,
      "󱪼 Navigate to file 1",
    },
    ["<leader>2"] = {
      function()
        require("harpoon.ui").nav_file(2)
      end,
      "󱪽 Navigate to file 2",
    },
    ["<leader>3"] = {
      function()
        require("harpoon.ui").nav_file(3)
      end,
      "󱪾 Navigate to file 3",
    },
    ["<leader>4"] = {
      function()
        require("harpoon.ui").nav_file(4)
      end,
      "󱪿 Navigate to file 4",
    },
  },
}

M.lspconfig = {
  n = {

    ["<leader>l"] = {
      function()
        require("lsp_lines").toggle()
      end,
      "Toggle lsp_lines",
    },
  },
}

return M
