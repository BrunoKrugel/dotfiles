local conform = require "conform"

---@param bufnr integer
---@param ... string
---@return string
local function first(bufnr, ...)
  for i = 1, select("#", ...) do
    local formatter = select(i, ...)
    if conform.get_formatter_info(formatter, bufnr).available then
      return formatter
    end
  end
  return select(1, ...)
end

conform.setup {
  notify_on_error = false,
  kulala = {
    command = "kulala-fmt",
    args = { "$FILENAME" },
    stdin = false,
  },
  formatters_by_ft = {
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    json = { "prettier" },
    jsonc = { "prettier" },
    css = { "prettier" },
    html = { "prettier" },
    markdown = { "prettier" },
    query = { 'format-queries' },
    lua = { "stylua" },
    http = { "kulala" },
    go = function(bufnr)
      return { first(bufnr, "goimports", "gofumpt") }
    end,
    ["vue"] = { "prettier" },
    ["scss"] = { "prettier" },
    ["less"] = { "prettier" },
    ["yaml"] = { "prettier" },
    ["markdown.mdx"] = { "prettier" },
    ["graphql"] = { "prettier" },
    ["handlebars"] = { "prettier" },
  },
}
