local present, null_ls = pcall(require, "null-ls")

if not present then
  return
end

local b = null_ls.builtins

local goimports = b.formatting.goimports
local e = os.getenv "GOIMPORTS_LOCAL"
if e ~= nil then
  goimports = goimports.with { extra_args = { "-local", e } }
end

local sources = {
  -- Go
	null_ls.builtins.formatting.gofmt,
	null_ls.builtins.formatting.gofumpt,
	null_ls.builtins.formatting.goimports,
	null_ls.builtins.formatting.goimports_reviser,
  null_ls.builtins.diagnostics.golangci_lint,
  --null_ls.builtins.diagnostics.revive,
  --null_ls.builtins.formatting.golines,

  -- Lua
  b.formatting.stylua,

  -- Shell
  b.formatting.shfmt,
  b.diagnostics.shellcheck.with { diagnostics_format = "#{m} [#{c}]" },
}

null_ls.setup {
  debug = false,
  sources = sources,
}