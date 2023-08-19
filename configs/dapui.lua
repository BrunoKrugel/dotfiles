local dap, dapui = require "dap", require "dapui"
local core = require "custom.utils.core"

dapui.setup(core.dapui)

dap.listeners.before.event_initialized["dapui_config"] = function()
  local api = require "nvim-tree.api"
  local view = require "nvim-tree.view"
  if view.is_visible() then
    api.tree.close()
  end

  for _, winnr in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local bufnr = vim.api.nvim_win_get_buf(winnr)
    if vim.api.nvim_get_option_value("ft", { buf = bufnr }) == "dap-repl" then
      return
    end
  end
  dapui:open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
  vim.cmd "stopinsert"
  dapui:close()
end

dap.listeners.after.event_exited["dapui_config"] = function()
  vim.cmd "stopinsert"
  dapui:close()
end

vim.api.nvim_set_hl(0, "DapUIVariable",                          { fg="#F8F8F2" })
vim.api.nvim_set_hl(0, "DapUIScope",                             { fg="#52bdff" })
vim.api.nvim_set_hl(0, "DapUIValue",                             { fg="#F8F8F2" })
vim.api.nvim_set_hl(0, "DapUIModifiedValue",                     { fg="#F8F8F2" })
vim.api.nvim_set_hl(0, "DapUIDecoration",                        { fg="#5e5f69" })
vim.api.nvim_set_hl(0, "DapUIStoppedThread",                     { fg="#52bdff" })
vim.api.nvim_set_hl(0, "DapUIWatchesEmpty",                      { fg="#ff7070" })
vim.api.nvim_set_hl(0, "DapUIWatchesValue",                      { fg="#be95ff" })
vim.api.nvim_set_hl(0, "DapUIWatchesError",                      { fg="#ff7070" })
vim.api.nvim_set_hl(0, "DapUIBreakpointsPath",                   { fg="#52bdff" })
vim.api.nvim_set_hl(0, "DapUIBreakpointsInfo",                   { fg="#78a9ff" })
vim.api.nvim_set_hl(0, "DapUIBreakpointsCurrentLine",            { fg="#8BE9FD" })
vim.api.nvim_set_hl(0, "DapUIBreakpointsDisabledLine",           { fg="#5e5f69" })
vim.api.nvim_set_hl(0, "DapUIStepOver",                          { fg="#8BE9FD" })
vim.api.nvim_set_hl(0, "DapUIStepInto",                          { fg="#8BE9FD" })
vim.api.nvim_set_hl(0, "DapUIStepBack",                          { fg="#8BE9FD" })
vim.api.nvim_set_hl(0, "DapUIStepOut",                           { fg="#8BE9FD" })
vim.api.nvim_set_hl(0, "DapUIStop",                              { fg="#ff7070" })
vim.api.nvim_set_hl(0, "DapUIPlayPause",                         { fg="#50fa7b" })
vim.api.nvim_set_hl(0, "DapUIRestart",                           { fg="#50fa7b" })
vim.api.nvim_set_hl(0, "DapUIUnavailable",                       { fg="#5e5f69" })