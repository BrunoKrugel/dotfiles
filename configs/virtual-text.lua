require("nvim-dap-virtual-text").setup {
  enabled = true,
  enabled_commands = true,
  -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
  highlight_changed_variables = true,
  highlight_new_as_changed = true,
  show_stop_reason = true,
  -- prefix virtual text with comment string
  commented = false,
  -- only show virtual text at first definition (if there are multiple)
  only_first_definition = true,
  -- show virtual text on all all references of the variable (not only definitions)
  all_references = true,
  -- filter references (not definitions) pattern when all_references is activated
  -- (Lua gmatch pattern, default filters out Python modules)
  filter_references_pattern = "<module",
  -- experimental features:
  -- position of virtual text, see `:h nvim_buf_set_extmark()`
  virt_text_pos = "eol",
  -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
  all_frames = false,
  -- show virtual lines instead of virtual text (will flicker!)
  virt_lines = false,
  -- position the virtual text at a fixed window column (starting from the first text column) ,
  -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
  virt_text_win_col = nil,
}
