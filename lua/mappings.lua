require "nvchad.mappings"
local map = vim.keymap.set
local opts = { noremap = true, silent = true, buffer = 0 }

local function handle_copy()
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "" then
    if vim.fn.line "'<" == vim.fn.line "'>" and vim.fn.col "'<" == vim.fn.col "'>" then
      vim.cmd.normal '"+yy'
    else
      vim.cmd.normal '"+y'
    end
  else
    vim.cmd.normal '"+yy'
  end
end

local function handle_paste()
  vim.cmd.normal '"+p'
end

local function md_url_paste()
  -- Get clipboard
  local clip = vim.fn.getreg "+"
  -- 0-indexed locations
  local start_line = vim.fn.getpos("v")[2] - 1
  local start_col = vim.fn.getpos("v")[3] - 1
  local stop_line = vim.fn.getcurpos("")[2] - 1
  local stop_col = vim.fn.getcurpos("")[3] - 1
  -- Check start and stop aren't reversed, and swap if necessary
  if stop_line < start_line or (stop_line == start_line and stop_col < start_col) then
    start_line, start_col, stop_line, stop_col = stop_line, stop_col, start_line, start_col
  end
  -- Paste clipboard contents as md link.
  vim.api.nvim_buf_set_text(0, stop_line, stop_col + 1, stop_line, stop_col + 1, { "](" .. clip .. ")" })
  vim.api.nvim_buf_set_text(0, start_line, start_col, start_line, start_col, { "[" })
end

-- Move or create
---@param key 'h'|'j'|'k'|'l'
local function move_or_create_win(key)
  local fn = vim.fn
  local curr_win = fn.winnr()
  vim.cmd("wincmd " .. key) --> attempt to move

  if curr_win == fn.winnr() then --> didn't move, so create a split
    if key == "h" or key == "l" then
      vim.cmd "wincmd v"
    else
      vim.cmd "wincmd s"
    end

    vim.cmd("wincmd " .. key)
  end
end

local code_actions = function()
  local function apply_specific_code_action(res)
    vim.lsp.buf.code_action {
      filter = function(action)
        return action.title == res.title
      end,
      apply = true,
    }
  end

  local actions = {}

  actions["Goto Definition"] = { priority = 100, call = vim.lsp.buf.definition }
  actions["Goto Implementation"] = { priority = 200, call = vim.lsp.buf.implementation }
  actions["Show References"] = { priority = 300, call = vim.lsp.buf.references }
  actions["Rename"] = { priority = 400, call = vim.lsp.buf.rename }

  local bufnr = vim.api.nvim_get_current_buf()
  local params = vim.lsp.util.make_range_params()

  params.context = {
    triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Invoked,
    diagnostics = vim.lsp.diagnostic.get_line_diagnostics(),
  }

  vim.lsp.buf_request(bufnr, "textDocument/codeAction", params, function(_, results, _, _)
    if not results or #results == 0 then
      return
    end
    for i, res in ipairs(results) do
      local prio = 10
      if res.isPreferred then
        if res.kind == "quickfix" then
          prio = 0
        else
          prio = 1
        end
      end
      actions[res.title] = {
        priority = prio,
        call = function()
          apply_specific_code_action(res)
        end,
      }
    end
    local items = {}
    for t, action in pairs(actions) do
      table.insert(items, { title = t, priority = action.priority })
    end
    table.sort(items, function(a, b)
      return a.priority < b.priority
    end)
    local titles = {}
    for _, item in ipairs(items) do
      table.insert(titles, item.title)
    end
    vim.ui.select(titles, {}, function(choice)
      if choice == nil then
        return
      end
      actions[choice].call()
    end)
  end)
end

local function is_diag_for_cur_pos()
  local diagnostics = vim.diagnostic.get(0)
  local pos = vim.api.nvim_win_get_cursor(0)
  if #diagnostics == 0 then
    return false
  end
  local message = vim.tbl_filter(function(d)
    return d.col == pos[2] and d.lnum == pos[1] - 1
  end, diagnostics)
  return #message > 0
end

local function is_diag_neotest()
  local diagnostics = vim.diagnostic.get(0)
  local found = false
  for _, d in ipairs(diagnostics) do
    if d.source and d.source:match "neotest" then
      found = true
      break
    end
  end
  return found
end

local function hover_handler()
  local dap_ok, dap = pcall(require, "dap")
  if dap_ok and dap.session() ~= nil then
    local dapui_ok, dapui = pcall(require, "dap.ui.widgets")
    if dapui_ok and vim.bo.filetype ~= "dap-float" then
      dapui.hover()
    end
  end
  local ufo_ok, ufo = pcall(require, "ufo")
  if ufo_ok then
    local winid = ufo.peekFoldedLinesUnderCursor()
    if winid then
      return
    end
  end
  local ft = vim.bo.filetype
  if vim.tbl_contains({ "vim", "help" }, ft) then
    vim.cmd("silent! h " .. vim.fn.expand "<cword>")
  elseif vim.tbl_contains({ "man" }, ft) then
    vim.cmd("silent! Man " .. vim.fn.expand "<cword>")
  elseif is_diag_for_cur_pos() then
    if is_diag_neotest() then
      local nt_ok, nt = pcall(require, "neotest")
      if nt_ok then
        nt.output.open {
          enter = true,
          auto_close = true,
        }
      end
    else
      vim.diagnostic.open_float()
    end
  else
    require("hover").hover()
  end
end

local function resolve_conflict()
  -- Get the current line and buffer
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  local buffer = vim.api.nvim_get_current_buf()
  -- Fetch lines around the cursor
  local lines = vim.api.nvim_buf_get_lines(buffer, current_line - 1, current_line + 10, false)
  -- Detect a conflict
  local conflict_start, conflict_middle, conflict_end
  for i, line in ipairs(lines) do
    if line:match "^<<<<" then
      conflict_start = current_line + i - 2
    elseif line:match "^====" then
      conflict_middle = current_line + i - 2
    elseif line:match "^>>>>" then
      conflict_end = current_line + i - 2
      break
    end
  end
  -- Ensure all markers are found
  if not (conflict_start and conflict_middle and conflict_end) then
    vim.notify("No conflict markers found.", vim.log.levels.ERROR)
    return
  end
  -- Prepare options
  local options = { "Top (yours)", "Bottom (theirs)" }
  vim.ui.select(options, { prompt = "Select conflict resolution:" }, function(choice)
    if choice then
      if choice == "Top (yours)" then
        vim.api.nvim_buf_set_lines(
          buffer,
          conflict_start,
          conflict_end + 1,
          false,
          vim.api.nvim_buf_get_lines(buffer, conflict_start + 1, conflict_middle, false)
        )
      elseif choice == "Bottom (theirs)" then
        vim.api.nvim_buf_set_lines(
          buffer,
          conflict_start,
          conflict_end + 1,
          false,
          vim.api.nvim_buf_get_lines(buffer, conflict_middle + 1, conflict_end, false)
        )
      end
      vim.notify("Conflict resolved with " .. choice .. ".", vim.log.levels.INFO)
    else
      vim.notify("Conflict resolution canceled.", vim.log.levels.WARN)
    end
  end)
end

local function find_files()
  local entry_maker = require("configs.entry").find_files_entry_maker
  local opts = {
    entry_maker = entry_maker(),
    sorting_strategy = "ascending",
    layout_strategy = "center",
    prompt_title = "Find Files",
    border = true,
    borderchars = {
      prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
      results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
      preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    },
    layout_config = {
      width = 0.8,
      height = 0.6,
    },
    results_title = false,
    previewer = false,
  }

  opts.show_untracked = true

  local succ = pcall(require("telescope.builtin").git_files, opts)

  if not succ then
    require("telescope.builtin").find_files(opts)
  end
end

--NvMenu
local menu = {
  {
    name = "Format Buffer",
    cmd = function()
      local ok, conform = pcall(require, "conform")

      if ok then
        conform.format { lsp_fallback = true }
      else
        vim.lsp.buf.format()
      end
    end,
    rtxt = "<leader>fm",
  },
  {
    name = "Copy Content",
    cmd = "%y+",
    rtxt = "<C-c>",
  },
  {
    name = "Delete Content",
    cmd = "%d",
    rtxt = "dc",
  },
  {
    name = "  Copy",
    cmd = handle_copy,
  },
  {
    name = "  Paste",
    cmd = handle_paste,
  },
  { name = "separator" },
  {
    name = " Lsp Actions",
    hl = "Exblue",
    items = "lsp",
  },
  { name = "separator" },
  {
    name = "  Git Actions",
    hl = "Exgreen",
    items = "gitsigns",
  },
  { name = "separator" },
  {
    name = " Color Picker",
    hl = "Exred",
    cmd = function()
      require("minty.huefy").open()
    end,
  },
}
map("n", "<C-t>", function()
  require("menu").open(menu)
end, { desc = "Open NvChad menu" })

map("n", "<RightMouse>", function()
  vim.cmd.exec '"normal! \\<RightMouse>"'
  local options = vim.bo.ft == "NvimTree" and "nvimtree" or menu
  require("menu").open(options, { mouse = true })
end, { desc = "Open NvChad menu" })

vim.keymap.set({ "n" }, "<leader>m", function()
  local dap = require "dap"
  require("menu").open {
    -- {
    --   name = "󰤑 Run Tests",
    --   hl = "@conditional",
    --   cmd = function()
    --     dap.run({
    --       type = 'python', -- Ajusta el tipo según tu entorno
    --       request = 'launch',
    --       name = "Run Tests",
    --       program = "${file}", -- Ajusta según sea necesario
    --     })
    --   end,
    --   rtxt = "t",
    -- },
    -- { name = "separator" },
    {
      name = " Continue",
      hl = "Exgreen",
      cmd = function()
        dap.continue()
      end,
      rtxt = "c",
    },
    {
      name = " Toggle Breakpoint",
      cmd = function()
        dap.toggle_breakpoint()
      end,
      rtxt = "b",
    },
    {
      name = " Step Over",
      cmd = function()
        dap.step_over()
      end,
      rtxt = "o",
    },
    {
      name = " Step Into",
      cmd = function()
        dap.step_into()
      end,
      rtxt = "i",
    },
    { name = "separator" },
    {
      name = " Step Out",
      hl = "@comment.error",
      cmd = function()
        dap.step_out()
      end,
      rtxt = "u",
    },
    {
      name = " Stop",
      hl = "@comment.error",
      cmd = function()
        dap.terminate()
      end,
      rtxt = "s",
    },
  }
end)

--------------------------------------------------- Editor ---------------------------------------------------

map({ "n", "i", "v" }, "<C-p>", function()
  find_files()
end, { desc = "󰘳 Find files" })

map("v", "<leader>p", function()
  md_url_paste()
end, opts)

map("n", "<leader>pp", function()
  md_url_paste()
end, { desc = "Paste in URL" })

map("n", "<leader>th", function()
  require("nvchad.themes").open { style = "flat" }
end, { desc = "Open NvChad theme selector" })

map("n", "<A-R>", function()
  vim.cmd "GrugFar"
end, { desc = "Toggle GrugFar" })

map("n", "<leader>gxx", function()
  resolve_conflict()
end, { desc = "Resolve conflict" })

-- GitSigns
map("n", "]c", "<cmd>Gitsigns next_hunk<CR>", { desc = "Next hunk" })
map("n", "[c", "<cmd>Gitsigns prev_hunk<CR>", { desc = "Previous hunk" })

map({ "n" }, "<ESC>", function()
  vim.cmd "noh"
  vim.cmd "Noice dismiss"
end, { desc = " Clear highlights" })

map("n", "<leader>q", "<CMD>q<CR>", { desc = "󰗼 Close" })
map("n", "<leader>qq", "<<CMD>qa!<CR>", { desc = "󰗼 Exit" })

-- NvimTree
map({ "n" }, "<leader>e", "<cmd> NvimTreeToggle <CR>", { desc = "󰔱 Toggle nvimtree" })
map({ "n", "i" }, "<C-b>", "<cmd> NvimTreeToggle <CR>", { desc = "Toggle nvimtree" })

map({ "n" }, "<leader>to", "<CMD>TSJToggle<CR>", { desc = "󱓡 Toggle split/join" })

--------------------------------------------------- Text ---------------------------------------------------
map("n", "<C-z>", "<CMD>u<CR>", { desc = "󰕌 Undo" })
map("n", "<BS>", "<C-o>", { desc = "Return" })
map("n", "<C-x>", "x", { desc = "󰆐 Cut" })
map("n", "<C-v>", "p`[v`]=", { desc = "󰆒 Paste" })
map("n", "<C-c>", "y", { desc = " Copy" })
map("n", "p", "p`[v`]=", { desc = "󰆒 Paste" })
map("n", "<S-CR>", "o<ESC>", { desc = " New line" })
map("s", "<BS>", "<C-o>c", { desc = "Better backspace in select mode" })
map({ "n", "i", "v" }, "<C-a>", "<cmd>normal! ggVG<cr>", { desc = "Select all" })

map("i", "<S-CR>", function()
  vim.cmd "normal o"
end, { desc = " New line" })

map("i", "<A-BS>", "<C-w>", { desc = "Remove word in insert mode" })

-- Inside a snippet, use backspace to remove the placeholder.
map("s", "<BS>", "<C-O>s")

-- Replaces the current word with the same word in uppercase, globally
map(
  "n",
  "<leader>sU",
  [[:%s/\<<C-r><C-w>\>/<C-r>=toupper(expand('<cword>'))<CR>/gI<Left><Left><Left>]],
  { desc = "Replace current word with UPPERCASE" }
)

-- Replaces the current word with the same word in lowercase, globally
map(
  "n",
  "<leader>sL",
  [[:%s/\<<C-r><C-w>\>/<C-r>=tolower(expand('<cword>'))<CR>/gI<Left><Left><Left>]],
  { desc = "Replace current word lowercase" }
)

-- Surround
map("x", "'", [[:s/\%V\(.*\)\%V/'\1'/ <CR>]], { desc = "Surround selection with '" })
map("x", '"', [[:s/\%V\(.*\)\%V/"\1"/ <CR>]], { desc = 'Surround selection with "' })
map("x", "*", [[:s/\%V\(.*\)\%V/*\1*/ <CR>]], { desc = "Surround selection with *" })

map("n", "<leader>s*", [[:s/\<<C-r><C-w>\>/*<C-r><C-w>\*/ <CR>]], { desc = "Surround word with *" })
map("n", '<leader>s"', [[:s/\<<C-r><C-w>\>/"<C-r><C-w>\"/ <CR>]], { desc = 'Surround word with "' })
map("n", "<leader>s'", [[:s/\<<C-r><C-w>\>/'<C-r><C-w>\'/ <CR>]], { desc = "Surround word with '" })

-- In visual mode, surround the selected text with markdown link syntax
map("v", "<leader>mll", function()
  -- delete selected text
  vim.cmd "normal d"
  -- Insert the following in insert mode
  vim.cmd "startinsert"
  vim.api.nvim_put({ "[]() " }, "c", true, true)
  -- Move to the left, paste, and then move to the right
  vim.cmd "normal F[pf)"
  -- vim.cmd("normal 2hpF[l")
  -- Leave me in insert mode to start typing
  vim.cmd "startinsert"
end, { desc = "[P]Convert to link" })

-- In visual mode, surround the selected text with markdown link syntax
map("v", "<leader>mlt", function()
  -- delete selected text
  vim.cmd "normal d"
  -- Insert the following in insert mode
  vim.cmd "startinsert"
  vim.api.nvim_put({ '[](){:target="_blank"} ' }, "c", true, true)
  vim.cmd "normal F[pf)"
  -- Leave me in insert mode to start typing
  vim.cmd "startinsert"
end, { desc = "[P]Convert to link (new tab)" })

--------------------------------------------------- Movements ---------------------------------------------------
map({ "n", "i" }, "<C-h>", function()
  move_or_create_win "h"
end, { desc = "Split left" })
map({ "n", "i" }, "<C-l>", function()
  move_or_create_win "l"
end, { desc = "Split right" })
map({ "n", "i" }, "<C-k>", function()
  move_or_create_win "k"
end, { desc = "Split up" })
map({ "n", "i" }, "<C-j>", function()
  move_or_create_win "j"
end, { desc = "Split down" })

-- Better Down
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Better Down", expr = true, silent = true })

-- Better Up
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Better Up", expr = true, silent = true })

-- Hop
map("n", "<leader><leader>w", "<CMD> HopWord <CR>", { desc = "󰸱 Hint all words" })
map("n", "<leader><leader>t", "<CMD> HopNodes <CR>", { desc = " Hint Tree" })
map("n", "<leader><leader>o", "<CMD> HopLineStart<CR>", { desc = "󰕭 Hint Columns" })
map("n", "<leader><leader>l", "<CMD> HopWordCurrentLine<CR>", { desc = "󰗉 Hint Line" })

-- Navigation
map("n", "<C-ScrollWheelUp>", "<C-i>", { noremap = true, silent = true })
map("n", "<C-ScrollWheelDown>", "<C-o>", { noremap = true, silent = true })

--------------------------------------------------- Testing ---------------------------------------------------
map("n", "<leader>nt", function()
  require("neotest").run.run(vim.fn.expand "%")
  require("coverage").load(true)
end, { desc = "󰤑 Run neotest" })

map("n", "<leader>rt", function()
  require("neotest").run.run()
  require("coverage").load(true)
end, { desc = "󰤑 Run neotest" })

map("n", "<leader>tc", "<cmd>CoverageToggle<cr>", { desc = "Coverage in gutter" })
map("n", "<leader><leader>c", "<cmd>CoverageLoad<cr><cmd>CoverageSummary<cr>", { desc = "Coverage summary" })
--------------------------------------------------- LSP ---------------------------------------------------
-- map('n', '<MouseMove>', require("hover").hover, { desc = "Hover" })
map("n", "K", function()
  -- local winid = require("ufo").peekFoldedLinesUnderCursor()
  -- if not winid then
  --   require("hover").hover()
  -- end
  hover_handler()
end, { desc = "hover.nvim" })

map("n", "<leader>k", function()
  require("hover").hover()
end, { desc = "LSP Hover" })

map("n", "gK", require("hover").hover_select, { desc = "hover.nvim (select)" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "<C-n>", function()
  require("hover").hover_switch "next"
end, { desc = "hover.nvim (next source)" })

map({ "n", "i", "v" }, "<C-.>", function()
  require("fastaction").code_action()
end, { desc = "Code Action" })

map({ "n" }, "<leader>.", function()
  code_actions()
end, { desc = "Code Action" })

map("n", "<F12>", "<CMD>Glance references<CR>", { desc = "󰘐 References" })

map("n", "<leader>wl", function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, { desc = "LSP list workspace folders" })

-- vim.api.nvim_set_keymap('n', '<RightMouse>', '<LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>', { noremap=true, silent=true })

-- use gh to move to the beginning of the line in normal mode
-- use gl to move to the end of the line in normal mode
map({ "n", "v" }, "gh", "^", { desc = "[P]Go to the beginning line" })
map({ "n", "v" }, "gl", "$", { desc = "[P]go to the end of the line" })
-- In visual mode, after going to the end of the line, come back 1 character
map("v", "gl", "$h", { desc = "[P]Go to the end of the line" })

map("n", "<leader><leader>x", ":%bd|e#|bd#<cr>|'\"<CR>", { desc = "Buffer close except current" }) --https://stackoverflow.com/a/60948057
-- grug far current file
-- require('grug-far').grug_far({ prefills = { paths = vim.fn.expand("%") } })
