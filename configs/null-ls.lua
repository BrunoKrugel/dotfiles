local present, null_ls = pcall(require, "null-ls")

if not present then
  return
end

local b = null_ls.builtins

local sources = {
  -- b.formatting.deno_fmt.with {
  --   extra_args = {
  --     "--config",
  --     vim.fn.expand "~/.config/.deno.json",
  --   },
  -- },
  b.formatting.prettier,
  b.formatting.stylua.with {
    extra_args = { "--config-path", vim.fn.expand "~/.config/stylua.toml" },
  },
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
  -- b.formatting.lua_format,
  --  b.diagnostics.luacheck,
  -- b.diagnostics.checkstyle.with {
  --   extra_args = { "-c", "/google_checks.xml" },
  -- },
  b.formatting.yamlfmt,
  -- b.formatting.xmlformat,
  -- Diagnostics
  b.diagnostics.eslint,
  b.diagnostics.fish,
  b.diagnostics.checkmake,
  -- b.diagnostics.codespell,
  b.diagnostics.jsonlint,
  -- Completion
  b.completion.luasnip,
  -- Code actions
  b.code_actions.gitsigns,
  b.code_actions.gomodifytags,
  b.code_actions.eslint,
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

-- local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
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
