local autocmd = vim.api.nvim_create_autocmd
local cmd = vim.api.nvim_command
local augroup = vim.api.nvim_create_augroup
local fn = vim.fn

local function close_all_floating_wins()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then
      vim.api.nvim_win_close(win, false)
    end
  end
end

autocmd({
  "WinResized",
  "BufWinEnter",
  "CursorHold",
  "InsertLeave",
}, {
  group = augroup("barbecue.updater", {}),
  callback = function()
    require("barbecue.ui").update()
  end,
})
autocmd("ModeChanged", {
  desc = "Move to relative line number when in visual mode",
  callback = function(args)
    local newmode = args.match:match ":(.*)"
    local visual_modes = {
      ["v"] = true,
      ["V"] = true,
      [""] = true,
    }
    if visual_modes[newmode] then
      cmd "set relativenumber"
    else
      cmd "set norelativenumber"
    end
  end,
})

autocmd("FileType", {
  desc = "Workaround for NvMenu being below NvimTree.",
  pattern = "NvMenu",
  callback = function()
    if vim.bo.ft == "NvMenu" then
      vim.api.nvim_win_set_config(0, { zindex = 99 })
    end
  end,
})

-- Enable native syntax hl
autocmd("FileType", {
  pattern = { "gitsendemail", "conf", "editorconfig", "qf", "checkhealth" },
  callback = function(event)
    vim.bo[event.buf].syntax = vim.bo[event.buf].filetype
  end,
})

-- nicer cmp docs highlights for Nvim 0.10
autocmd("FileType", {
  pattern = "cmp_docs",
  callback = function(ev)
    vim.treesitter.start(ev.buf, "markdown")
  end,
})

-- allow regular CR function in cmdline windows
autocmd("CmdwinEnter", {
  callback = function(ev)
    vim.keymap.set("n", "<CR>", "<CR>", { remap = false, buffer = ev.buf })
  end,
})

--- Create a centered floating window of a given width and height, relative to the size of the screen.
--- @param width number width of the window where 1 is 100% of the screen
--- @param height number height of the window - between 0 and 1
--- @param buf number The buffer number
--- @return number The window number
local function open_centered_float(width, height, buf)
  buf = buf or vim.api.nvim_create_buf(false, true)
  local win_width = math.floor(vim.o.columns * width)
  local win_height = math.floor(vim.o.lines * height)
  local offset_y = math.floor((vim.o.lines - win_height) / 2)
  local offset_x = math.floor((vim.o.columns - win_width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = win_width,
    height = win_height,
    row = offset_y,
    col = offset_x,
    style = "minimal",
    border = "single",
  })

  return win
end

--- Open the help window in a floating window
--- @param buf number The buffer number
local function open_help(buf)
  if buf ~= nil and vim.bo[buf].filetype == "help" then
    local help_win = vim.api.nvim_get_current_win()
    local new_win = open_centered_float(0.6, 0.7, buf)

    -- set keymap 'q' to close the help window
    vim.api.nvim_buf_set_keymap(buf, "n", "q", ":q!<CR>", {
      nowait = true,
      noremap = true,
      silent = true,
    })

    -- set scroll position
    vim.wo[help_win].scroll = vim.wo[new_win].scroll

    -- close the help window
    vim.api.nvim_win_close(help_win, true)
  end
end

-- Function to get the folder name
local function get_folder_name()
  local path = vim.fn.expand "%:p:h"
  return vim.fn.fnamemodify(path, ":t")
end

-- Autocmd for new Go files
-- vim.api.nvim_create_autocmd('BufNewFile', {
--   pattern = '*.go',
--   callback = function()
--     local folder_name = get_folder_name()
--     local package_line = 'package ' .. folder_name .. '\n\n'
--     vim.api.nvim_buf_set_lines(0, 0, 0, false, {package_line})
--   end,
-- })

-- autocmd("BufWinEnter", {
--   callback = function(data)
--     open_help(data.buf)
--   end,
--   group = general,
--   desc = "Redirect help to floating window",
-- })

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  callback = function()
    vim.cmd [[Trouble qflist open]]
  end,
})

vim.api.nvim_create_autocmd("BufRead", {
  callback = function(ev)
    if vim.bo[ev.buf].buftype == "quickfix" then
      vim.schedule(function()
        vim.cmd [[cclose]]
        vim.cmd [[Trouble qflist open]]
      end)
    end
  end,
})

autocmd("VimResized", {
  desc = "Auto resize panes when resizing nvim window",
  pattern = "*",
  command = "tabdo wincmd =",
})

autocmd({ "BufNewFile", "BufRead" }, {
  desc = "Add support for .mdx files.",
  pattern = { "*.mdx" },
  group = augroup("MdxSupport", { clear = true }),
  callback = function()
    vim.api.nvim_set_option_value("filetype", "markdown", { scope = "local" })
  end,
})

autocmd("VimEnter", {
  desc = "Customize right click contextual menu.",
  callback = function()
    -- Disable right click message
    cmd [[aunmenu PopUp.How-to\ disable\ mouse]]
    cmd [[menu PopUp.󰏘\ Inspect\ Color <cmd>:Inspect<CR>]]
    -- cmd [[aunmenu PopUp.-1-]] -- You can remode a separator like this.
    cmd [[menu PopUp.Toggle\ \Breakpoint <cmd>:lua require('dap').toggle_breakpoint()<CR>]]
    cmd [[menu PopUp.Start\ \Debugger <cmd>:DapContinue<CR>]]
  end,
})

autocmd("BufWritePre", {
  desc = "Close all notifications on BufWritePre",
  callback = function()
    require("notify").dismiss { pending = true, silent = true }
  end,
})

autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "**/node_modules/**", "node_modules", "/node_modules/*" },
  callback = function()
    vim.diagnostic.disable(0)
  end,
})

autocmd("BufEnter", {
  desc = "Close nvim if NvimTree is only running buffer",
  command = [[if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif]],
})

autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("TS_add_missing_imports", { clear = true }),
  desc = "TS_add_missing_imports",
  pattern = { "*.ts" },
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = {
      only = { "source.addMissingImports.ts" },
    }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for _, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.kind == "source.addMissingImports.ts" then
          vim.lsp.buf.code_action {
            apply = true,
            context = {
              only = { "source.addMissingImports.ts" },
            },
          }
          vim.cmd "write"
        end
      end
    end
  end,
})

-- Define the VimEnter autocmd
autocmd("VimEnter", {
  callback = function()
    vim.g.status_version = ""
    local cwd = vim.fn.getcwd()

    -- Check if it's a Go workspace
    local go_mod_filepath = cwd .. "/go.mod"
    local go_mod_exists = vim.fn.filereadable(go_mod_filepath) == 1

    if go_mod_exists then
      local command = "go version"
      local handle = io.popen(command)
      local result = handle:read "*a"
      handle:close()
      local version = string.match(result, "go(%d+%.%d+%.%d+)")
      vim.g.status_version = "Go " .. version .. " 󱐋 "
    else
      -- Check if it's a Node.js workspace
      local package_json_filepath = cwd .. "/package.json"
      local package_json_exists = vim.fn.filereadable(package_json_filepath) == 1

      if package_json_exists then
        local command = "node --version"
        local handle = io.popen(command)
        local result = handle:read "*a"
        handle:close()
        local version = string.match(result, "v([%d.]+)")
        vim.g.status_version = "Node " .. version .. " 󱐋 "
      end
    end
  end,
})

autocmd("BufEnter", {
  desc = "Prevent auto comment new line",
  command = [[set formatoptions-=cro]],
})

autocmd("BufReadPost", {
  desc = "Go to last loc when opening a buffer",
  callback = function()
    local exclude = { "gitcommit", "gitrebase", "Trouble" }
    local buf = vim.api.nvim_get_current_buf()
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

autocmd("User", {
  desc = "Git conflict popup",
  pattern = "GitConflictDetected",
  callback = function()
    vim.notify("Conflict detected in " .. vim.fn.expand "<afile>")
    vim.keymap.set("n", "cww", function()
      engage.conflict_buster()
      create_buffer_local_mappings()
    end)
  end,
})

autocmd("BufWritePost", {
  desc = "Reload NvimTree after writing the buffer",
  callback = function()
    local bufs = fn.getbufinfo()
    for _, buf in ipairs(bufs) do
      if buf.name:find "NvimTree_" then
        cmd "NvimTreeRefresh"
        break
      end
    end
  end,
})

autocmd({ "BufRead" }, {
  desc = "Load git-conflict.nvim only when a git file is opened",
  group = vim.api.nvim_create_augroup("GitConflictLazyLoad", { clear = true }),
  callback = function()
    vim.fn.system("git -C " .. '"' .. vim.fn.expand "%:p:h" .. '"' .. " rev-parse")
    if vim.v.shell_error == 0 then
      vim.api.nvim_del_augroup_by_name "GitConflictLazyLoad"
      vim.schedule(function()
        require("lazy").load { plugins = { "git-conflict.nvim" } }
      end)
    end
  end,
})

autocmd("TextYankPost", {
  desc = "Highlight on yank",
  command = "silent! lua vim.hl.on_yank({higroup='YankVisual', timeout=200})",
  group = augroup("YankHighlight", { clear = true }),
})

autocmd("ModeChanged", {
  group = vim.api.nvim_create_augroup("user_diagnostic", { clear = true }),
  pattern = { "n:i", "n:v", "i:v" },
  command = "lua vim.diagnostic.disable(0)",
})

autocmd("ModeChanged", {
  group = vim.api.nvim_create_augroup("user_diagnostic", { clear = true }),
  pattern = "i:n",
  command = "lua vim.diagnostic.enable(0)",
})

-- Show cursor line only in active window
autocmd({ "InsertLeave", "WinEnter" }, {
  pattern = "*",
  command = "set cursorline",
  group = augroup("CursorLine", { clear = true }),
})
autocmd({ "InsertEnter", "WinLeave" }, {
  pattern = "*",
  command = "set nocursorline",
  group = augroup("CursorLine", { clear = true }),
})

--- Remove all trailing whitespace on save
autocmd("BufWritePre", {
  command = [[:%s/\s\+$//e]],
  group = augroup("TrimWhiteSpaceGrp", { clear = true }),
})

-- Restore cursor
autocmd({ "BufReadPost" }, {
  pattern = { "*" },
  callback = function()
    vim.api.nvim_exec('silent! normal! g`"zv', false)
  end,
})

autocmd({ "FileType" }, {
  desc = "enable_editorconfig_syntax",
  pattern = { "editorconfig" },
  callback = function()
    vim.opt_local.syntax = "editorconfig"
  end,
})

autocmd("FileType", {
  desc = "Define windows to close with 'q'",
  pattern = {
    "gitcommit",
    "gitrebase",
    "dap-float",
    "gitconfig",
    "help",
    "startuptime",
    "qf",
    "lspinfo",
    "man",
    "checkhealth",
    "tsplayground",
    "HIERARCHY-TREE-GO",
    "dap-float",
    "null-ls-info",
    "empty",
    "noice",
    "neotest-output",
    "neotest-summary",
    "neotest-output-panel",
    "nvcheatsheet",
    "grug-far",
    "grug-far-history",
    "grug-far-help",
  },
  group = augroup("WinCloseOnQDefinition", { clear = true }),
  command = [[
            nnoremap <buffer><silent> q :close<CR>
            set nobuflisted
        ]],
})

autocmd({ "BufRead", "BufNewFile" }, {
  desc = "Disable diagnostics in node_modules",
  pattern = "*/node_modules/*",
  command = "lua vim.diagnostic.disable(0)",
})

autocmd("BufWritePre", {
  callback = function(event)
    local client = vim.lsp.get_clients({ bufnr = event.buf, name = "eslint" })[1]
    if client then
      local diag = vim.diagnostic.get(event.buf, { namespace = vim.lsp.diagnostic.get_namespace(client.id) })
      if #diag > 0 then
        vim.cmd "EslintFixAll"
      end
    end
  end,
})

-- Nvimtree open file on creation
local function open_file_created()
  require("nvim-tree.api").events.subscribe("FileCreated", function(file)
    vim.cmd("edit " .. file.fname)
  end)
end

autocmd({ "VimEnter" }, {
  callback = open_file_created,
})

-- prevent weird snippet jumping behavior
-- https://github.com/L3MON4D3/LuaSnip/issues/258
autocmd({ "ModeChanged" }, {
  pattern = { "s:n", "i:*" },
  callback = function()
    if
      require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
      and not require("luasnip").session.jump_active
    then
      require("luasnip").unlink_current()
    end
  end,
})

-- prevent comment from being inserted when entering new line in existing comment
autocmd("BufEnter", {
  callback = function()
    -- allow <CR> to continue block comments only
    -- https://stackoverflow.com/questions/10726373/auto-comment-new-line-in-vim-only-for-block-comments
    vim.opt.comments:remove "://"
    vim.opt.comments:remove ":--"
    vim.opt.comments:remove ":#"
    vim.opt.comments:remove ":%"
  end,
})

-- Show `` in specific files
autocmd({ "BufRead", "BufNewFile" }, { pattern = { "*.txt", "*.md", "*.json" }, command = "setlocal conceallevel=2" })

-- Switch to insert mode when terminal is open
local term_augroup = vim.api.nvim_create_augroup("Terminal", { clear = true })
autocmd({ "TermOpen", "BufEnter" }, {
  -- TermOpen: for when terminal is opened for the first time
  -- BufEnter: when you navigate to an existing terminal buffer
  group = term_augroup,
  pattern = "term://*", --> only applicable for "BufEnter", an ignored Lua table key when evaluating TermOpen
  callback = function()
    vim.cmd "startinsert"
  end,
})

-- Automatically close terminal unless exit code isn't 0
autocmd("TermClose", {
  group = term_augroup,
  callback = function()
    if vim.v.event.status == 0 then
      vim.api.nvim_buf_delete(0, {})
      vim.notify_once "Previous terminal job was successful!"
    else
      vim.notify_once "Error code detected in the current terminal job!"
    end
  end,
})

--Delete [No Name] buffers,
autocmd("BufHidden", {
  callback = function(event)
    if event.file == "" and vim.bo[event.buf].buftype == "" and not vim.bo[event.buf].modified then
      vim.schedule(function()
        pcall(vim.api.nvim_buf_delete, event.buf, {})
      end)
    end
  end,
})

vim.api.nvim_create_autocmd("UIEnter", {
  callback = function()
    vim.cmd.clearjumps()
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "nvcheatsheet",
    "dapui_watches",
    "dap-repl",
    "dapui_console",
    "dapui_stacks",
    "dapui_breakpoints",
    "dapui_scopes",
    "lazy",
  },
  callback = function()
    require("ufo").detach()
    vim.opt_local.foldenable = false
  end,
})

-- https://github.com/mfussenegger/nvim-dap/issues/786
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("PromptBufferCtrlwFix", {}),
  pattern = {"dap-repl"},
  callback = function()
    vim.keymap.set("i", "<C-w>", function() vim.cmd("normal! bcw") end, {buffer = true})
  end
})

vim.api.nvim_create_autocmd("OptionSet", {
  pattern = "diff",
  callback = function()
    local ok, ibl = pcall(require, "ibl")
    if ok then
      if vim.opt.diff:get() then
        ibl.update { enabled = false }
      else
        ibl.update { enabled = true }
      end
    end
  end,
})

autocmd({ "BufEnter", "BufNewFile" }, {
  callback = function()
    if vim.bo.filetype == "markdown" then
      -- override ufo method
      vim.opt_local.foldexpr = "NestedMarkdownFolds()"
    else
      -- revert to ufo method
      vim.opt_local.foldexpr = ""
    end
  end,
})

autocmd({ "tabnew" }, {
  callback = function(args)
    vim.schedule(function()
      if vim.t.bufs == nil then
        vim.t.bufs = vim.api.nvim_get_current_buf() == args.buf and {} or { args.buf }
      end
    end)
  end,
})

autocmd("BufEnter", {
  nested = true,
  callback = function()
    local api = require "nvim-tree.api"
    -- Only 1 window with nvim-tree left: we probably closed a file buffer
    if #vim.api.nvim_list_wins() == 1 and api.tree.is_tree_buf() then
      -- Required to let the close event complete. An error is thrown without this.
      vim.defer_fn(function()
        -- close nvim-tree: will go to the last hidden buffer used before closing
        api.tree.toggle { find_file = true, focus = true }
        -- re-open nivm-tree
        api.tree.toggle { find_file = true, focus = true }
        -- nvim-tree is still the active window. Go to the previous window.
        vim.cmd "wincmd p"
      end, 0)
    end
  end,
})

-- Automatically update changed file in Vim
-- Triger `autoread` when files changes on disk
-- https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
-- https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  command = [[silent! if mode() != 'c' && !bufexists("[Command Line]") | checktime | endif]],
})

-- Notification after file change
-- https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
autocmd("FileChangedShellPost", {
  command = [[echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None]],
})

-- Hide cursorline in insert mode
autocmd({ "InsertLeave", "WinEnter" }, {
  command = "set cursorline",
})

autocmd({ "InsertEnter", "WinLeave" }, {
  command = "set nocursorline",
})
