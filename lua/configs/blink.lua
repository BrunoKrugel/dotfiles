local M = {}
-- WIP
M.blink = {
  signature = {
    enabled = false,
  },
  completion = {
    ghost_text = {
      enabled = false,
      show_with_menu = false,
      show_with_selection = false,
      show_without_selection = false,
      show_without_menu = false,
    },
    list = {
      max_items = 5,
      selection = {
        preselect = false,
        auto_insert = false,
      },
      cycle = {
        from_bottom = true,
        from_top = true,
      },
    },
    accept = {
      auto_brackets = {
        enabled = false,
      },
    },
    trigger = {
      prefetch_on_insert = true,
      show_on_keyword = false,
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 500,
    },
    menu = {
      draw = {
        align_to = "cursor",
        columns = { { "kind_icon" }, { "label", gap = 1 }, { "kind" } },
        components = {
          label = {
            text = function(ctx)
              return require("colorful-menu").blink_components_text(ctx)
            end,
            highlight = function(ctx)
              return require("colorful-menu").blink_components_highlight(ctx)
            end,
          },
        },
      },
    },
  },
  enabled = function()
    if require("cmp_dap").is_dap_buffer() then
      return "force"
    end
    return true
  end,
  sources = {
    default = {
      "lsp",
      "path",
    },
    providers = {
      lsp = { fallbacks = { "lazydev" } },
      lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
    },
    transform_items = function(_, items)
      return vim.tbl_filter(function(item)
        return item.kind ~= require("blink.cmp.types").CompletionItemKind.Snippet
      end, items)
    end,
  },
  fuzzy = {
    sorts = {
      "exact",
      "score",
      "sort_text",
    },
  },
  keymap = {
    preset = "super-tab",
    ["<Up>"] = { "select_prev", "fallback" },
    ["<Down>"] = { "select_next", "fallback" },
    ["<Tab>"] = {
      function(_)
        local suggestion = require "supermaven-nvim.completion_preview"
        if suggestion.has_suggestion() then
          suggestion.on_accept_suggestion()
        end
      end,
      -- "snippet_forward",
      "fallback",
    },
    ["<S-Tab>"] = { "snippet_backward", "fallback" },
    ["<Esc>"] = {
      function(cmp)
        if cmp.is_visible() then
          cmp.cancel()
        else
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-c>", true, true, true), "n", true)
        end
      end,
      "hide",
      "fallback",
    },
    ["Enter"] = { "select_and_accept", "fallback" },
  },
}

return M
