local present, lint = pcall(require, "linter")

if not present then
  return
end

local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  group = lint_augroup,
  callback = function()
    lint.try_lint()
  end,
})

lint.linters_by_ft = {
  lua = {
    "luacheck",
  },
  yaml = {
    "yamllint",
    "actionlint",
  },
  go = {
    "golangcilint",
  },
  codespell = { "codespell" },
  javascript = { "eslint_d" },
  typescript = { "eslint_d" },
  javascriptreact = { "eslint_d" },
  typescriptreact = { "eslint_d" },
}
