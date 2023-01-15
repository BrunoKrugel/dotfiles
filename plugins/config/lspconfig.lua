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

lspconfig.eslint.setup {
  on_attach = on_attach,
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "vue", "astro" },
  cmd = { "vscode-eslint-language-server", "--stdio" },
  handlers = {
    ["eslint/confirmESLintExecution"] = function(_, result)
      if not result then
        return
      end
      return 4 -- approved
    end,

    ["eslint/noLibrary"] = function()
      vim.notify('[lspconfig] Unable to find ESLint library.', vim.log.levels.WARN)
      return {}
    end,

    ["eslint/openDoc"] = function(_, result)
      if not result then
        return
      end
      local sysname = vim.loop.os_uname().sysname
      if sysname:match 'Windows' then
        os.execute(string.format('start %q', result.url))
      elseif sysname:match 'Linux' then
        os.execute(string.format('xdg-open %q', result.url))
      else
        os.execute(string.format('open %q', result.url))
      end
      return {}
    end,

    ["eslint/probeFailed"] = function()
      vim.notify('[lspconfig] ESLint probe failed.', vim.log.levels.WARN)
      return {}
    end,
},
  settings = {
    codeAction = {
      disableRuleComment = {
        enable = true,
        location = "separateLine"
      },
      showDocumentation = {
        enable = true
      }
    },
    codeActionOnSave = {
      enable = false,
      mode = "all"
    },
    format = true,
    nodePath = "",
    onIgnoredFiles = "off",
    packageManager = "npm",
    quiet = false,
    rulesCustomizations = {},
    run = "onType",
    useESLintClass = false,
    validate = "on",
    workingDirectory = {
      mode = "location"
    }
  },
}