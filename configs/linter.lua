local present, lint = pcall(require, "linter")

if not present then
  return
end

-- Tests
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
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
}
