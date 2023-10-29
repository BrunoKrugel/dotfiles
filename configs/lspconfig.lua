-- Load defaults from NvChad
require("plugins.configs.lspconfig").defaults()

local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

local present, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if present then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

local ok, _ = pcall(require, "ufo")
if ok then
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }
end

local custom_on_attach = function(client, bufnr)
  on_attach(client, bufnr)

  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint(bufnr, true)
  end
end

local filter_list = function(list, predicate)
  local res_len = #list
  local move_item_by = 0

  for i = 1, res_len do
    local item = list[i]
    list[i] = nil
    if not predicate(item) then
      move_item_by = move_item_by - 1
    else
      list[i + move_item_by] = item
    end
  end
end

-- if you just want default config for the servers then put them in a table
local servers = {
  "html",
  "cssls",
  -- "tsserver",
  "clangd",
  -- "eslint",
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
      on_attach = custom_on_attach,
      capabilities = capabilities,
    }
  end,

  ["lua_ls"] = function()
    lspconfig["lua_ls"].setup {
      on_attach = custom_on_attach,
      capabilities = capabilities,
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT",
          },
          diagnostics = {
            globals = { "use", "vim" },
          },
          hint = {
            enable = true,
            setType = true,
          },
          telemetry = {
            enable = false,
          },
          workspace = {
            library = {
              [vim.fn.expand "$VIMRUNTIME/lua"] = true,
              [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
              [vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types"] = true,
              [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
            },
            maxPreload = 100000,
            preloadFileSize = 10000,
          },
        },
      },
    }
  end,

  ["gopls"] = function()
    lspconfig["gopls"].setup {
      on_attach = custom_on_attach,
      capabilities = capabilities,
      filetypes = { "go", "gomod", "gowork", "gosum", "goimpl" },
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
            fieldalignment = true,
            nilness = true,
            useany = true,
          },
          staticcheck = true,
          codelenses = {
            references = true,
            test = true,
            tidy = true,
            upgrade_dependency = true,
            regenerate_cgo = true,
            generate = true,
          },
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
          gofumpt = true,
        },
      },
    }
  end,

  ["eslint"] = function()
    lspconfig["eslint"].setup {
      on_attach = custom_on_attach,
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

vim.lsp.handlers["textDocument/inlayHint"] = function(result)
  filter_list(result, function(item)
    if
      item.label == "x:"
      or item.label == "y:"
      or item.label == "z:"
      or item.label == "a:"
      or item.label == "b:"
      or item.label == "v:"
      or item.label == "m:"
      or item.label == "s:"
      or item.label == "nptr:"
      or item.label == "scalar:"
      or item.lable == "argv0"
    then
      return false
    end
    -- local line = item.position.line
    -- local col = item.position.character
    -- local node = vim.treesitter.get_node({pos = {line,col}})
    -- I(vim.treesitter.get_node_text(node:parent(), 0))
    return true
  end)
  -- accept request.
  return true
end

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
