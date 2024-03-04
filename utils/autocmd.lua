local autocmd = vim.api.nvim_create_autocmd
local cmd = vim.api.nvim_command
local augroup = vim.api.nvim_create_augroup
local settings = require("custom.chadrc").settings
local fn = vim.fn

local function close_all_floating_wins()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then
      vim.api.nvim_win_close(win, false)
    end
  end
end

autocmd("VimResized", {
  desc = "Auto resize panes when resizing nvim window",
  pattern = "*",
  command = "tabdo wincmd =",
})

autocmd("VimEnter", {
  desc = "Customize right click contextual menu.",
  callback = function()
    -- Disable right click message
    cmd [[aunmenu PopUp.How-to\ disable\ mouse]]
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

autocmd("LspAttach", {
  desc = "Fix semantic tokens for lsp",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    client.server_capabilities.semanticTokensProvider = nil
  end,
})

autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "**/node_modules/**", "node_modules", "/node_modules/*" },
  callback = function()
    vim.diagnostic.disable(0)
  end,
})

autocmd({ "BufWritePre" }, {
  desc = "Auto create dir when saving a file",
  pattern = "*",
  group = augroup("auto_create_dir", { clear = true }),
  callback = function(ctx)
    local dir = fn.fnamemodify(ctx.file, ":p:h")
    utils.may_create_dir(dir)
  end,
})

autocmd({ "BufRead" }, {
  desc = "Display a message when the current file is not in utf-8 format",
  pattern = "*",
  group = augroup("non_utf8_file", { clear = true }),
  callback = function()
    if vim.bo.fileencoding ~= "utf-8" then
      vim.notify("File not in UTF-8 format!", vim.log.levels.WARN, { title = "nvim-config" })
    end
  end,
})

autocmd("FileType", {
  desc = "Close NvimTree before quit nvim",
  pattern = { "NvimTree" },
  callback = function(args)
    autocmd("VimLeavePre", {
      callback = function()
        vim.api.nvim_buf_delete(args.buf, { force = true })
        return true
      end,
    })
  end,
})

autocmd("BufEnter", {
  desc = "Open new buffer if only Nvimtree is open",
  nested = true,
  callback = function()
    local api = require "nvim-tree.api"
    if #vim.api.nvim_list_wins() == 1 and api.tree.is_tree_buf() then
      vim.defer_fn(function()
        api.tree.toggle { find_file = true, focus = true }
        api.tree.toggle { find_file = true, focus = true }
        vim.cmd "wincmd p"
      end, 0)
    end
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
  command = "silent! lua vim.highlight.on_yank({higroup='YankVisual', timeout=200})",
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

-- Restore cursor
autocmd({ "BufReadPost" }, {
  pattern = { "*" },
  callback = function()
    vim.api.nvim_exec('silent! normal! g`"zv', false)
  end,
})

-- Windows to close with "q"
autocmd("FileType", {
  pattern = {
    "help",
    "startuptime",
    "qf",
    "lspinfo",
    "man",
    "checkhealth",
    "tsplayground",
    "HIERARCHY-TREE-GO",
    "dap-float",
    "spectre_panel",
    "null-ls-info",
    "empty",
    "noice",
    "neotest-output",
    "neotest-summary",
    "neotest-output-panel",
  },
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

autocmd({ "User" }, {
  pattern = "PersistedSavePre",
  group = group,
  callback = function()
    pcall(vim.cmd, "NvimTreeClose")
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

-- local lazy_did_show_install_view = false

-- local function auto_session_restore()
--   -- important! without vim.schedule other necessary plugins might not load (eg treesitter) after restoring the session
--   vim.schedule(function()
--     require("auto-session").AutoRestoreSession()
--   end)
-- end

-- autocmd("User", {
--   pattern = "VeryLazy",
--   callback = function()
--     local lazy_view = require "lazy.view"

--     if lazy_view.visible() then
--       -- if lazy view is visible do nothing with auto-session
--       lazy_did_show_install_view = true
--     else
--       -- otherwise load (by require'ing) and restore session
--       auto_session_restore()
--     end
--   end,
-- })

-- autocmd("WinClosed", {
--   pattern = "*",
--   callback = function(ev)
--     local lazy_view = require "lazy.view"

--     -- if lazy view is currently visible and was shown at startup
--     if lazy_view.visible() and lazy_did_show_install_view then
--       -- if the window to be closed is actually the lazy view window
--       if ev.match == tostring(lazy_view.view.win) then
--         lazy_did_show_install_view = false
--         auto_session_restore()
--       end
--     end
--   end,
-- })

-- Open NvimTree on startup
-- autocmd("VimEnter", {
--   callback = function()
--     require("nvim-tree.api").tree.open()
--   end,
-- })

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
