-- Load defaults from NvChad
require("nvchad.configs.lspconfig").defaults()

local methods = vim.lsp.protocol.Methods

local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init

local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

local ok, _ = pcall(require, "ufo")
if ok then
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }
end

---gopls_organize_imports will organize imports for the provided buffer
---@param client vim.lsp.Client gopls instance
---@param bufnr number buffer to organize imports for
local function organize_imports(client, bufnr)
  local gopls = vim.lsp.get_clients({ bufnr = 0, name = 'gopls' })

  local params = vim.lsp.util.make_range_params(0, gopls[1].offset_encoding)
  params.context = { only = { "source.organizeImports" } }

  local resp = client.request_sync("textDocument/codeAction", params, 3000, bufnr)
  for _, r in pairs(resp and resp.result or {}) do
    if r.edit then
      vim.lsp.util.apply_workspace_edit(r.edit, client.offset_encoding or "utf-16")
    else
      vim.lsp.buf.execute_command(r.command)
    end
  end
end

local function attach_codelens(_, bufnr)
  vim.api.nvim_create_autocmd({ "BufReadPost", "CursorHold", "InsertLeave" }, {
    buffer = bufnr,
    callback = function()
      vim.lsp.codelens.refresh { bufnr = bufnr }
    end,
  })
end

local custom_on_attach = function(client, bufnr)
  on_attach(client, bufnr)

  if client.server_capabilities.textDocument then
    if client.server_capabilities.textDocument.codeLens then
      require("virtualtypes").on_attach(client, bufnr)
      attach_codelens(client, bufnr)

      vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run, { buffer = bufnr, silent = true })
    end
  end

  if client.server_capabilities.signatureHelpProvider then
    vim.lsp.handlers["textDocument/signatureHelp"] = require("noice").signature
  end

  require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)

  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
    vim.api.nvim_clear_autocmds { buffer = bufnr, group = "lsp_document_highlight" }
    vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave" }, {
      desc = "Highlight references under the cursor",
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
      desc = "Clear highlight references",
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

local go_on_attach = function(client, bufnr)

  if client.name ~= "gopls" then
    return
  end

  custom_on_attach(client, bufnr)
  organize_imports(client, bufnr)

  vim.opt.formatprg = ""

  -- Go
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
      organize_imports(client, bufnr)
      -- vim.lsp.buf.format { async = false }
    end,
  })
end

-- Update mappings when registering dynamic capabilities.
local register_capability = vim.lsp.handlers[methods.client_registerCapability]
vim.lsp.handlers[methods.client_registerCapability] = function(err, res, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if not client then
    return
  end

  custom_on_attach(client, vim.api.nvim_get_current_buf())

  return register_capability(err, res, ctx)
end


-- if you just want default config for the servers then put them in a table
local servers = {
  "html",
  "cssls",
  "clangd",
  "astro",
  "marksman",
  "emmet_ls",
  "jsonls",
  "dockerls",
  "lua_ls",
  "vuels",
  "yamlls",
  "terraformls",
   "vtsls",
}

vim.lsp.handlers["textDocument/hover"] = require("noice").hover
vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
  local ts_lsp = { "ts_ls", "angularls", "volar", "vtsls" }
  local clients = vim.lsp.get_clients { id = ctx.client_id }
  if vim.tbl_contains(ts_lsp, clients[1].name) then
    local filtered_result = {
      diagnostics = vim.tbl_filter(function(d)
        return d.severity == 1
      end, result.diagnostics),
    }
    require("ts-error-translator").translate_diagnostics(err, filtered_result, ctx, config)
  end
  vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
end

require("mason-lspconfig").setup {
  ensure_installed = servers,
  automatic_installation = true,
}

-- for _, lsp in ipairs(servers) do
--   lspconfig[lsp].setup {
--     on_attach = on_attach,
--     capabilities = capabilities,
--   }
-- end

require("lspconfig").kulala_ls.setup {
  on_attach = custom_on_attach,
  capabilities = capabilities,
}

require("mason-lspconfig").setup_handlers {
  function(server_name)
    if server_name == "tsserver" then
      server_name = "ts_ls"
    end

    lspconfig[server_name].setup {
      on_attach = custom_on_attach,
      on_init = on_init,
      capabilities = capabilities,
    }
  end,

  ["jsonls"] = function()
    lspconfig["jsonls"].setup {
      on_attach = custom_on_attach,
      on_init = on_init,
      capabilities = capabilities,
      settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
        },
      },
    }
  end,

  ["terraformls"] = function()
    lspconfig["terraformls"].setup {
      on_attach = custom_on_attach,
      on_init = on_init,
      capabilities = capabilities,
    }
  end,

  ["vtsls"] = function()
    lspconfig["vtsls"].setup {
      on_attach = custom_on_attach,
      capabilities = capabilities,
      on_init = on_init,
      filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
        "astro",
      },
      settings = {
        complete_function_calls = true,
        vtsls = {
          enableMoveToFileCodeAction = true,
          autoUseWorkspaceTsdk = true,
          experimental = {
            completion = {
              enableServerSideFuzzyMatch = true,
              entriesLimit = 50,
            },
          },
        },
        javascript = {
          updateImportsOnFileMove = { enabled = "always" },
          suggest = { completeFunctionCalls = true },
        },
        typescript = {
          format = {
            indentSize = vim.o.shiftwidth,
            convertTabsToSpaces = vim.o.expandtab,
            tabSize = vim.o.tabstop,
          },
          preferences = {
            importModuleSpecifier = "non-relative",
            includePackageJsonAutoImports = "off",
            autoImportFileExcludePatterns = { ".git", "node_modules" },
          },
          updateImportsOnFileMove = { enabled = "always" },
          suggest = { completeFunctionCalls = true },
          inlayHints = {
            enumMemberValues = { enabled = true },
            functionLikeReturnTypes = { enabled = false },
            parameterNames = { enabled = "all" },
            parameterTypes = { enabled = false },
            propertyDeclarationTypes = { enabled = true },
            variableTypes = { enabled = false },
          },
        },
      },
    }
  end,

  ["lua_ls"] = function()
    lspconfig["lua_ls"].setup {
      on_attach = custom_on_attach,
      on_init = on_init,
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
      on_attach = go_on_attach,
      on_init = on_init,
      capabilities = capabilities,
      filetypes = { "go", "gomod", "gowork", "gosum", "goimpl" },
      init_options = {
        usePlaceholders = true,
      },
      settings = {
        gopls = {
          buildFlags = { "-tags=wireinject" },
          directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
          usePlaceholders = true,
          experimentalPostfixCompletions = true,
          completeUnimported = true,
          vulncheck = "Imports",
          gofumpt = true,
          staticcheck = true,
          semanticTokens = true,
          analyses = {
            fieldalignment = true,
            shadow = true,
            fillreturns = true,
            nonewvars = true,
            staticcheck = true,
            structure = true,
            unparam = true,
            deadcode = true,
            nilness = true,
            typeparams = true,

            unusedwrite = true,
            unusedparams = true,
            unusedresult = true,
          },
          codelenses = {
            references = true,
            test = true,
            tidy = true,
            upgrade_dependency = true,
            regenerate_cgo = true,
            generate = true,
            gc_details = false,
            run_govulncheck = true,
            vendor = true,
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
        },
      },
    }
  end,

  ["yamlls"] = function()
    return {
      lspconfig["yamlls"].setup {
        on_attach = custom_on_attach,
        on_init = on_init,
        capabilities = capabilities,
        settings = {
          yaml = {
            schemaStore = {
              url = vim.env.SCHEMA_NEXUS,
              enable = true,
            },
            schemas = {
              [vim.env.SCHEMA_BACKEND] = ".gitlab-ci.yml",
              [vim.env.SCHEMA_DOCKER] = ".gitlab-ci.yml",
              [vim.env.SCHEMA_HELM] = ".gitlab-ci.yml",
            },
          },
        },
      },
    }
  end,

  ["astro"] = function()
    return {
      lspconfig["astro"].setup {
        on_attach = custom_on_attach,
        capabilities = capabilities,
        init_options = {
          typescript = {
            tsdk = "node_modules/typescript/lib",
          },
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
          return {}
        end,

        ["eslint/openDoc"] = function(_, result)
          if not result then
            return
          end
          local sysname = vim.uv.os_uname().sysname
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

-- If the buffer has been edited before formatting has completed, do not try to apply the changes
vim.lsp.handlers["textDocument/formatting"] = function(err, result, ctx, _)
  if err ~= nil or result == nil then
    return
  end

  -- If the buffer hasn't been modified before the formatting has finished, update the buffer
  if not vim.api.nvim_buf_get_option(ctx.bufnr, "modified") then
    local view = vim.fn.winsaveview()
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    vim.lsp.util.apply_text_edits(result, ctx.bufnr, client.offset_encoding)
    vim.fn.winrestview(view)
    if ctx.bufnr == vim.api.nvim_get_current_buf() or not ctx.bufnr then
      vim.api.nvim_command "noautocmd :update"
    end
  end
end

require("lspconfig.ui.windows").default_options.border = "rounded"

local signs = { Error = "", Warn = "", Hint = "󰌵", Info = "" }

for type, icon in pairs(signs) do
  local hl = "Diagnostic" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local x = vim.diagnostic.severity
vim.diagnostic.config {

  virtual_lines = false,
  virtual_text = {
    prefix = "■",
    spacing = 2,
  },
  -- virtual_text = false,
  float = {
    border = "rounded",
    format = function(diagnostic)
      if diagnostic.source == "eslint" then
        return string.format(
          "%s [%s]",
          diagnostic.message,
          -- shows the name of the rule
          diagnostic.user_data.lsp.code
        )
      end

      local message = diagnostic.message

      if diagnostic.source then
        message = string.format("%s %s", diagnostic.message, diagnostic.source)
      end
      if diagnostic.code then
        message = string.format("%s[%s]", diagnostic.message, diagnostic.code)
      end

      return message
    end,
    suffix = function()
      return ""
    end,
    severity_sort = true,
    close_events = { "CursorMoved", "InsertEnter" },
  },
  signs = { text = { [x.ERROR] = "󰅙", [x.WARN] = "", [x.INFO] = "󰋼", [x.HINT] = "󰌵" } },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
}

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(event)
    -- Set up keymaps
    local opts = { buffer = event.buf, silent = true }
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    -- Mouse mappings for easily navigating code
    if client:supports_method "definitionProvider" then
      vim.keymap.set("n", "<2-LeftMouse>", function()
        vim.lsp.buf.definition()
      end, opts)
      vim.keymap.set("n", "<RightMouse>", '<LeftMouse><cmd>lua vim.lsp.buf.hover({border = "single"})<CR>', opts)
    end
  end,
})
