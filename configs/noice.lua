local present, noice = pcall(require, "noice")

if not present then
  return
end

noice.setup {
  cmdline = {
    format = {
      search_down = { kind = "search", pattern = "^/", icon = "", lang = "regex" },
      search_up = { kind = "search", pattern = "^%?", icon = "", lang = "regex" },
    },
  },
  routes = {
    {
      filter = {
        event = "msg_show",
        kind = "",
        find = "written",
      },
      opts = { skip = true },
    },
    {
      filter = {
        event = "msg_show",
        find = "%d+L, %d+B",
      },
      view = "mini",
    },
    {
      filter = { event = "msg_show", find = "Hunk %d+ of %d+" },
      view = "mini",
    },
    {
      filter = { event = "msg_show", find = "%d+ more lines" },
      opts = { skip = true },
    },
    {
      filter = { event = "msg_show", find = "%d+ lines yanked" },
      opts = { skip = true },
    },
    {
      filter = { event = "msg_show", kind = "quickfix" },
      view = "mini",
    },
    {
      filter = { event = "msg_show", kind = "search_count" },
      view = "mini",
    },
    {
      filter = { event = "msg_show", kind = "wmsg" },
      view = "mini",
    },
    {
      filter = {
        any = {
          {
            event = "msg_show",
            kind = "",
            find = "%d+ change;",
          },
          {
            event = "msg_show",
            kind = "",
            find = "%d+ line less;",
          },
          {
            event = "msg_show",
            kind = "",
            find = "%d+ fewer lines;?",
          },
          {
            event = "msg_show",
            kind = "",
            find = "%d+ more lines?;",
          },
          {
            event = "msg_show",
            kind = "",
            find = '".+" %d+L, %d+B',
          },
        },
      },
      opts = { skip = true },
    },
    -- {
    -- 	filter = {
    -- 		cond = function()
    -- 			return not focused
    -- 		end,
    -- 	},
    -- 	view = "notify",
    -- 	opts = { stop = false },
    -- },
  },
  lsp = {
    progress = {
      enabled = false,
    },
    hover = {
      enabled = false,
    },
    signature = {
      enabled = false,
    },
    override = {
      -- override the default lsp markdown formatter with Noice
      ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
      -- override the lsp markdown formatter with Noice
      ["vim.lsp.util.stylize_markdown"] = false,
      -- override cmp documentation with Noice (needs the other options to work)
      ["cmp.entry.get_documentation"] = true,
    },
  },
  notify = {
    enabled = true,
    view = "notify",
  },
  commands = {
    history = {
      view = "split",
      opts = { enter = true, format = "details" },
      filter = {
        any = {
          { event = "notify" },
          { error = true },
          { warning = true },
          { event = "msg_show", kind = { "" } },
          { event = "lsp", kind = "message" },
        },
      },
    },
    last = {
      view = "popup",
      opts = { enter = true, format = "details" },
      filter = {
        any = {
          { event = "notify" },
          { error = true },
          { warning = true },
          { event = "msg_show", kind = { "" } },
          { event = "lsp", kind = "message" },
        },
      },
      filter_opts = { count = 1 },
    },
    errors = {
      view = "popup",
      opts = { enter = true, format = "details" },
      filter = { error = true },
      filter_opts = { reverse = true },
    },
  },
  ---@type NoiceConfigViews
  views = {
    cmdline_popup = {
      position = {
        row = 5,
        col = "50%",
      },
      size = {
        width = 60,
        height = "auto",
      },
    },
    popupmenu = {
      relative = "editor",
      position = {
        row = 8,
        col = "50%",
      },
      size = {
        width = 60,
        height = 10,
      },
      border = {
        style = "rounded",
        padding = { 0, 1 },
      },
      win_options = {
        winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
      },
    },
    mini = {
      zindex = 100,
      win_options = { winblend = 0 },
    },
  },
  presets = {
    -- bottom_search = true,
    command_palette = true,
    -- long_message_to_split = true,
    -- inc_rename = true,
    -- cmdline_output_to_split = false,
    lsp_doc_border = true,
    inc_rename = true,
  },
  -- format = {
  --   level = {
  --     icons = true,
  --   },
  -- },
}
