require("telescope").load_extension "command_center"

require("command_center").add {
  {
    desc = "Replace",
    cmd = "<CMD>MurenToggle<CR>",
  },
  {
    desc = "Reload Window",
    cmd = "<CMD>windo e<CR>zz",
  },
}
