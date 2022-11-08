local present, illuminate = pcall(require, "illuminate")

if not present then
  return
end

illuminate.configure {
  providers = {
    "lsp",
    "treesitter",
    "regex",
  },
  delay = 100,
  filetypes_denylist = {
    "alpha",
    "dashboard",
    "DoomInfo",
    "fugitive",
    "help",
    "norg",
    "NvimTree",
    "Outline",
    "packer",
    "toggleterm",
  },
  under_cursor = false,
}

-- https://github.com/RRethy/vim-illuminate/issues/115#issuecomment-1221297926
vim.api.nvim_set_hl(0, "IlluminatedWordText", { link = "Visual" })
vim.api.nvim_set_hl(0, "IlluminatedWordRead", { link = "Visual" })
vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { link = "Visual" })