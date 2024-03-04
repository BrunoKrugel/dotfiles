local map = vim.keymap.set

map({ "n" }, "<ESC>", function()
  vim.cmd "noh"
  vim.cmd "Noice dismiss"
end, { desc = " Clear highlights", })

map("n", "<leader>q", "<CMD>q<CR>", { desc = "󰗼 Close" })
map("n", "<leader>qq", "<<CMD>qa!<CR>", { desc = "󰗼 Exit" })
