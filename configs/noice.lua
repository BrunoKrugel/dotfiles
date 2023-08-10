local present, noice = pcall(require, "noice")

if not present then
  return
end

noice.setup {
  cmdline = {
    enabled = true,
    view = "cmdline_popup",
    format = {
      cmdline = { pattern = "^:", icon = "󰘳 ", lang = "vim" },
      search_down = { kind = "search", pattern = "^/", icon = "󰩊 ", lang = "regex" },
      search_up = { kind = "search", pattern = "^%?", icon = "󰩊 ", lang = "regex" },
      filter = { pattern = "^:%s*!", icon = "󰻿 ", lang = "bash" },
      lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
      help = { pattern = "^:%s*he?l?p?%s+", icon = "󰞋 " },
    },
  },
  popupmenu = {
    enabled = true, -- enables the Noice popupmenu UI
    backend = "cmp", -- backend to use to show regular cmdline completions
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
    signature = {
      enabled = true,
      auto_open = {
        enabled = true,
        trigger = true,
        luasnip = true,
        throttle = 50,
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
      },
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
