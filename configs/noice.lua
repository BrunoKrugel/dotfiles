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
      },
      opts = { skip = true },
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
  },
  lsp = {
    progress = {
      enabled = false,
    },
    hover = {
      enabled = true,
    },
    signature = {
      enabled = true,
      auto_open = {
        enabled = true,
        trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
        luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
        throttle = 50, -- Debounce lsp signature help request by 50ms
      },
      view = nil, -- when nil, use defaults from documentation
      ---@type NoiceViewOptions
      opts = {
        focusable = false,
        size = {
          max_height = 15,
          max_width = 60,
        },
        win_options = {
          wrap = false,
        },
      }, -- merged with defaults from documentation
    },
    documentation = {
      opts = {
        border = {
          padding = { 0, 0 },
        },
      },
    },
    override = {
      -- override the default lsp markdown formatter with Noice
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      -- override the lsp markdown formatter with Noice
      ["vim.lsp.util.stylize_markdown"] = true,
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
    bottom_search = true,
    command_palette = true,
    lsp_doc_border = true,
    inc_rename = true,
  },
}
