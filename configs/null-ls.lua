local present, null_ls = pcall(require, "null-ls")

if not present then
  return
end

local b = null_ls.builtins

local sources = {
  b.formatting.deno_fmt,                                                    -- choosed deno for ts/js files cuz its very fast!
  b.formatting.prettier.with { filetypes = { "html", "markdown", "css" } }, -- so prettier works only on these filetypes
  b.formatting.clang_format,
  b.formatting.stylua,
  b.code_actions.gitsigns,
  -- Go
  -- b.formatting.gofmt,
  b.formatting.gofumpt,
  b.formatting.tidy,
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
  -- b.diagnostics.checkstyle.with {
  --   extra_args = { "-c", "/google_checks.xml" },
  -- },
  b.formatting.yamlfmt,
  -- b.formatting.xmlformat,
  b.completion.luasnip,
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

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup {
  debug = true,
  sources = sources,

  -- on_attach = function(client, bufnr)
  --   if client.supports_method("textDocument/formatting") then
  --       vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
  --       vim.api.nvim_create_autocmd("BufWritePre", {
  --           group = augroup,
  --           buffer = bufnr,
  --           callback = function()
  --               vim.lsp.buf.format({ bufnr = bufnr })
  --           end,
  --       })
  --   end
  -- end,
}
