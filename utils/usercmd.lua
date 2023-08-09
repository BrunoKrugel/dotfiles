---@diagnostic disable: need-check-nil
local create_cmd = vim.api.nvim_create_user_command
local settings = require("custom.chadrc").settings
local g = vim.g

local function setAutoCmp(mode)
  if mode then
    require("cmp").setup {
      completion = {
        autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged },
      },
    }
  else
    require("cmp").setup {
      completion = {
        autocomplete = false,
      },
    }
  end
end

--Open Peek
create_cmd("TPeek", function()
  require("peek").open()
end, {})

-- Toggle colorcolumn
create_cmd("ColorcolumnToggle", function()
  vim.g.ccenable = not vim.g.ccenable

  if vim.g.ccenable then
    vim.opt.cc = settings.cc_size
  else
    vim.opt.cc = "0"
  end
end, {})

-- Open DapUi
create_cmd("TDebug", function()
  require("dapui").toggle()
end, {})

-- Toggle CMP
g.cmptoggle = true
create_cmd("CmpToggle", function()
  g.cmptoggle = not g.cmptoggle
  if g.cmptoggle then
    vim.cmd 'echo  "CmpAutoComplete is on"'
    setAutoCmp(true)
  else
    vim.cmd 'echo  "CmpAutoComplete is off"'
    setAutoCmp(false)
  end
end, {})

-- Update nvim
create_cmd("TUpdate", function()
  require("lazy").load { plugins = { "mason.nvim", "nvim-treesitter" } }
  vim.cmd "MasonUpdate"
  vim.cmd "TSUpdate"
  vim.cmd "NvChadUpdate"
end, {})

-- Toggle Codeium
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
