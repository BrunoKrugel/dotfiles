---@diagnostic disable: undefined-field
vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

-- Install lazy if not in path
if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
    config = function()
      require "options"
    end,
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
  dofile(vim.g.base46_cache .. v)
end

-- Re-activate providers
for _, v in ipairs { "python3_provider", "node_provider" } do
  vim.g["loaded_" .. v] = nil
  vim.cmd("runtime " .. v)
end

require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

-- @Custom
require "custom.utils.usercmd"
require "custom.utils.autocmd"

if vim.g.neovide and vim.fn.getcwd() == "/" then
  vim.cmd "cd ~"
end

vim.fn.sign_define("DapBreakpoint", { text = "󰙧", numhl = "DapBreakpoint", texthl = "DapBreakpoint" })
vim.fn.sign_define("DagLogPoint", { text = "", numhl = "DapLogPoint", texthl = "DapLogPoint" })
vim.fn.sign_define("DapStopped", { text = "", numhl = "DapStopped", texthl = "DapStopped" })
vim.fn.sign_define(
  "DapBreakpointRejected",
  { text = "", numhl = "DapBreakpointRejected", texthl = "DapBreakpointRejected" }
)
vim.fn.sign_define(
  "DapBreakpointCondition",
  { text = "", numhl = "DapBreakpointCondition", texthl = "DapBreakpointCondition" }
)
