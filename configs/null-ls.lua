local present, null_ls = pcall(require, "null-ls")

if not present then
  return
end

local b = null_ls.builtins

local sources = {

  -- webdev stuff
  b.formatting.deno_fmt, -- choosed deno for ts/js files cuz its very fast!
  b.formatting.prettier.with { filetypes = { "html", "markdown", "css" } }, -- so prettier works only on these filetypes

  -- Lua
  b.formatting.stylua,

  -- cpp
  b.formatting.clang_format,

  -- Go
  -- null_ls.builtins.formatting.gofmt,
  -- null_ls.builtins.formatting.gofumpt,
  -- null_ls.builtins.formatting.goimports,
  -- null_ls.builtins.formatting.goimports_reviser,
  -- null_ls.builtins.diagnostics.golangci_lint,
  -- null_ls.builtins.diagnostics.revive,
  -- null_ls.builtins.formatting.golines.with({
  --   extra_args = {
  --     "--max-len=180",
  --     "--base-formatter=gofumpt",
  --   },
  -- }),
  -- null_ls.builtins.diagnostics.eslint_d.with({
  --   diagnostics_format = '[eslint] #{m}\n(#{c})'
  -- }),
  -- null_ls.builtins.code_actions.eslint,
  -- null_ls.builtins.diagnostics.eslint,
  -- null_ls.builtins.formatting.lua_format,
  --  null_ls.builtins.diagnostics.luacheck,
  null_ls.builtins.completion.luasnip,
  null_ls.builtins.formatting.prettierd  
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
