local dap, dapui = require "dap", require "dapui"

local function vs_launch()
  local workfolder = vim.lsp.buf.list_workspace_folders()[1] or vim.fn.getcwd()

  local launch_json = (workfolder .. "/.vscode/launch.json")
  if vim.fn.filereadable(launch_json) == 1 then
    return true, launch_json
  else
    return false, launch_json
  end
end

-- Load launch.json into nvim-dap
local function load_launch_json(path)
  local ok, err = pcall(function()
    -- Clear existing Go configs to prevent duplicates
    require("dap").configurations.go = nil

    require("dap.ext.vscode").json_decode = require("json5").parse

    -- local json = require "plenary.json"
    -- vscode.json_decode = function(str)
    --   return vim.json.decode(json.json_strip_comments(str))
    -- end

    -- require("dap.ext.vscode").load_launchjs(path)
    local dlv_path = vim.fn.exepath "dlv"

    -- Fallback to common locations if exepath fails
    if dlv_path == "" then
      local possible_paths = {
        vim.fn.expand "$HOME/go/bin/dlv",
        "/usr/local/bin/dlv",
        "/opt/homebrew/bin/dlv",
      }
      for _, p in ipairs(possible_paths) do
        if vim.fn.executable(p) == 1 then
          dlv_path = p
          break
        end
      end
    end

    for lang, lang_cfgs in pairs(require("dap").configurations) do
      if lang == "go" then
        for i, cfg in ipairs(lang_cfgs) do
          if cfg.mode == "auto" then
            -- dap does not support "auto"
            require("dap").configurations[lang][i].mode = nil
          end
          -- Always set dlvToolPath to ensure it's present
          require("dap").configurations[lang][i].dlvToolPath = dlv_path
        end
      end
    end
  end)
  if not ok then
    vim.notify("Failed to load " .. path .. ": " .. tostring(err), vim.log.levels.WARN)
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

-- === Load VSCode launch.json if it exists, otherwise use fallback ===
do
  local exists, launch_json = vs_launch()
  if exists then
    load_launch_json(launch_json)
  else
    -- vim.notify("No .vscode/launch.json found in workspace", vim.log.levels.INFO)
    -- Only set fallback config if no launch.json exists
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
  end
end

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
