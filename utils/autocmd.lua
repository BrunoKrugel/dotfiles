local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
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

-- Close Nvimtree before quit nvim
autocmd("FileType", {
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

-- Open new buffer if only Nvimtree is open
autocmd("BufEnter", {
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

-- Close nvim if NvimTree is only running buffer
autocmd("BufEnter", {
  command = [[if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif]],
})

-- Prefetch tabnine
autocmd("BufRead", {
  group = augroup("prefetch", { clear = true }),
  pattern = "*",
  callback = function()
    require("cmp_tabnine"):prefetch(vim.fn.expand "%:p")
  end,
})

-- Don't auto comment new line
autocmd("BufEnter", {
  command = [[set formatoptions-=cro]],
})

-- Go to last loc when opening a buffer
autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Git conflict popup
autocmd("User", {
  pattern = "GitConflictDetected",
  callback = function()
    vim.notify("Conflict detected in " .. vim.fn.expand "<afile>")
    vim.keymap.set("n", "cww", function()
      engage.conflict_buster()
      create_buffer_local_mappings()
    end)
  end,
})

-- Load git-conflict only when a git file is opened
autocmd({ "BufRead" }, {
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

-- Disable status column in the following files
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
      "nvcheatsheet",
      "dapui_watches",
      "dap-repl",
      "dapui_console",
      "dapui_stacks",
      "spectre_panel",
      "dapui_breakpoints",
      "dapui_scopes",
      "nvdash",
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

autocmd({ "BufEnter", "BufNew" }, {
  callback = function()
    local ft_ignore = {
      "man",
      "help",
      "neo-tree",
      "starter",
      "TelescopePrompt",
      "Trouble",
      "NvimTree",
      "nvcheatsheet",
      "dapui_watches",
      "dap-repl",
      "dapui_console",
      "spectre_panel",
      "dapui_stacks",
      "dapui_breakpoints",
      "dapui_scopes",
    }

    if vim.tbl_contains(ft_ignore, vim.bo.filetype) then
      vim.cmd "setlocal statuscolumn="
    end
  end,
})

-- Highlight on yank
autocmd("TextYankPost", {
  command = "silent! lua vim.highlight.on_yank({higroup='YankVisual', timeout=200})",
  group = augroup("YankHighlight", { clear = true }),
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
    "neotest-output",
    "neotest-summary",
    "neotest-output-panel",
  },
  command = [[
            nnoremap <buffer><silent> q :close<CR>
            set nobuflisted
        ]],
})

-- Disable diagnostics in node_modules (0 is current buffer only)
autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*/node_modules/*",
  command = "lua vim.diagnostic.disable(0)",
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

-- Go exclusive mappings
autocmd("FileType", {
  callback = function()
    if vim.bo.ft == "go" then
      require("core.utils").load_mappings "go"
    else
      require("custom.utils.core").remove_mappings "go"
    end
  end,
})

-- Unlink the snippet and restore completion
autocmd("ModeChanged", {
  pattern = "*",
  callback = function()
    if
      ((vim.v.event.old_mode == "s" and vim.v.event.new_mode == "n") or vim.v.event.old_mode == "i")
      and require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
      and not require("luasnip").session.jump_active
    then
      require("luasnip").unlink_current()
      require("cmp.config").set_global {
        completion = { autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged } },
      }
    end
  end,
})

-- Do not automatically trigger completion if we are in a snippet
autocmd("User", {
  pattern = "LuaSnipInsertNodeEnter",
  callback = function()
    require("cmp.config").set_global { completion = { autocomplete = false } }
  end,
})

-- But restore it when we leave.
vim.api.nvim_create_autocmd("User", {
  pattern = "LuaSnipInsertNodeLeave",
  callback = function()
    require("cmp.config").set_global {
      completion = { autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged } },
    }
  end,
})

-- {{{ Terminal autocmd
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

-- Auto format on save, but it will mess with undo history
-- autocmd("BufWritePre", {
--   pattern = { "*" },
--   callback = function()
--     vim.lsp.buf.format { async = false }
--   end,
-- })
