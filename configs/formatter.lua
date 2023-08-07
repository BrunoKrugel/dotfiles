local present, formatter = pcall(require, "formatter")

if not present then
  return
end

local formatter_utils = require "formatter.util"

local fixjson = require("formatter.filetypes.json").fixjson
local eslint = require "formatter.defaults.eslint_d"
local stylua = require("formatter.filetypes.lua").stylua

local prettier = function()
  return {
    exe = "prettier",
    args = {
      "--stdin-filepath",
      formatter_utils.escape_path(formatter_utils.get_current_buffer_file_path()),
      "--tab-width 4",
    },
    stdin = true,
    try_node_modules = true,
  }
end

local javascript = function()
  if vim.loop.fs_stat ".eslintrc.js" == nil then
    return prettier()
  end

  return eslint()
end

local stylelint = function()
  return {
    exe = "stylelint",
    args = {
      "--fix",
    },
    stdin = false,
    try_node_modules = true,
  }
end

formatter.setup {
  filetype = {
    go = {
      require("formatter.filetypes.go").gofmt,
      require("formatter.filetypes.go").goimports,
    },
    lua = {
      stylua,
    },
    toml = {
      require("formatter.filetypes.toml").taplo,
    },
    json = {
      fixjson,
      prettier,
    },
    yaml = {
      prettier,
    },
    typescript = {
      javascript,
    },
    javascript = {
      javascript,
    },
    javascriptreact = {
      javascript,
    },
    typescriptreact = {
      javascript,
    },
    css = {
      prettier,
      stylelint,
    },
    markdown = {
      prettier,
    },
    ["*"] = {
      require("formatter.filetypes.any").remove_trailing_whitespace,
    },
  },
}
