---@type ChadrcConfig
local M = {}

local core = require "custom.utils.core"

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
    style = "default", -- default/flat_light/flat_dark/atom/atom_colored
  },

  lsp = {
    signature = {
      disabled = true,
      silent = true,
    },
  },

  telescope = { style = "bordered" },

  extended_integrations = {
    "dap",
    "notify",
    "navic"
  },

  hl_override = highlights.override,
  hl_add = highlights.add,

  changed_themes = {
    vscode_dark = {
      base_30 = {
        vibrant_green = "#4ECF94",
      },
    },
  },

  nvdash = core.nvdash,
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

M.gitsigns = {
  signs = {
    add = { text = " " },
    change = { text = " " },
    delete = { text = " " },
    topdelete = { text = " " },
    changedelete = { text = " " },
    untracked = { text = " " },
  },
}

M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"

return M
