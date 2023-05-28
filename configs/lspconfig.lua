local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

-- if you just want default config for the servers then put them in a table
local servers = { "html", "cssls", "tsserver", "clangd", "eslint", "gopls", "jdtls", "astro" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

lspconfig.gopls.setup {
  on_attach = on_attach,
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  handlers = {
    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" }),
    ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" }),
  },
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
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "vue",
    "astro",
  },
  cmd = { "vscode-eslint-language-server", "--stdio" },
  handlers = {
    ["eslint/confirmESLintExecution"] = function(_, result)
      if not result then
        return
      end
      return 4 -- approved
    end,

    ["eslint/noLibrary"] = function()
      vim.notify("[lspconfig] Unable to find ESLint library.", vim.log.levels.WARN)
      return {}
    end,

    ["eslint/openDoc"] = function(_, result)
      if not result then
        return
      end
      local sysname = vim.loop.os_uname().sysname
      if sysname:match "Windows_NT" then
        os.execute(string.format("start %q", result.url))
      elseif sysname:match "Linux" then
        os.execute(string.format("xdg-open %q", result.url))
      else
        os.execute(string.format("open %q", result.url))
      end
      return {}
    end,

    ["eslint/probeFailed"] = function()
      vim.notify("[lspconfig] ESLint probe failed.", vim.log.levels.WARN)
      return {}
    end,
  },
  root_dir = require("lspconfig").util.root_pattern(
    ".eslintrc",
    ".eslintrc.js",
    ".eslintrc.cjs",
    ".eslintrc.yaml",
    ".eslintrc.yml",
    ".eslintrc.json",
    -- Disabled to prevent "No ESLint configuration found" exceptions
    "package.json"
  ),
  settings = {
    codeAction = {
      disableRuleComment = {
        enable = true,
        location = "separateLine",
      },
      showDocumentation = {
        enable = true,
      },
    },
    codeActionOnSave = {
      enable = false,
      mode = "all",
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
      mode = "location",
    },
  },
}

-- virtual text config
-- vim.diagnostic.config({
--   -- virtual_text = {
--   --   source = 'always',
--   --   prefix = '■',
--   --   -- Only show virtual text matching the given severity
--   --   severity = {
--   --     -- Specify a range of severities
--   --     min = vim.diagnostic.severity.ERROR,
--   --   },
--   -- },
--   virtual_text = false,
--   float = {
--     source = 'always',
--     border = 'rounded',
--   },
--   signs = true,
--   underline = false,
--   update_in_insert = false,
--   severity_sort = true,
-- })

