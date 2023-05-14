local present, gpt = pcall(require, "chatgpt")

if not present then
  return
end

gpt.setup {
  keymaps = {
    close = { "<C-c>", "<Esc>" },
    yank_last = "<C-y>",
    scroll_up = "<C-u>",
    scroll_down = "<C-d>",
    toggle_settings = "<C-o>",
    new_session = "<C-n>",
    cycle_windows = "<Tab>",
  },
}

