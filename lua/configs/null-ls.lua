local present, null_ls = pcall(require, "null-ls")

if not present then
  return
end

local b = null_ls.builtins

local sources = {
  -- Formatting
  b.formatting.prettier,
  b.formatting.rustywind,
  b.formatting.yamlfmt,
  b.formatting.stylua.with {
    extra_args = { "--config-path", vim.fn.expand "~/.config/stylua.toml" },
  },
  b.formatting.gofumpt,
  b.formatting.tidy,
  b.formatting.goimports,
  
  
  -- Completion
  b.completion.luasnip,

  -- Code actions
  b.code_actions.gomodifytags,
  b.code_actions.impl,
  b.code_actions.eslint,
  b.code_actions.refactoring,
}

-- From go.nvim
-- table.insert(sources, require("go.null_ls").golangci_lint())
-- table.insert(sources, require("go.null_ls").gotest())
-- table.insert(sources, require("go.null_ls").gotest_action())

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
