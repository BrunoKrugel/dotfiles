local dap, dapui = require "dap", require "dapui"
local core = require "custom.utils.core"

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

dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui:close()
end

dap.listeners.after.event_exited["dapui_config"] = function()
  dapui:close()
end