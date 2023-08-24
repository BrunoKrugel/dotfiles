local telescope = require "telescope"
local command_center = require "command_center"

require("command_center").add {
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

telescope.setup {
  extensions = {
    command_center = {
      components = {
        command_center.component.DES,
      },
      sort_by = {
        command_center.component.DESC,
        command_center.component.KEYS,
      },
      auto_replace_desc_with_cmd = false,
    },
  },
}

telescope.load_extension "command_center"
