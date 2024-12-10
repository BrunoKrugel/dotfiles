require "nvchad.mappings"
local map = vim.keymap.set
local opts = { noremap = true, silent = true, buffer = 0 }

local function golang_goto_def()
  local old = vim.lsp.buf.definition
  local opts = {
    on_list = function(options)
      if options == nil or options.items == nil or #options.items == 0 then
        return
      end
      local targetFile = options.items[1].filename
      local prefix = string.match(targetFile, "(.-)_templ%.go$")
      if prefix then
        local function_name = vim.fn.expand "<cword>"
        options.items[1].filename = prefix .. ".templ"
        vim.fn.setqflist({}, " ", options)
        vim.api.nvim_command "cfirst"
        vim.api.nvim_command("silent! /templ " .. function_name)
      else
        old()
      end
    end,
  }
  vim.lsp.buf.definition = function(o)
    o = o or {}
    o = vim.tbl_extend("keep", o, opts)
    old(o)
  end
end

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
  local dap = require("dap")
  require("menu").open({
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
  })
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
end, { desc = "󰤑 Run neotest" })

map("n", "<leader>tc", "<cmd>CoverageToggle<cr>", { desc = "Coverage in gutter" })
map("n", "<leader><leader>c", "<cmd>CoverageLoad<cr><cmd>CoverageSummary<cr>", { desc = "Coverage summary" })
--------------------------------------------------- LSP ---------------------------------------------------
-- map('n', '<MouseMove>', require("hover").hover, { desc = "Hover" })
map("n", "K", function()
  local winid = require("ufo").peekFoldedLinesUnderCursor()
  if not winid then
    require("hover").hover()
  end
end, { desc = "hover.nvim" })

map("n", "gK", require("hover").hover_select, { desc = "hover.nvim (select)" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "<C-n>", function()
  require("hover").hover_switch "next"
end, { desc = "hover.nvim (next source)" })

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

-- grug far current file
-- require('grug-far').grug_far({ prefills = { paths = vim.fn.expand("%") } })
