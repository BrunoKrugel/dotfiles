-- Load defaults from NvChad
require("nvchad.configs.lspconfig").defaults()

local finders = require "telescope.finders"
local pickers = require "telescope.pickers"
local make_entry = require "telescope.make_entry"
local conf = require("telescope.config").values
local builtin = require "telescope.builtin"

local on_attach = require("nvchad.configs.lspconfig").on_attach

local capabilities = vim.tbl_deep_extend(
  "force",
  vim.lsp.protocol.make_client_capabilities(),
  require("cmp_nvim_lsp").default_capabilities(),
  require("nvchad.configs.lspconfig").capabilities
)

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

---gopls_organize_imports will organize imports for the provided buffer
---@param client vim.lsp.Client gopls instance
---@param bufnr number buffer to organize imports for
local function organize_imports(client, bufnr)
  if client.name ~= "gopls" then
    return
  end

  local params = vim.lsp.util.make_range_params()
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

local function attach_codelens(client, bufnr)
  local augroup = vim.api.nvim_create_augroup("Lsp", {})
  vim.api.nvim_create_autocmd({ "BufReadPost", "CursorHold", "InsertLeave" }, {
    group = augroup,
    buffer = bufnr,
    callback = function()
      vim.lsp.codelens.refresh { bufnr = bufnr }
    end,
  })
end

local custom_on_attach = function(client, bufnr)
  on_attach(client, bufnr)

  if client.server_capabilities.workspace.didChangeWatchedFiles then
    client.server_capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
    client.server_capabilities.workspace.didChangeWatchedFiles.relativePatternSupport = true
  end

  -- if client.name == "gopls" then
  --   -- workaround for gopls not supporting semanticTokensProvider
  --   -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
  --   if not client.server_capabilities.semanticTokensProvider then
  --     local semantic = client.config.capabilities.textDocument.semanticTokens
  --     client.server_capabilities.semanticTokensProvider = {
  --       full = true,
  --       legend = {
  --         tokenTypes = semantic.tokenTypes,
  --         tokenModifiers = semantic.tokenModifiers,
  --       },
  --       range = true,
  --     }
  --   end
  -- end

  -- if client.server_capabilities.inlayHintProvider then
  --   vim.lsp.inlay_hint(bufnr, true)
  -- end

  if client.server_capabilities.textDocument then
    if client.server_capabilities.textDocument.codeLens then
      require("virtualtypes").on_attach(client, bufnr)
      attach_codelens(client, bufnr)
    end
  end

  if client.server_capabilities.signatureHelpProvider then
    vim.lsp.handlers["textDocument/signatureHelp"] = require("noice").signature
  end

  -- Code lens
  -- if client.server_capabilities.codeLensProvider then
  -- end

  require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)

  -- Go
  -- vim.api.nvim_create_autocmd("BufWritePre", {
  --   pattern = "*.go",
  --   callback = function()
  --     organize_imports(client, bufnr)
  --     vim.lsp.buf.format { async = false }
  --   end,
  -- })
end

local filter_list = function(list, predicate)
  -- empty list
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

-- If the LSP response includes any `node_modules`, then try to remove them and
-- see if there are any options left. We probably want to navigate to the code
-- in OUR codebase, not inside `node_modules`.
--
-- This can happen if a type is used to explicitly type a variable:
-- ```ts
-- const MyComponent: React.FC<Props> = () => <div />
-- ````
--
-- Running "Go to definition" on `MyComponent` would give the `React.FC`
-- definition in `node_modules/react` as the first result, but we don't want
-- that.
local function filter_out_libraries_from_lsp_items(results)
  local without_node_modules = vim.tbl_filter(function(item)
    return item.targetUri and not string.match(item.targetUri, "node_modules")
  end, results)

  if #without_node_modules > 0 then
    return without_node_modules
  end

  return results
end

local function filter_out_same_location_from_lsp_items(results)
  return vim.tbl_filter(function(item)
    local from = item.originSelectionRange
    local to = item.targetSelectionRange

    return not (
      from
      and from.start.character == to.start.character
      and from.start.line == to.start.line
      and from["end"].character == to["end"].character
      and from["end"].line == to["end"].line
    )
  end, results)
end

-- This function is mostly copied from Telescope, I only added the
-- `node_modules` filtering.
local function list_or_jump(action, title, opts)
  opts = opts or {}

  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0, action, params, function(err, result, ctx, _)
    if err then
      vim.api.nvim_err_writeln("Error when executing " .. action .. " : " .. err.message)
      return
    end
    local flattened_results = {}
    if result then
      -- textDocument/definition can return Location or Location[]
      if not vim.tbl_islist(result) then
        flattened_results = { result }
      end

      vim.list_extend(flattened_results, result)
    end

    -- This is the only added step to the Telescope function
    flattened_results = filter_out_same_location_from_lsp_items(filter_out_libraries_from_lsp_items(flattened_results))

    local offset_encoding = vim.lsp.get_client_by_id(ctx.client_id).offset_encoding

    if #flattened_results == 0 then
      return
    elseif #flattened_results == 1 and opts.jump_type ~= "never" then
      if opts.jump_type == "tab" then
        vim.cmd.tabedit()
      elseif opts.jump_type == "split" then
        vim.cmd.new()
      elseif opts.jump_type == "vsplit" then
        vim.cmd.vnew()
      end
      vim.lsp.util.jump_to_location(flattened_results[1], offset_encoding)
    else
      local locations = vim.lsp.util.locations_to_items(flattened_results, offset_encoding)
      pickers
        .new(opts, {
          prompt_title = title,
          finder = finders.new_table {
            results = locations,
            entry_maker = opts.entry_maker or make_entry.gen_from_quickfix(opts),
          },
          previewer = conf.qflist_previewer(opts),
          sorter = conf.generic_sorter(opts),
        })
        :find()
    end
  end)
end

local function definitions(opts)
  return list_or_jump("textDocument/definition", "LSP Definitions", opts)
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
  "marksman",
  "emmet_ls",
  "jsonls",
  "dockerls",
  "lua_ls",
  "vuels",
  "yamlls",
  "terraformls",
}

vim.lsp.handlers["textDocument/hover"] = require("noice").hover
vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
  local ts_lsp = { "ts_ls", "angularls", "volar" }
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

require("mason-lspconfig").setup_handlers {
  function(server_name)
    if server_name == "tsserver" then
      server_name = "ts_ls"
    end

    lspconfig[server_name].setup {
      on_attach = custom_on_attach,
      capabilities = capabilities,
    }
  end,

  ["jsonls"] = function()
    lspconfig["jsonls"].setup {
      on_attach = custom_on_attach,
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
      capabilities = capabilities,
    }
  end,

  -- disable tsserver
  ["tsserver"] = function() end,

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
          directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
          completeUnimported = true,
          vulncheck = "Imports",
          gofumpt = true,
          staticcheck = true,
          analyses = {
            nilness = true,
            shadow = true,
            unusedparams = true,
            unusewrites = true,
            fieldalignment = true,
            useany = true,
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
            -- schemas = require("schemastore").yaml.schemas {
            --   extra = {
            --     {
            --       description = "My custom backend JSON schema",
            --       fileMatch = ".gitlab-ci.yml",
            --       url = vim.env.SCHEMA_BACKEND,
            --     },
            --     {
            --       description = "My custom docker JSON schema",
            --       fileMatch = ".gitlab-ci.yml",
            --       url = vim.env.SCHEMA_DOCKER,
            --     },
            --     {
            --       description = "My custom helm JSON schema",
            --       fileMatch = ".gitlab-ci.yml",
            --       url = vim.env.SCHEMA_HELM,
            --     },
            --   },
            -- },
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

-- vim.lsp.handlers["textDocument/inlayHint"] = function(result)
--   filter_list(result, function(item)
--     if
--       item.label == "x:"
--       or item.label == "y:"
--       or item.label == "z:"
--       or item.label == "a:"
--       or item.label == "b:"
--       or item.label == "v:"
--       or item.label == "m:"
--       or item.label == "s:"
--       or item.label == "nptr:"
--       or item.label == "scalar:"
--       or item.lable == "argv0"
--     then
--       return false
--     end
--     -- local line = item.position.line
--     -- local col = item.position.character
--     -- local node = vim.treesitter.get_node({pos = {line,col}})
--     -- I(vim.treesitter.get_node_text(node:parent(), 0))
--     return true
--   end)
--   -- accept request.
--   return true
-- end

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
  },
  -- virtual_text = false,
  float = {
    border = "rounded",
    format = function(diagnostic)
      if diagnostic.source == "" then
        return diagnostic.message
      end
      if diagnostic.source == "eslint" then
        return string.format(
          "%s [%s]",
          diagnostic.message,
          -- shows the name of the rule
          diagnostic.user_data.lsp.code
        )
      end
      return string.format("%s [%s]", diagnostic.message, diagnostic.source)
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

    vim.keymap.set("n", "<c-}>", function()
      definitions()
    end, opts)

    -- Mouse mappings for easily navigating code
    if client.supports_method "definitionProvider" then
      vim.keymap.set("n", "<2-LeftMouse>", "<LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>", opts)
      vim.keymap.set("n", "<RightMouse>", '<LeftMouse><cmd>lua vim.lsp.buf.hover({border = "single"})<CR>', opts)
    end
  end,
})

local function best_diagnostic(diagnostics)
  if vim.tbl_isempty(diagnostics) then
    return
  end

  local best = nil
  local line_diagnostics = {}
  local line_nr = vim.api.nvim_win_get_cursor(0)[1] - 1

  for k, v in pairs(diagnostics) do
    if v.lnum == line_nr then
      line_diagnostics[k] = v
    end
  end

  for _, diagnostic in ipairs(line_diagnostics) do
    if best == nil then
      best = diagnostic
    elseif diagnostic.severity < best.severity then
      best = diagnostic
    end
  end

  return best
end

local function current_line_diagnostics()
  local bufnr = 0
  local line_nr = vim.api.nvim_win_get_cursor(0)[1] - 1
  local opts = { ["lnum"] = line_nr }

  return vim.diagnostic.get(bufnr, opts)
end

local virt_handler = vim.diagnostic.handlers.virtual_text
local ns = vim.api.nvim_create_namespace "current_line_virt"
local severity = vim.diagnostic.severity
local virt_options = {
  prefix = "",
  format = function(diagnostic)
    local message = vim.split(diagnostic.message, "\n")[1]

    if diagnostic.severity == severity.ERROR then
      return signs.Error .. message
    elseif diagnostic.severity == severity.INFO then
      return signs.Info .. message
    elseif diagnostic.severity == severity.WARN then
      return signs.Warn .. message
    elseif diagnostic.severity == severity.HINT then
      return signs.Hint .. message
    else
      return message
    end
  end,
}

vim.diagnostic.handlers.current_line_virt = {
  show = function(_, bufnr, diagnostics, _)
    local diagnostic = best_diagnostic(diagnostics)
    if not diagnostic then
      return
    end

    local filtered_diagnostics = { diagnostic }

    virt_handler.hide(ns, vim.api.nvim_get_current_buf())
    pcall(virt_handler.show, ns, bufnr, filtered_diagnostics, { virtual_text = virt_options })
  end,
  hide = function(_, bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    virt_handler.hide(ns, bufnr)
  end,
}

-- vim.api.nvim_create_augroup("lsp_diagnostic_current_line", {
--   clear = true,
-- })

-- vim.api.nvim_clear_autocmds {
--   group = "lsp_diagnostic_current_line",
-- }

-- vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
--   group = "lsp_diagnostic_current_line",
--   callback = function()
--     vim.diagnostic.handlers.current_line_virt.show(nil, 0, current_line_diagnostics(), nil)
--   end,
-- })

-- local line = nil
-- vim.api.nvim_create_autocmd("CursorMoved", {
--   group = "lsp_diagnostic_current_line",
--   callback = function()
--     local next_line = vim.api.nvim_win_get_cursor(0)[1] - 1

--     if line ~= next_line then
--       line = next_line
--       vim.diagnostic.handlers.current_line_virt.hide(nil, nil)
--     end
--   end,
-- })
