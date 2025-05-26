local M = {}

-- Check if there is a code action available at the cursor position
local function isCodeActionAvailable()
  local current_bufnr = vim.fn.bufnr()
  local params = {
    textDocument = vim.lsp.util.make_text_document_params(),
    context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics() },
  }

  local actions = vim.lsp.buf_request_sync(current_bufnr, "textDocument/codeAction", params, 1000)

  return actions and next(actions) ~= nil
end

M.folder = {
  n = {
    ["<leader>a"] = {
      function()
        local foldclosed = vim.fn.foldclosed(vim.fn.line ".")
        if foldclosed == -1 then
          vim.cmd "silent! normal! zc"
        else
          vim.cmd "silent! normal! zo"
        end
      end,
      "󰴋 Toggle folder",
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
      "<ESC><CMD>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
      "  Toggle comment",
    },
  },
}

M.development = {
  n = {
    ["<leader>i"] = {
      function()
        require("nvim-toggler").toggle()
      end,
      "󰌁 Invert text",
    },
    ["<leader>fm"] = {
      -- function()
      --   vim.lsp.buf.format { async = true }
      -- end,
      "<CMD>Format<CR>",
      " Lsp formatting",
    },
    ["K"] = {
      function()
        vim.lsp.buf.hover()
      end,
      "Hover",
    },
    ["gd"] = {
      function()
        vim.lsp.buf.definition()
      end,
      "󰑊 Go to definition",
    },
    ["gi"] = {
      function()
        vim.lsp.buf.implementation()
      end,
      "󰑊 Go to implementation",
    },
  },
}

M.text = {
  i = {
    -- Move line up and down
    ["<C-Up>"] = { "<CMD>m .-2<CR>==", "󰜸 Move line up" },
    ["<C-Down>"] = { "<CMD>m .+1<CR>==", "󰜯 Move line down" },

    -- Navigate
    ["<A-Left>"] = { "<ESC>I", " Move to beginning of line" },
    ["<A-Right>"] = { "<ESC>A", " Move to end of line" },
    ["<A-d>"] = { "<ESC>diw", " Delete word" },
  },

  n = {
    ["J"] = { "mzJ`z", "Join line while keeping the cursor in the same position" },
    -- ["<LeftRelease>"] = {"*ygv","Yank on mouse selection"},
    -- Navigate
    ["<C-Left>"] = { "<ESC>_", "󰜲 Move to beginning of line" },
    ["<C-Right>"] = { "<ESC>$", "󰜵 Move to end of line" },
    ["<F3>"] = { "nzzzv", " Next" },
    ["<S-F3>"] = { "Nzzzv", " Previous" },
    ["<N>"] = { "nzzzv", " Next" }, -- goto_diagnostic_hl('next')
    ["<n>"] = { "Nzzzv", " Previous" }, -- goto_diagnostic_hl('prev')
    -- Operations
    ["<leader><leader>p"] = { "printf('`[%s`]', getregtype()[0])", "Reselect last pasted area", expr = true },
    ["<leader><leader>d"] = { "viw", " Select word" },
    ["<leader>d"] = { 'viw"_di', " Delete word" },
    ["<C-Up>"] = { "<CMD>m .-2<CR>==", "󰜸 Move line up" },
    ["<C-Down>"] = { "<CMD>m .+1<CR>==", "󰜯 Move line down" },
    -- Renamer
    -- ["<C-R>"] = { "<CMD>:MurenToggle<CR>", "󱝪 Toggle Search" },
    ["<leader>sp"] = { "<CMD>:TSJToggle<CR>", "󰯌 Toggle split/join" },
    ["dd"] = {
      function()
        if vim.api.nvim_get_current_line():match "^%s*$" then
          return '"_dd'
        else
          return "dd"
        end
      end,
      "Smart dd",
    },
    ["<leader>rn"] = {
      function()
        return ":IncRename " .. vim.fn.expand "<cword>"
      end,
      -- ":IncRename "
      "󰑕 Rename",
      opts = { expr = true },
    },
  },

  v = {
    ["<C-Up>"] = { ":m'<-2<CR>gv=gv", "󰜸 Move selection up", opts = { silent = true } },
    ["<C-Down>"] = { ":m'>+1<CR>gv=gv", "󰜯 Move selection down", opts = { silent = true } },
    ["<Home>"] = { "gg", "Home" },
    ["<End>"] = { "G", "End" },
    ["y"] = { "y`]", "Yank and move to end" },
    -- Indent backward/forward:
    ["<"] = { "<gv", " Ident backward", opts = { silent = false } },
    [">"] = { ">gv", " Ident forward", opts = { silent = false } },

    ["<C-Left>"] = { "<ESC>_", "󰜲 Move to beginning of line" },
    ["<C-Right>"] = { "<ESC>$", "󰜵 Move to end of line" },
    ["$"] = {
      function()
        if vim.fn.mode() == "v" then
          return "$h"
        else
          return "$"
        end
      end,
      "End of line",
      opts = { expr = true },
    },
  },

  c = {
    -- Autocomplete for brackets:
    ["("] = { "()<left>", "Auto complete (", opts = { silent = false } },
    ["<"] = { "<><left>", "Auto complete <", opts = { silent = false } },
    ['"'] = { '""<left>', [[Auto complete "]], opts = { silent = false } },
    ["'"] = { "''<left>", "Auto complete '", opts = { silent = false } },
  },
}

M.window = {
  n = {
    ["<leader><leader>h"] = { "<CMD>vs <CR>", "󰤼 Vertical split", opts = { nowait = true } },
    ["<leader><leader>v"] = { "<CMD>sp <CR>", "󰤻 Horizontal split", opts = { nowait = true } },
  },
}

M.general = {
  n = {
    [";"] = {
      "<CMD>lua require('telescope.builtin').resume(require('telescope.themes').get_ivy({}))<CR>",
      "Resume telescope",
      opts = { nowait = true },
    },

    -- Keep cursor in the center line when C-D / C-U
    ["<C-d>"] = { "<C-d>zz", " Scroll down", opts = { silent = true } },
    ["<C-u>"] = { "<C-u>zz", " Scroll up", opts = { silent = true } },

    ["<leader>cs"] = { "<CMD>SymbolsOutline<CR>", " Symbols Outline" },
    ["<leader>tr"] = {
      function()
        require("base46").toggle_transparency()
      end,
      "󰂵 Toggle transparency",
    },
    ["<leader>w"] = {
      function()
        if vim.bo.buftype == "terminal" then
          vim.cmd ":q"
        else
          require("nvchad.tabufline").close_buffer()
        end
      end,
      " Close buffer",
    },
  },
}

M.diagnostics = {
  n = {
    ["<leader>t"] = { "<CMD>Trouble diagnostics toggle<CR>", "󰔫 Toggle warnings" },
    ["<leader>td"] = { "<CMD>Trouble qflist toggle<CR>", " Todo/Fix/Fixme" },
    ["<leader>el"] = { "<CMD>ErrorLensToggle<CR>", "󱇭 Toggle error lens" },
    ["<leader>ft"] = { "<CMD>TodoTelescope<CR>", " Telescope TODO" },
    -- ["<Leader>ll"] = {
    --   function()
    --     require("lsp_lines").toggle()
    --   end,
    --   " Toggle lsp_lines",
    -- },
  },
}

-- Go to breakpoints
-- map('n', ']b', breakpoint.next, 'Go to next breakpoint')
-- map('n', '[b', breakpoint.prev, 'Go to previous breakpoint')
M.debug = {
  n = {
    ["<leader>tt"] = { "<CMD>PBToggleBreakpoint<CR>", " Debug: Toggle breakpoint" },
    ["<F5>"] = { "<CMD>DapContinue <CR>", " Debug: Continue" },
    ["<F10>"] = { "<CMD>DapStepOver <CR>", " Debug: Step over" },
    ["<F11>"] = { "<CMD>DapStepInto <CR>", " Debug: Step into" },
    ["<F9>"] = { "<CMD>DapStepOut <CR>", " Debug: Step out" },
    ["<leader><leader>dr"] = {
      function()
        require("dap").repl.toggle()
      end,
      "Debug: Open REPL",
    },
  },
}

M.git = {
  n = {
    ["<leader>gc"] = { "<CMD>Telescope git_commits<CR>", "  Git commits" },
    ["<leader>gb"] = { "<CMD>Telescope git_branches<CR>", "  Git branches" },
    ["<leader>gs"] = { "<CMD>Telescope git_status<CR>", "  Git status" },
    ["<leader>gvd"] = { "<CMD> DiffviewOpen<CR>", "  Show git diff" },
    ["<leader>gvf"] = { "<CMD> DiffviewFileHistory %<CR>", "  Show file history" },
    ["<leader>gvp"] = { "<CMD> DiffviewOpen --cached<CR>", "  Show staged diffs" },
    ["<leader>gvr"] = { "<CMD> DiffviewRefresh<CR>", "  Refresh diff view" },
    ["<leader>gvc"] = { "<CMD> DiffviewClose<CR>", "  Close diff view" },
    ["<Leader>gcb"] = { "<CMD>GitConflictChooseBoth<CR>", "Choose both" },
    ["<Leader>gcn"] = { "<CMD>GitConflictNextConflict<CR>", "Move to next conflict" },
    ["<Leader>gco"] = { "<CMD>GitConflictChooseOurs<CR>", "Choose ours" },
    ["<Leader>gcp"] = { "<CMD>GitConflictPrevConflict<CR>", "Move to prev conflict" },
    ["<Leader>gct"] = { "<CMD>GitConflictChooseTheirs<CR>", "Choose theirs" },
  },
}

M.telescope = {
  n = {
    ["<leader>li"] = { "<CMD>Telescope highlights<CR>", "Highlights" },
    ["<leader>fk"] = { "<CMD>Telescope keymaps<CR>", " Find keymaps" },
    ["<leader>fs"] = { "<CMD>Telescope lsp_document_symbols<CR>", " Find document symbols" },
    ["<leader>fu"] = { "<CMD>Telescope undo<CR>", " Undo tree" },
    ["<leader>fa"] = {
      function()
        local builtin = require "telescope.builtin"
        -- ignore opened buffers if not in dashboard or directory
        if vim.fn.isdirectory(vim.fn.expand "%") == 1 or vim.bo.filetype == "nvdash" then
          builtin.find_files()
        else
          local function literalize(str)
            return str:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", function(c)
              return "%" .. c
            end)
          end

          local function get_open_buffers()
            local buffers = {}
            local len = 0
            local vim_fn = vim.fn
            local buflisted = vim_fn.buflisted

            for buffer = 1, vim_fn.bufnr "$" do
              if buflisted(buffer) == 1 then
                len = len + 1
                -- get relative name of buffer without leading slash
                buffers[len] = "^"
                  .. literalize(string.gsub(vim.api.nvim_buf_get_name(buffer), literalize(vim.uv.cwd()), ""):sub(2))
                  .. "$"
              end
            end

            return buffers
          end

          builtin.find_files {
            file_ignore_patterns = get_open_buffers(),
          }
        end
      end,
      "Find files",
    },
  },
}

M.tabufline = {
  plugin = true,

  n = {
    -- cycle through buffers
    ["<Tab>"] = {
      function()
        require("nvchad.tabufline").next()
      end,
      " Goto next buffer",
    },

    ["<S-Tab>"] = {
      function()
        require("nvchad.tabufline").prev()
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

    -- close all buffers
    ["<leader>bx"] = {
      function()
        local current_buf = vim.api.nvim_get_current_buf()
        local all_bufs = vim.api.nvim_list_bufs()

        for _, buf in ipairs(all_bufs) do
          if buf ~= current_buf and vim.fn.getbufinfo(buf)[1].changed ~= 1 then
            vim.api.nvim_buf_delete(buf, { force = true })
          end
        end
      end,
      " Close all but current buffer",
    },
  },
}

M.searchbox = {
  n = {
    ["<C-F>"] = { "<CMD> SearchBoxMatchAll clear_matches=true<CR>", "󱘟 Search matching all" },
    -- ["<A-R>"] = { "<CMD> SearchBoxReplace confirm=menu<CR>", " Replace" },
  },
}

M.nvterm = {
  t = {
    -- toggle in terminal mode
    ["<leader>h"] = {
      function()
        require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm", size = 0.2 }
      end,
      " Toggle horizontal term",
    },
    ["<Esc>"] = { [[<C-\><C-c>]], "󰜺 Send SigInt" },
    ["C-c"] = { [[<C-\><C-c>]], "󰜺 Send SigInt" },
  },

  n = {
    -- toggle in normal mode
    ["<leader>h"] = {
      function()
        require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm", size = 0.2 }
      end,
      " Toggle horizontal term",
    },
  },
}

M.lspconfig = {
  n = {
    ["<leader><leader>n"] = { "<CMD> lua require('tsht').nodes() <CR>", " Select Node" },
    ["<leader><leader>a"] = {
      function()
        if isCodeActionAvailable() then
          vim.lsp.buf.code_action()
        else
          if vim.bo.filetype == "go" then
            vim.cmd "GoCodeAction"
          end
        end
      end,
      "Go: Code Action",
    },
  },
}

return M
