local present, lspconfig = pcall(require, "lspconfig")

if not present then
  return
end

lspconfig.gopls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    gopls = {
      buildFlags = { "-tags=wireinject" },
      usePlaceholders = true,
      analyses = {
         nilness = true,
         shadow = true,
         unusedparams = true,
         unusewrites = true,
      },
      staticcheck = true,
      codelenses = {
         references = true,
         test = true,
         tidy = true,
         upgrade_dependency = true,
         generate = true,
      },
      gofumpt = true,
    },
  },
}