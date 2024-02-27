-- Load defaults from NvChad
require("plugins.configs.lspconfig").defaults()

local finders = require "telescope.finders"
local pickers = require "telescope.pickers"
local make_entry = require "telescope.make_entry"
local conf = require("telescope.config").values
local builtin = require "telescope.builtin"

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

local function organize_imports(client, bufnr)
  local params = vim.lsp.util.make_range_params(nil, vim.lsp.util._get_offset_encoding())
  params.context = { only = { "source.organizeImports" } }

  local resp = client.request_sync("textDocument/codeAction", params, 3000, bufnr)
  for _, r in pairs(resp and resp.result or {}) do
    if r.edit then
      vim.lsp.util.apply_workspace_edit(r.edit, vim.lsp.util._get_offset_encoding())
    else
      vim.lsp.buf.execute_command(r.command)
    end
  end
end

local function attach_codelens(bufnr)
  local augroup = api.nvim_create_augroup("Lsp", {})
  api.nvim_create_autocmd({ "BufReadPost", "CursorHold", "InsertLeave" }, {
    group = augroup,
    buffer = bufnr,
    callback = function()
      vim.lsp.codelens.refresh { bufnr = bufnr }
    end,
  })
end

local custom_on_attach = function(client, bufnr)
  on_attach(client, bufnr)

  -- Enable inlay hints
  if vim.fn.has "nvim-0.10" then
    vim.lsp.inlay_hint.enable(bufnr, true)
  end

  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint(bufnr, true)
  end

  if client.supports_method "textDocument/codeLens" then
    require("virtualtypes").on_attach(client, bufnr)
  end

  -- Code lens
  if client.server_capabilities.codeLensProvider then
    attach_codelens(bufnr)
  end

  require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)

  -- Go
  vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = bufnr,
    pattern = "*.go",
    callback = function()
      organize_imports(client, bufnr)
      vim.lsp.buf.format { async = false }
    end,
  })
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

  ["astro"] = function()
    return {
      on_attach = custom_on_attach,
      capabilities = capabilities,
      init_options = {
        typescript = {
          tsdk = "node_modules/typescript/lib",
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

require("lspconfig.ui.windows").default_options.border = "single"

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
  signs = true,
  underline = false,
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
      vim.keymap.set("n", "<RightMouse>", "<LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>", opts)
    end
  end,
})
