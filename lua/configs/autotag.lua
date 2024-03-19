local ls = require "luasnip"
-- allow ts-autotag to coexist with luasnip
local autotag = require "nvim-ts-autotag.internal"
vim.keymap.set("i", ">", function()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { ">" })
  autotag.close_tag()
  vim.api.nvim_win_set_cursor(0, { row, col + 1 })
  ls.expand_auto()
end, { remap = false })

vim.keymap.set("i", "/", function()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { "/" })
  autotag.close_slash_tag()
  local new_row, new_col = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_win_set_cursor(0, { new_row, new_col + 1 })
  ls.expand_auto()
end, { remap = false })
