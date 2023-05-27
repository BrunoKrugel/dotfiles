local opt = vim.opt
local g = vim.g

if g.neovide then
  opt.guifont = "Hack Nerd Font:h12"
  g.neovide_refresh_rate = 120
  g.neovide_remember_window_size = true
  g.neovide_cursor_antialiasing = true
  g.neovide_input_macos_alt_is_meta = true
  g.neovide_input_use_logo = false
end
