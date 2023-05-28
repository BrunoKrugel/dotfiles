local present, lspui = pcall(require, "lspui")

if not present then
  return
end

require("LspUI").setup {
  lightbulb = {
    enable = true,          -- close by default
    command_enable = false, -- close by default, this switch does not have to be turned on, this command has no effect
    icon = "",
  },
  icons = {
    hint = "",
    info = "",
    warning = "",
    error = "",
  },
  virtual_text = {
    prefix = "",
    spacing = 0,
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
}
