local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

-- if you just want default config for the servers then put them in a table
local servers = {
  "html",
  "cssls",
  "tsserver",
  "clangd",
  "eslint",
  "jdtls",
  "astro",
  "gopls",
  "grammarly",
  "marksman",
  "emmet_ls",
  "yamlls",
  "jsonls",
  "dockerls",
  "lua_ls",
  "vuels",
}

require("mason-lspconfig").setup {
  ensure_installed = servers,
}

-- for _, lsp in ipairs(servers) do
--   lspconfig[lsp].setup {
--     on_attach = on_attach,
--     capabilities = capabilities,
--   }
-- end

require("mason-lspconfig").setup_handlers {
  function(server_name)
    lspconfig[server_name].setup {
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)
      end,
      capabilities = capabilities,
    }
  end,

  ["lua_ls"] = function()
    lspconfig["lua_ls"].setup {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT",
          },
          diagnostics = {
            globals = { "use", "vim" },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
          },
          hint = {
            enable = true,
            setType = true,
          },
          telemetry = {
            enable = false,
          },
        },
      },
    }
  end,

  ["tsserver"] = function()
    lspconfig["tsserver"].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      single_file_support = true,
      init_options = {
        preferences = {
          includeCompletionsWithSnippetText = true,
          includeCompletionsWithInsertText = true,
        },
      },
      settings = {
        completions = {
          completeFunctionCalls = true,
        },
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
        javascript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
        preferences = {
          importModuleSpecifierPreference = "non-relative",
          upddateImportsOnFileMove = "always",
        },
      },
    }
  end,

  ["gopls"] = function()
    lspconfig["gopls"].setup {
      on_attach = on_attach,
      filetypes = { "go", "gomod", "gowork", "gosum", "goimpl" },
      capabilities = capabilities,
      settings = {
        gopls = {
          buildFlags = { "-tags=wireinject" },
          usePlaceholders = true,
          completeUnimported = true,
          vulncheck = "Imports",
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
  end,

  ["eslint"] = function()
    lspconfig["eslint"].setup {
      on_attach = on_attach,
      capabilities = capabilities,
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
  end,
}

vim.lsp.handlers["textDocument/hover"] = require("noice").hover
vim.lsp.handlers["textDocument/signatureHelp"] = require("noice").signature

vim.diagnostic.config {
  virtual_lines = false,
  virtual_text = {
    source = "always",
    prefix = "■",
  },
  -- virtual_text = false,
  float = {
    source = "always",
    border = "rounded",
  },
  signs = true,
  underline = false,
  update_in_insert = false,
  severity_sort = true,
}
