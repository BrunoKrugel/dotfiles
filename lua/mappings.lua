require "nvchad.mappings"

local map = vim.keymap.set

-- Buffer-local mapping options
local opts = { noremap = true, silent = true, buffer = 0 }

map("n", "<A-R>", function()
  vim.cmd "GrugFar"
end, { desc = "Toggle GrugFar" })

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
map("v", "<leader>p", md_url_paste, opts)

map("n", "<leader>pp", function()
  md_url_paste()
end, { desc = "Paste in URL" })

map({ "n", "t" }, "<A-g>", function()
  require("nvchad.term").toggle {
    cmd = "lazygit",
    pos = "float",
    id = "gitToggleTerm",
    float_opts = {
      width = 1,
      height = 1,
    },
    clear_cmd = true,
  }
end, { desc = "Toggle Lazygit" })

map("n", "<leader>tc", "<cmd>CoverageToggle<cr>", { desc = "Coverage in gutter" })
map("n", "<leader><leader>c", "<cmd>CoverageLoad<cr><cmd>CoverageSummary<cr>", { desc = "Coverage summary" })

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

-- Text
map("n", "<S-CR>", "o<ESC>", { desc = " New line" })
map("s", "<BS>", "<C-o>c", { desc = "Better backspace in select mode" })
map({ "n", "i", "v" }, "<C-a>", "<cmd>normal! ggVG<cr>", { desc = "Select all" })

map("i", "<S-CR>", function()
  vim.cmd "normal o"
end, { desc = " New line" })

map("i", "<A-BS>", "<C-w>", { desc = "Remove word in insert mode" })

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

-- Movements
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

-- LSP
-- map('n', '<MouseMove>', require("hover").hover, { desc = "Hover" })
map("n", "K", function()
  local winid = require("ufo").peekFoldedLinesUnderCursor()
  if not winid then
    require("hover").hover()
  end
end, { desc = "hover.nvim" })

map("n", "gK", require("hover").hover_select, { desc = "hover.nvim (select)" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "<C-p>", function()
  require("hover").hover_switch "previous"
end, { desc = "hover.nvim (previous source)" })
map("n", "<C-n>", function()
  require("hover").hover_switch "next"
end, { desc = "hover.nvim (next source)" })

map("n", "<F12>", "<CMD>Glance references<CR>", { desc = "󰘐 References" })

map("n", "<C-ScrollWheelUp>", "<C-i>", { noremap = true, silent = true })
map("n", "<C-ScrollWheelDown>", "<C-o>", { noremap = true, silent = true })

-- vim.api.nvim_set_keymap('n', '<RightMouse>', '<LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>', { noremap=true, silent=true })

-- use gh to move to the beginning of the line in normal mode
-- use gl to move to the end of the line in normal mode
map({ "n", "v" }, "gh", "^", { desc = "[P]Go to the beginning line" })
map({ "n", "v" }, "gl", "$", { desc = "[P]go to the end of the line" })
-- In visual mode, after going to the end of the line, come back 1 character
map("v", "gl", "$h", { desc = "[P]Go to the end of the line" })

-- Replaces the current word with the same word in uppercase, globally
map(
  "n",
  "<leader>sU",
  [[:%s/\<<C-r><C-w>\>/<C-r>=toupper(expand('<cword>'))<CR>/gI<Left><Left><Left>]],
  { desc = "[P]GLOBALLY replace word I'm on with UPPERCASE" }
)

-- Replaces the current word with the same word in lowercase, globally
map(
  "n",
  "<leader>sL",
  [[:%s/\<<C-r><C-w>\>/<C-r>=tolower(expand('<cword>'))<CR>/gI<Left><Left><Left>]],
  { desc = "[P]GLOBALLY replace word I'm on with lowercase" }
)
