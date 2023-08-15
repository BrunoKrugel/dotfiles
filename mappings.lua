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

M.folder = {
  n = {
    ["<leader>a"] = {
      function()
        require("fold-cycle").toggle_all()
      end,
      "󰴋 Toggle folder",
    },
    ["<leader>p"] = {
      function()
        require("fold-preview").toggle_preview()
      end,
      "󱞊 Fold preview",
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

M.development = {
  n = {
    ["<leader>it"] = {
      function()
        require("nvim-toggler").toggle()
      end,
      "󰌁 Invert text",
    },
    ["<leader>fm"] = {
      function()
        vim.lsp.buf.format { async = true }
      end,
      " Lsp formatting",
    },
    ["<leader>bi"] = {
      function()
        require("nvim-biscuits").toggle_biscuits()
      end,
      "󰆘 Toggle context",
    },
    ["<A-p>"] = { "<cmd>Colortils picker<CR>", " Delete word" },
  },
}

M.text = {
  i = {
    -- Move line up and down
    -- ["<C-Up>"] = { "<cmd> :m-2<CR>", "󰜸 Move line up" },
    ["<C-Up>"] = { "<cmd>m .-2<CR>==", "󰜸 Move line up" },

    -- ["<C-Down>"] = { "<cmd> :m+<CR>", "󰜯 Move line down" },
    ["<C-Down>"] = { "<cmd>m .+1<CR>==", "󰜯 Move line down" },

    -- Navigate
    ["<A-Left>"] = { "<ESC>I", " Move to beginning of line" },
    ["<A-Right>"] = { "<ESC>A", " Move to end of line" },
    ["<A-d>"] = { "<ESC>diw", " Delete word" },
    ["<S-CR>"] = {
      function()
        vim.cmd "normal o"
      end,
      " New line",
    },
  },

  n = {
    ["<leader>cc"] = { "<cmd> ColorcolumnToggle <CR>", " Toggle ColorColumn display" },
    -- Navigate
    ["<C-Left>"] = { "<ESC>_", "󰜲 Move to beginning of line" },
    ["<C-Right>"] = { "<ESC>$", "󰜵 Move to end of line" },
    ["<C-a>"] = { "gg0vG", " Select all" },
    ["<F3>"] = { "n", " Next" },
    ["<S-F3>"] = { "N", " Previous" },
    -- Operations
    ["<C-z>"] = { "<cmd>u<CR>", "󰕌 Undo" },
    ["<C-r>"] = { "<cmd>redo<CR>", "󰑎 Redo" },
    ["<C-x>"] = { "x", "󰆐 Cut" },
    ["<C-v>"] = { "p", "󰆒 Paste" },
    ["<C-c>"] = { "y", " Copy" },
    ["<leader><leader>d"] = { "viw", " Select word" },
    ["<leader>d"] = { 'viw"_di', " Delete word" },
    ["<C-Up>"] = { "<cmd>m .-2<CR>==", "󰜸 Move line up" },
    ["<C-Down>"] = { "<cmd>m .+1<CR>==", "󰜯 Move line down" },
    -- Renamer
    ["<C-R>"] = { "<cmd>:MurenToggle<CR>", "󱝪 Toggle Search" },
    ["<leader>sp"] = { "<cmd>:TSJToggle<CR>", "󰯌 Toggle split/join" },
    ["<A-d>"] = { "<cmd>:MCstart<CR>", "Multi cursor" },
    ["<leader>ra"] = {
      function()
        require("nvchad.renamer").open()
      end,
      "󰑕 LSP rename",
    },
    ["<leader>rn"] = {
      function()
        return ":IncRename " .. vim.fn.expand "<cword>"
      end,
      -- ":IncRename "
      "󰑕 Rename",
      opts = { expr = true },
    },
    -- Quit
    ["<Esc>"] = {
      function()
        vim.cmd "noh"
        vim.cmd "Noice dismiss"
      end,
      " Clear highlights",
      opts = { silent = true },
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

    ["<C-Left>"] = { "<ESC>_", "󰜲 Move to beginning of line" },
    ["<C-Right>"] = { "<ESC>$", "󰜵 Move to end of line" },
  },

  c = {
    -- Autocomplete for brackets:
    ["("] = { "()<left>", "Auto complete (", opts = { silent = false } },
    ["<"] = { "<><left>", "Auto complete <", opts = { silent = false } },
    ['"'] = { '""<left>', [[Auto complete "]], opts = { silent = false } },
    ["'"] = { "''<left>", "Auto complete '", opts = { silent = false } },
  },
}

M.go = {
  n = {
    ["<leader>fi"] = { " <cmd>:GoImport<CR>", " Format imports", opts = { silent = true } },
    ["<leader>gif"] = { " <cmd>:GoIfErr<CR>", " Create If Err", opts = { silent = true } },
    ["<leader>gfs"] = { " <cmd>:GoFillStruct<CR>", " Fill struct", opts = { silent = true } },
    ["<leader>gcv"] = { " <cmd>:GoCoverage -p<CR>", " Show coverage", opts = { silent = true } },
    ["<leader>gt"] = { " <cmd>:GoAlt!<CR>", " Go to test", opts = { silent = true } },
    ["<leader>gca"] = { " <cmd>:GoCodeAction<CR>", " Code action", opts = { silent = true } },
    ["<leader>gca"] = { " <cmd>:GoCodeAction<CR>", " Code action", opts = { silent = true } },
    ["<leader>ghc"] = {
      function()
        require("hierarchy-tree-go").open()
      end,
      " Hierarchy Call",
    },
    ["<leader>gfo"] = {
      function()
        require("hierarchy-tree-go").incoming()
      end,
      " Hierarchy Outgoing",
    },
    ["<leader>gfi"] = {
      function()
        require("hierarchy-tree-go").outgoing()
      end,
      " Hierarchy Incoming",
    },
  },
}

M.window = {
  n = {
    ["<leader><leader>h"] = { "<cmd>vs <CR>", "󰤼 Vertical split", opts = { nowait = true } },
    ["<leader><leader>v"] = { "<cmd>sp <CR>", "󰤻 Horizontal split", opts = { nowait = true } },
  },
}

M.general = {
  n = {
    [";"] = { ":", "󰘳 Enter command mode", opts = { nowait = true } },
    ["<leader>q"] = { "<cmd>q<CR>", "󰗼 Close" },
    ["<leader>qq"] = { "<cmd>qa!<CR>", "󰗼 Exit" },
    ["<C-p>"] = { "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", "󰘳 Find files" },

    -- Keep cursor in the center line when C-D / C-U
    ["<C-d>"] = { "<C-d>zz", " Scroll down", opts = { silent = true } },
    ["<C-u>"] = { "<C-u>zz", " Scroll up", opts = { silent = true } },

    ["<leader>cs"] = { "<cmd>SymbolsOutline<cr>", " Symbols Outline" },
    ["<leader>tr"] = {
      function()
        require("base46").toggle_transparency()
      end,
      "󰂵 Toggle transparency",
    },
    ["<leader>w"] = {
      function()
        require("nvchad.tabufline").close_buffer()
      end,
      " Close buffer",
    },
  },
}

M.diagnostics = {
  n = {
    ["<leader>t"] = { "<cmd>TroubleToggle<cr>", "󰔫 Toggle warnings" },
    ["<leader>td"] = { "<cmd>TodoTrouble keywords=TODO,FIX,FIXME,BUG,TEST,NOTE<cr>", " Todo/Fix/Fixme" },
    ["<leader>el"] = { "<cmd>ErrorLensToggle<cr>", "󱇭 Toggle error lens" },
    ["<leader>ft"] = { "<cmd>TodoTelescope<cr>", " Telescope TODO" },
    ["<Leader>ll"] = {
      function()
        require("lsp_lines").toggle()
      end,
      " Toggle lsp_lines",
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
      function()
        require("package-info").show()
      end,
      "󰎙 Show package info",
    },
    ["<leader>up"] = {
      function()
        require("package-info").update()
      end,
      "󰎙 Update package",
    },
    ["<leader>nd"] = {
      function()
        require("package-info").delete()
      end,
      "󰎙 Delete package",
    },
    ["<leader>np"] = {
      function()
        require("package-info").change_version()
      end,
      "󰎙 Install package",
    },
    ["<leader>jc"] = {
      function()
        require("nvim-js-actions").js_arrow_fn.toggle()
      end,
      "󰎙 Toggle arrow",
    },
  },
}

M.treesitter = {
  n = {
    ["<leader>cu"] = { "<cmd>TSCaptureUnderCursor <CR>", " Find highlight" },
    ["<leader>to"] = {
      function()
        require("treesj").toggle()
      end,
      "󱓡 Toggle split/join",
    },
  },
}

M.debug = {
  n = {
    ["<leader>tt"] = { "<cmd>GoBreakToggle<CR>", " Toggle breakpoint" },
    ["<F5>"] = { "<cmd>DapContinue <CR>", " Continue" },
    ["<F10>"] = { "<cmd>DapStepOver <CR>", " Step over" },
    ["<F11>"] = { "<cmd>DapStepInto <CR>", " Step into" },
    ["<F9>"] = { "<cmd>DapStepOut <CR>", " Step out" },
    ["<leader><leader>p"] = {
      function()
        require("debugprint").debugprint()
      end,
      " Step out",
    },
  },
}

M.git = {
  n = {
    ["<leader>gc"] = { "<cmd>Telescope git_commits<CR>", "  Git commits" },
    ["<leader>gb"] = { "<cmd>Telescope git_branches<CR>", "  Git branches" },
    ["<leader>gs"] = { "<cmd>Telescope git_status<CR>", "  Git status" },
    ["<leader>lg"] = { "<cmd>LazyGit<CR>", "  LazyGit" },
    ["<leader>gl"] = { "<cmd>GitBlameToggle<CR>", "  Blame line" },
    ["<leader>gtb"] = { "<cmd>ToggleBlame<CR>", "  Blame line" },
    ["<leader>gvd"] = { "<cmd> DiffviewOpen<CR>", "  Show git diff" },
    ["<leader>gvf"] = { "<cmd> DiffviewFileHistory %<CR>", "  Show file history" },
    ["<leader>gvp"] = { "<cmd> DiffviewOpen --cached<CR>", "  Show staged diffs" },
    ["<leader>gvr"] = { "<cmd> DiffviewRefresh<CR>", "  Refresh diff view" },
    ["<leader>gvc"] = { "<cmd> DiffviewClose<CR>", "  Close diff view" },
    ["<Leader>gcb"] = { "<cmd>GitConflictChooseBoth<CR>", "Choose both" },
    ["<Leader>gcn"] = { "<cmd>GitConflictNextConflict<CR>", "Move to next conflict" },
    ["<Leader>gco"] = { "<cmd>GitConflictChooseOurs<CR>", "Choose ours" },
    ["<Leader>gcp"] = { "<cmd>GitConflictPrevConflict<CR>", "Move to prev conflict" },
    ["<Leader>gct"] = { "<cmd>GitConflictChooseTheirs<CR>", "Choose theirs" },
  },
}

M.telescope = {
  n = {
    ["<leader>li"] = { "<cmd>Telescope highlights<CR>", "Highlights" },
    ["<leader>fk"] = { "<cmd>Telescope keymaps<CR>", " Find keymaps" },
    ["<leader>fs"] = { "<cmd>Telescope lsp_document_symbols<CR>", " Find document symbols" },
    ["<leader>fr"] = { "<cmd>Telescope frecency<CR>", " Recent files" },
    ["<leader>fu"] = { "<cmd>Telescope undo<CR>", " Undo tree" },
    ["<leader>fg"] = { "<cmd>Telescope ast_grep<CR>", " Structural Search" },
    ["<leader>fre"] = {
      function()
        require("telescope").extensions.refactoring.refactors()
      end,
      " Structural Search",
    },
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
        require("nvchad.tabufline").tabuflineNext()
      end,
      " Goto next buffer",
    },

    ["<S-tab>"] = {
      function()
        require("nvchad.tabufline").tabuflinePrev()
      end,
      " Goto prev buffer",
    },

    -- close buffer + hide terminal buffer
    ["<C-x>"] = {
      function()
        require("nvchad.tabufline").close_buffer()
      end,
      " Close buffer",
    },
  },
}

M.docker = {
  n = {
    ["<leader>ld"] = { "<cmd> LazyDocker <CR>", "󰡨 Open LazyDocker" },
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
    ["<leader>ss"] = {
      function()
        require("auto-session.session-lens").search_session()
      end,
      "󰆓 List session",
    },
    ["<leader>sd"] = { "<cmd>SessionDelete<CR>", "󱙃 Delete Session" },
  },
}

M.hop = {
  n = {
    ["<leader><leader>w"] = { "<cmd> HopWord <CR>", "󰸱 Hint all words" },
    ["<leader><leader>t"] = {
      function()
        require("tsht").move { side = "start" }
      end,
      " Hint Tree",
    },
    ["<leader><leader>c"] = { "<cmd> HopLineStart<CR>", "󰕭 Hint Columns" },
    ["<leader><leader>l"] = { "<cmd> HopWordCurrentLine<CR>", "󰗉 Hint Line" },
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

M.lspsaga = {
  n = {
    ["<leader>."] = { "<cmd>CodeActionMenu<CR>", "󰅱 Code Action" },
    ["gf"] = {
      function()
        vim.cmd "Lspsaga lsp_finder"
      end,
      " Go to definition",
    },
    ["gt"] = {
      "<cmd>Lspsaga goto_definition<cr>",
      " Go to definition",
    },
    ["<leader>lp"] = {
      "<cmd>Lspsaga peek_definition<cr>",
      " Peek definition",
    },
    ["<leader>k"] = {
      -- "<Cmd>Lspsaga hover_doc<cr>",
      function()
        require("pretty_hover").hover()
      end,
      "󱙼 Hover lsp",
    },
    ["<leader>o"] = { "<cmd>Lspsaga outline<CR>", " Show Outline" },
    --  LSP
    ["gr"] = { "<cmd>Telescope lsp_references<CR>", " Lsp references" },
    ["[d"] = { "<cmd>Lspsaga diagnostic_jump_prev<CR>", " Prev Diagnostic" },
    ["]d"] = { "<cmd>Lspsaga diagnostic_jump_next<CR>", " Next Diagnostic" },
    ["<leader>qf"] = {
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

M.portal = {
  n = {
    ["<leader>pj"] = { "<cmd>Portal jumplist backward<CR>", "󱡁 Portal Jumplist" },
    ["<leader>ph"] = {
      function()
        require("portal.builtin").harpoon.tunnel()
      end,
      "󱡁 Portal Harpoon",
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
    ["<leader><leader>n"] = { "<cmd> lua require('tsht').nodes() <CR>", " Select Node" },
    ["<F12>"] = { "<cmd>Glance references<CR>", "󰘐 References" },
  },
}

return M
