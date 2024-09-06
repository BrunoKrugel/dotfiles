---@class ChadrcConfig
local M = {}

local core = require "custom.utils.core"

-- Path to overriding theme and highlights files
local highlights = require "custom.highlights"
M.ui = {
  lsp_semantic_tokens = false,
  statusline = core.statusline,
  tabufline = core.tabufline,

  cmp = {
    icons = true,
    lspkind_text = true,
    style = "default", -- default/flat_light/flat_dark/atom/atom_colored
    border_color = "grey_fg", -- only applicable for "default" style, use color names from base30 variables
    selected_item_bg = "colored", -- colored / simple
  },

  telescope = { style = "bordered" },

  hl_override = highlights.override,
  hl_add = highlights.add,

  nvdash = core.nvdash,
}

M.lsp = { signature = false }

M.mason = {
  pkgs = {
    -- lua stuff
    "lua-language-server",
    "stylua",

    -- web dev stuff
    "css-lsp",
    "html-lsp",
    "typescript-language-server",
    "prettier",
    "eslint-lsp",
    "emmet-ls",
    "rustywind",

    -- Spell
    "marksman",

    -- Json
    "jsonlint",
    "json-lsp",

    "dockerfile-language-server",

    -- golang
    "gopls",
    "goimports",
    "golines",
    "gomodifytags",
    "impl",
    "iferr",
  },
}

M.base46 = {
  integrations = {
    "blankline",
    "cmp",
    "defaults",
    "devicons",
    "git",
    "lsp",
    "mason",
    "nvcheatsheet",
    "nvdash",
    "nvimtree",
    "statusline",
    "syntax",
    "tbline",
    "telescope",
    "whichkey",
    "dap",
    "hop",
    "treesitter",
    "rainbowdelimiters",
    "todo",
    "trouble",
    "notify",
  },

  theme = "catppucin-frape",
  theme_toggle = { "catppucin-frape", "one_light" },

  hl_override = highlights.override,
  hl_add = highlights.add,

  nvdash = core.nvdash,
}

M.colorify = {
  enabled = true,
  mode = "virtual", -- fg, bg, virtual
  virt_text = "󱓻 ",

  highlight = {
    hex = true,
    lspvars = true,
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

M.lazy_nvim = core.lazy

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

-- TODO: Temporary fix for NvChad Mapping changes (I dont wanna edit all my mappings)
M.mappings = require "custom.old_mappings"
core.load_mappings "folder"
core.load_mappings "comment"
core.load_mappings "development"
core.load_mappings "text"
core.load_mappings "go"
core.load_mappings "window"
core.load_mappings "general"
core.load_mappings "diagnostics"
core.load_mappings "node"
core.load_mappings "debug"
core.load_mappings "git"
core.load_mappings "telescope"
core.load_mappings "tabufline"
core.load_mappings "docker"
core.load_mappings "searchbox"
core.load_mappings "lspsaga"
core.load_mappings "nvterm"
core.load_mappings "harpoon"
core.load_mappings "lspconfig"

return M
