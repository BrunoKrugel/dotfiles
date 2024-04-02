require "nvchad.mappings"

local map = vim.keymap.set

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

map("i", "<S-CR>", function()
  vim.cmd ("normal o")
end, { desc = " New line"})

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
