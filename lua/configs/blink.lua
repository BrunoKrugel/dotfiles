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
      scrollbar = false,
    },
  },
  sources = {
    default = {
      "lsp",
      "path",
    },
    providers = {
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        score_offset = 100,
      },
    },
    per_filetype = {
      lua = { inherit_defaults = true, "lazydev" },
    },
  },
  fuzzy = {
    sorts = {
      "exact",
      "score",
      "sort_text",
    },
  },
  keymap = {
    -- preset = "enter",
    ["<Up>"] = { "select_prev", "fallback" },
    ["<Down>"] = { "select_next", "fallback" },
    ["<Tab>"] = {
      function()
        if require("copilot.suggestion").is_visible() then
          return require("copilot.suggestion").accept()
        end
      end,
      function() -- sidekick next edit suggestion
        return require("sidekick").nes_jump_or_apply()
      end,
      -- "snippet_forward",
      "fallback",
    },
    ["<S-Tab>"] = { "snippet_backward", "fallback" },
    ["<Esc>"] = {
      "cancel",
      "fallback",
    },
    ["<CR>"] = { "select_and_accept", "fallback" },
  },
}

return M
