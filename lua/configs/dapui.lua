local dap, dapui, mason, dap_virtual_text =
  require "dap", require "dapui", require "mason-registry", pcall(require, "nvim-dap-virtual-text")
local function get_install_path(package)
  return mason.get_package(package):get_install_path()
end

local function vs_launch()
  local workfolder = vim.lsp.buf.list_workspace_folders()[1] or vim.fn.getcwd()

  local launch_json = (workfolder .. "/.vscode/launch.json")
  if vim.fn.filereadable(launch_json) == 1 then
    return true, launch_json
  else
    return false, launch_json
  end
end

local core = require "custom.utils.core"
dapui.setup(core.dapui)
-- require("dap.ext.vscode").load_launchjs "launch.json"

dap.adapters.go = {
  type = "executable",
  command = "node",
  args = { vim.fn.expand "$MASON" .. "/packages/go-debug-adapter/extension/dist/debugAdapter.js" },
}

dap.configurations.go = {
  {
    type = "go",
    name = "Debug: Go",
    request = "launch",
    showLog = false,
    program = "${workspaceFolder}/cmd/${workspaceFolderBasename}",
    dlvToolPath = vim.fn.exepath "dlv",
  },
}

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
end

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end

dap.listeners.after.disconnect["dapui_config"] = function()
  require("dap.repl").close()
  dapui.close()
  require("nvim-dap-virtual-text.virtual_text").clear_virtual_text()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
  require("nvim-dap-virtual-text.virtual_text").clear_virtual_text()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
  require("nvim-dap-virtual-text.virtual_text").clear_virtual_text()
end

local widgets = require "dap.ui.widgets"
vim.keymap.set("n", "<leader>ds", function()
  widgets.centered_float(widgets.scopes, { border = "rounded" })
end, { noremap = true })
vim.keymap.set("n", "<leader>du", function()
  widgets.centered_float(widgets.frames, { border = "rounded" })
end, { noremap = true })
