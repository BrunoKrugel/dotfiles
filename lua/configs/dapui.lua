local has_dap, dap = pcall(require, "dap")
if not has_dap then
  return
end

local has_dapui, dapui = pcall(require, "dapui")
if not has_dapui then
  return
end

local has_dap_virtual_text, dap_virtual_text = pcall(require, "nvim-dap-virtual-text")
if not has_dap_virtual_text then
  return
end

-- local core = require "custom.utils.core"
-- dapui.setup(core.dapui)

dofile(vim.g.base46_cache .. "dap")

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
  -- dapui:open()
end

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
  dap_virtual_text.refresh()
end

dap.listeners.after.disconnect["dapui_config"] = function()
  require("dap.repl").close()
  dapui.close()
  dap_virtual_text.refresh()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
  dap_virtual_text.refresh()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
  dap_virtual_text.refresh()
end
