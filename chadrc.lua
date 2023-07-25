---@type ChadrcConfig
local M = {}
local fn = vim.fn
local core = require "custom.configs.core"

-- Path to overriding theme and highlights files
local highlights = require "custom.highlights"
M.ui = {
  theme = "chadracula",
  theme_toggle = { "chadracula", "one_light" },
  lsp_semantic_tokens = false,
  statusline = core.statusline,
  tabufline = core.tabufline,

  cmp = {
    icons = true,
    lspkind_text = true,
    style = "flat_dark", -- default/flat_light/flat_dark/atom/atom_colored
  },

  lsp = {
    signature = {
      disabled = true,
      silent = true,
    },
  },

  telescope = { style = "bordered" },

  hl_override = highlights.override,
  hl_add = highlights.add,

  nvdash = core.nvdash,
}

M.lazy_nvim = {
  ui = {
    border = "solid",
  },
}

M.settings = {
  cc_size = "130",
  so_size = 10,

  -- Blacklisted files where cc and so must be disabled
  blacklist = {
    "NvimTree",
    "nvdash",
    "nvcheatsheet",
    "terminal",
    "Trouble",
    "help",
  },
}

M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"

return M
