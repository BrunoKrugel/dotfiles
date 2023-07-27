---@diagnostic disable: need-check-nil
local create_cmd = vim.api.nvim_create_user_command
local settings = require("custom.chadrc").settings
local g = vim.g

-- Toggle colorcolumn
create_cmd("ColorcolumnToggle", function()
  vim.g.ccenable = not vim.g.ccenable

  if vim.g.ccenable then
    vim.opt.cc = settings.cc_size
  else
    vim.opt.cc = "0"
  end
end, {})

create_cmd("TDebug", function()
  require("dapui").toggle()
end, {})

create_cmd("TUpdate", function()
  require("lazy").load { plugins = { "mason.nvim", "nvim-treesitter" } }
  vim.cmd "MasonUpdate"
  vim.cmd "TSUpdate"
  vim.cmd "NvChadUpdate"
end, {})

g.codeium = false
create_cmd("CodeiumToggle", function()
  vim.notify("Codeium is " .. (g.codeium and "OFF" or "ON"), "info", {
    title = "Codeium",
    icon = "",
    on_open = function()
      g.codeium = not g.codeium
      if g.codeium then
        vim.cmd "CodeiumEnable"
      else
        vim.cmd "CodeiumDisable"
      end
    end,
  })
end, {})
