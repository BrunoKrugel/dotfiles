local M = {}

M.cmp = {
  completion = {
    completeopt = "menu,menuone,noinsert,noselect",
    autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged },
    keyword_length = 2,
  },
  experimental = {
    ghost_text = {
      hl_group = "Comment",
    },
  },
  mapping = {
    ["<Up>"] = require("cmp").mapping.select_prev_item(),
    ["<Down>"] = require("cmp").mapping.select_next_item(),
    ["<Tab>"] = require("cmp").mapping(function(fallback)
      if require("luasnip").expandable() then
        require("luasnip").expand()
      elseif require("luasnip").expand_or_jumpable() then
        require("luasnip").expand_or_jump()
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
    ["<CR>"] = require("cmp").mapping {
      i = function(fallback)
        if require("cmp").visible() and require("cmp").get_active_entry() then
          require("cmp").confirm { behavior = require("cmp").ConfirmBehavior.Replace, select = false }
        else
          fallback()
        end
      end,
      s = require("cmp").mapping.confirm { select = true },
      c = require("cmp").mapping.confirm { behavior = require("cmp").ConfirmBehavior.Replace, select = true },
    },
    ["<ESC>"] = require("cmp").mapping(function(fallback)
      if require("cmp").visible() then
        require("cmp").abort()
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
  },
  performance = {
    debounce = 300,
    throttle = 60,
    max_view_entries = 10,
    fetching_timeout = 200,
  },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  sources = {
    {
      name = "copilot",
      max_item_count = 2,
    },
    {
      name = "codeium",
      max_item_count = 2,
    },
    {
      name = "cmp_tabnine",
      max_item_count = 2,
    },
    {
      name = "ctags",
      option = {
        executable = "ctags",
        trigger_characters = { "." },
      },
      keyword_length = 5,
      max_item_count = 2,
    },
    { name = "treesitter" },
    { name = "nvim_lsp_document_symbol" },
    { name = "luasnip", max_item_count = 2 },
    { name = "nvim_lua" },
    {
      name = "nvim_lsp",
      keyword_length = 5,
      entry_filter = function(entry, ctx)
        return require("cmp").lsp.CompletionItemKind.Text ~= entry:get_kind()
      end,
    },
  },
  matching = {
    disallow_fuzzy_matching = true,
    disallow_fullfuzzy_matching = true,
    disallow_partial_fuzzy_matching = true,
    disallow_partial_matching = false,
    disallow_prefix_unmatching = true,
  },
  -- sorting = {
  --   comparators = {
  --     -- require("cmp").config.compare.recently_used,
  --     -- require("cmp").config.compare.sort_text,
  --     require("cmp").config.compare.exact,
  --     require("cmp").config.compare.score,
  --     require("cmp").config.compare.kind,
  --     require("cmp").config.compare.length,
  --     require("cmp").config.compare.order,
  --   },
  -- },
}

return M
