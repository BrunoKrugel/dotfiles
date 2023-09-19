local telescope = require "telescope"
local commander = require "commander"

require("commander").add {
  {
    desc = " Replace",
    cmd = "<CMD>MurenToggle<CR>",
    category = "text",
  },
  {
    desc = "󰑓 Reload Window",
    cmd = "<CMD>windo e<CR>",
    category = "ui",
  },
  {
    desc = "Restart LSP",
    cmd = "<CMD>LspRestart<CR>",
    category = "lsp",
  },
  {
    desc = "Toggle References",
    cmd = "<CMD>LspLensToggle<CR>",
    category = "lsp",
  },
  {
    desc = "Toggle ErrorLens",
    cmd = "<CMD>ErrorLensToggle<CR>",
    category = "lsp",
  },
  {
    desc = " Open Folders",
    cmd = "<CMD>UFOOpen<CR>",
    category = "text",
  },
  {
    desc = " Pick Color",
    cmd = "<CMD>Colortils picker<CR>",
    category = "web",
  },
}

commander.setup({
    -- Specify what components are shown in the prompt;
  -- Order matters, and components may repeat
  components = {
    "DESC",
    "KEYS",
    "CMD",
    "CAT",
  },

  -- Spcify by what components the commands is sorted
  -- Order does not matter
  sort_by = {
    "DESC",
    "KEYS",
    "CMD",
    "CAT",
  },

  -- Change the separator used to separate each component
  separator = " ",

  -- When set to true,
  -- The desc component will be populated with cmd if desc is empty or missing.
  auto_replace_desc_with_cmd = true,

  -- Default title of the prompt
  prompt_title = "Commander",

  integration = {
    telescope = {
      enable = false,
    },
    lazy = {
      -- Set to true to automatically add all keymaps set through lazy.nvim
      enable = true,
    }
  }
})

telescope.load_extension "commander"
