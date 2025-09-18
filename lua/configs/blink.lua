local trigger_text = ";"
local M = {}

local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  if col == 0 then
    return false
  end
  local before = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(1, col)
  return not before:match "^%s*$"
end

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
      "supermaven",
      "lsp",
      "path",
    },
    providers = {
      lsp = { fallbacks = { "lazydev" } },
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        score_offset = 100,
      },
      supermaven = {
        module = "blink.compat.source",
        score_offset = 100,
        async = true,
      },
      snippets = {
        name = "snippets",
        enabled = true,
        max_items = 15,
        min_keyword_length = 2,
        module = "blink.cmp.sources.snippets",
        score_offset = 85, -- the higher the number, the higher the priority
        -- Only show snippets if I type the trigger_text characters, so
        -- to expand the "bash" snippet, if the trigger_text is ";" I have to
        should_show_items = function()
          local col = vim.api.nvim_win_get_cursor(0)[2]
          local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
          -- NOTE: remember that `trigger_text` is modified at the top of the file
          return before_cursor:match(trigger_text .. "%w*$") ~= nil
        end,
        -- After accepting the completion, delete the trigger_text characters
        -- from the final inserted text
        -- Modified transform_items function based on suggestion by `synic` so
        -- that the luasnip source is not reloaded after each transformation
        -- https://github.com/linkarzu/dotfiles-latest/discussions/7#discussion-7849902
        -- NOTE: I also tried to add the ";" prefix to all of the snippets loaded from
        -- friendly-snippets in the luasnip.lua file, but I was unable to do
        -- so, so I still have to use the transform_items here
        -- This removes the ";" only for the friendly-snippets snippets
        transform_items = function(_, items)
          local line = vim.api.nvim_get_current_line()
          local col = vim.api.nvim_win_get_cursor(0)[2]
          local before_cursor = line:sub(1, col)
          local start_pos, end_pos = before_cursor:find(trigger_text .. "[^" .. trigger_text .. "]*$")
          if start_pos then
            for _, item in ipairs(items) do
              if not item.trigger_text_modified then
                ---@diagnostic disable-next-line: inject-field
                item.trigger_text_modified = true
                item.textEdit = {
                  newText = item.insertText or item.label,
                  range = {
                    start = { line = vim.fn.line "." - 1, character = start_pos - 1 },
                    ["end"] = { line = vim.fn.line "." - 1, character = end_pos },
                  },
                }
              end
            end
          end
          return items
        end,
      },
    },
    per_filetype = {
      lua = { inherit_defaults = true, "lazydev" },
    },
    -- transform_items = function(_, items)
    --   return vim.tbl_filter(function(item)
    --     return item.kind ~= require("blink.cmp.types").CompletionItemKind.Snippet
    --   end, items)
    -- end,
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
        if not has_words_before() then
          return
        end

        local suggestion = require "supermaven-nvim.completion_preview"
        if suggestion.has_suggestion() then
          vim.schedule(function()
            suggestion.on_accept_suggestion()
          end)
        end
        return true
      end,
      -- "snippet_forward",
      -- "fallback",
    },
    ["<S-Tab>"] = { "snippet_backward", "fallback" },
    ["<Esc>"] = {
      -- function(cmp)
      --   if cmp.is_visible() then
      --     cmp.cancel()
      --   else
      --     vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-c>", true, true, true), "n", true)
      --   end
      -- end,
      "cancel",
      "fallback",
    },
    ["Enter"] = { "select_and_accept", "fallback" },
  },
}

return M
