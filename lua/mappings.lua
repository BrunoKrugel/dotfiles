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

map({ "n", "t" }, "<M-g>", function()
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

map("i", "<S-CR>", function()
  vim.cmd "normal o"
end, { desc = " New line" })

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

map("i", "<A-BS>", "<C-w>", { desc = "Remove word" })

-- LSP
-- vim.keymap.set('n', '<MouseMove>', require("hover").hover, { desc = "Hover" })
vim.keymap.set("n", "K", require("hover").hover, {desc = "hover.nvim"})
vim.keymap.set("n", "gK", require("hover").hover_select, {desc = "hover.nvim (select)"})
vim.keymap.set("n", "<C-p>", function() require("hover").hover_switch("previous") end, {desc = "hover.nvim (previous source)"})
vim.keymap.set("n", "<C-n>", function() require("hover").hover_switch("next") end, {desc = "hover.nvim (next source)"})
