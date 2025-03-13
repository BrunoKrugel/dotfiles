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

-- Launch with the current word under the cursor as the search string
-- require('grug-far').grug_far({ prefills = { search = vim.fn.expand("<cword>") } })
-- Launch with the current file as a flag, which limits search/replace to it
-- require('grug-far').grug_far({ prefills = { flags = vim.fn.expand("%") } })

local function plugin_is_loaded(plugin)
  -- Checking with `require` and `pcall` will cause Lazy to load the plugin
  local plugins = require("lazy.core.config").plugins
  return not not plugins[plugin] and plugins[plugin]._.loaded
end

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

local diagnostic_ns = vim.api.nvim_create_namespace "hlyank"
local diagnostic_timer
local hl_cancel

local function goto_diagnostic_hl(dir)
  assert(dir == "prev" or dir == "next")
  local pos = vim.diagnostic["get_" .. dir]()
  if not pos then
    return
  end
  if diagnostic_timer then
    diagnostic_timer:close()
    hl_cancel()
  end
  vim.api.nvim_buf_set_extmark(0, diagnostic_ns, pos.lnum, pos.col, {
    end_row = pos.end_lnum,
    end_col = pos.end_col,
    hl_group = "Visual",
  })
  hl_cancel = function()
    diagnostic_timer = nil
    hl_cancel = nil
    pcall(vim.api.nvim_buf_clear_namespace, 0, diagnostic_ns, 0, -1)
  end
  diagnostic_timer = vim.defer_fn(hl_cancel, 500)
  vim.diagnostic["goto_" .. dir]()
end

-- local end_strings = {
--   ";",
--   ",",
--   ":",
--   ".",
--   ")",
--   "}",
--   "]",
--   "\\",
-- }
-- for _, char in ipairs(end_strings) do
--   vim.keymap.set("n", "<leader>" .. char, function()
--     func.put_at_end(char)
--   end, { desc = "Put " .. char .. " at the end of the line" })
-- end
local function put_at_beginning(chars)
  ---@diagnostic disable-next-line: param-type-mismatch
  local cline = vim.fn.getline "."
  ---@diagnostic disable-next-line: param-type-mismatch
  -- vim.api.nvim_set_current_line(cline:sub(1, cline:len()-1))
  local pos = vim.api.nvim_win_get_cursor(0)
  local row = pos[1] - 1
  local col = 0
  local entry_length = string.len(chars)
  ---@diagnostic disable-next-line: param-type-mismatch
  local start_chars = string.sub(vim.fn.getline ".", 0, entry_length)
  if start_chars == chars then
    ---@diagnostic disable-next-line: param-type-mismatch
    vim.api.nvim_set_current_line(cline:sub((entry_length + 1), cline:len()))
  else
    vim.api.nvim_buf_set_text(0, row, col, row, col, { chars })
  end
end

local function put_at_end(chars)
  local pos = vim.api.nvim_win_get_cursor(0)
  local row = pos[1] - 1
  local current_line = vim.api.nvim_get_current_line()
  local col = #current_line
  local entry_length = string.len(chars)
  ---@diagnostic disable-next-line: param-type-mismatch
  local cline = vim.fn.getline "."
  ---@diagnostic disable-next-line: param-type-mismatch
  local endchar = vim.fn.getline("."):sub(cline:len() - (entry_length - 1))
  if endchar == chars then
    ---@diagnostic disable-next-line: param-type-mismatch
    vim.api.nvim_set_current_line(cline:sub(1, cline:len() - entry_length))
  else
    vim.api.nvim_buf_set_text(0, row, col, row, col, { chars })
  end
end

---@param direction 'up'|'down'
local function duplicate_lines(direction)
  local startline = vim.fn.line "v"
  local endline = vim.fn.getcurpos()[2]

  -- swap
  if startline > endline then
    startline, endline = endline, startline
  end

  local texts = vim.api.nvim_buf_get_lines(0, startline - 1, endline, true)

  if direction == "up" then
    vim.api.nvim_buf_set_lines(0, endline, endline, true, texts)
  elseif direction == "down" then
    vim.api.nvim_buf_set_lines(0, startline, startline + 1, true, texts)
  end
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
    ["<A-p>"] = { "<CMD> Telescope commander<CR>", "󰘳 Find files" },

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
    ["<Leader>ll"] = {
      function()
        require("lsp_lines").toggle()
      end,
      " Toggle lsp_lines",
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
    ["]b"] = {
      function()
        require("goto-breakpoints").next()
      end,
      "Debug: Next Breakpoint",
    },
    ["[b"] = {
      function()
        require("goto-breakpoints").prev()
      end,
      "Debug: Previous Breakpoint",
    },
    ["]s"] = {
      function()
        require("goto-breakpoints").stopped()
      end,
      "Debug: Current Breakpoint",
    },
  },
}

M.git = {
  n = {
    ["<leader>gc"] = { "<CMD>Telescope git_commits<CR>", "  Git commits" },
    ["<leader>gb"] = { "<CMD>Telescope git_branches<CR>", "  Git branches" },
    ["<leader>gs"] = { "<CMD>Telescope git_status<CR>", "  Git status" },
    ["<leader>lg"] = { "<CMD>LazyGit<CR>", "  LazyGit" },
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

M.harpoon = {
  n = {
    ["<leader>ha"] = {
      function()
        local harpoon = require "harpoon"
        harpoon:list():add()
      end,
      "󱡁 Harpoon Add file",
    },
    ["<leader>ta"] = { "<CMD>Telescope harpoon marks<CR>", "󱡀 Toggle quick menu" },
    ["<leader>hb"] = {
      function()
        local harpoon = require "harpoon"
        harpoon.ui:toggle_quick_menu(harpoon:list(), {
          title = " Harpoon ",
          title_pos = "center",
          border = "rounded",
          ui_width_ratio = 0.40,
        })
      end,
      "󱠿 Harpoon Menu",
    },
    ["<leader>1"] = {
      function()
        local harpoon = require "harpoon"
        harpoon:list():select(1)
      end,
      "󱪼 Navigate to file 1",
    },
    ["<leader>2"] = {
      function()
        local harpoon = require "harpoon"
        harpoon:list():select(2)
      end,
      "󱪽 Navigate to file 2",
    },
    ["<leader>3"] = {
      function()
        local harpoon = require "harpoon"
        harpoon:list():select(3)
      end,
      "󱪾 Navigate to file 3",
    },
    ["<leader>4"] = {
      function()
        local harpoon = require "harpoon"
        harpoon:list():select(4)
      end,
      "󱪿 Navigate to file 4",
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
