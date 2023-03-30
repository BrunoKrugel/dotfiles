local present, null_ls = pcall(require, "null-ls")

if not present then
  return
end

local b = null_ls.builtins

local sources = {

  -- webdev stuff
  b.formatting.deno_fmt, -- choosed deno for ts/js files cuz its very fast!
  b.formatting.prettier.with { filetypes = { "html", "markdown", "css" } }, -- so prettier works only on these filetypes

  -- cpp
  b.formatting.clang_format,
  b.formatting.stylua,
  -- b.formatting.lua_format,
  -- Go
  -- b.formatting.gofmt,
  -- b.formatting.gofumpt,
  -- b.formatting.goimports,
  -- b.formatting.goimports_reviser,
  -- b.diagnostics.golangci_lint,
  -- b.diagnostics.revive,
  -- b.formatting.golines.with({
  --   extra_args = {
  --     "--max-len=180",
  --     "--base-formatter=gofumpt",
  --   },
  -- }),
  -- b.diagnostics.eslint_d.with({
  --   diagnostics_format = '[eslint] #{m}\n(#{c})'
  -- }),
  -- b.code_actions.eslint,
  -- b.diagnostics.eslint,
  -- b.formatting.lua_format,
  --  b.diagnostics.luacheck,
  b.completion.luasnip,
  b.formatting.prettierd,
}

-- local goimports = b.formatting.goimports
-- local e = os.getenv "GOIMPORTS_LOCAL"
-- if e ~= nil then
--   goimports = goimports.with { extra_args = { "-local", e } }
-- end
-- table.insert(sources, goimports)

-- for go.nvim
-- local gotest = require("go.null_ls").gotest()
-- local gotest_codeaction = require("go.null_ls").gotest_action()
-- local golangci_lint = require("go.null_ls").golangci_lint()
-- table.insert(sources, gotest)
-- table.insert(sources, golangci_lint)
-- table.insert(sources, gotest_codeaction)

null_ls.setup {
  debug = true,
  sources = sources,
}
