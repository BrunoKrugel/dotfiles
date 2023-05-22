local create_cmd = vim.api.nvim_create_user_command

create_cmd("PeekOpen", function()
  require("peek").open()
end, {})

create_cmd("PeekClose", function()
  require("peek").close()
end, {})

create_cmd("Nvtfloat", function()
  require("nvterm.terminal").toggle "float"
end, {})

create_cmd("NotifLog", function()
  require("notify").history()
end, {})

-- Toggle colorcolumn display
create_cmd("CCToggle", function()
  vim.g.ccenabled = not vim.g.ccenabled
  if vim.g.ccenabled then
    vim.opt.colorcolumn = "120"
  else
    vim.opt.colorcolumn = "0"
  end
end, {})
