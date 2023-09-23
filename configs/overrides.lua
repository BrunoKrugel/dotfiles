local M = {}

local function icon_multiple_filenames(filenames, opts)
  local overrides = {}
  for _, file in ipairs(filenames) do
    overrides[file] = opts
  end
  return overrides
end

local function filenames_list(filename, extensions)
  local filenames = {}
  for _, ext in ipairs(extensions) do
    table.insert(filenames, filename .. "." .. ext)
  end
  return filenames
end

M.devicons = {
  override_by_filename = vim.tbl_extend(
    "force",
    {
      ["makefile"] = {
        icon = "",
        color = "#f1502f",
        name = "Makefile",
      },
      ["mod"] = {
        icon = "󰟓",
        color = "#519aba",
        name = "Mod",
      },
      ["yarn.lock"] = {
        icon = "",
        color = "#0288D1",
        name = "Yarn",
      },
      ["sum"] = {
        icon = "󰟓",
        color = "#cbcb40",
        name = "Sum",
      },
      [".gitignore"] = {
        icon = "",
        color = "#e24329",
        name = "GitIgnore",
      },
      ["js"] = {
        icon = "",
        color = "#cbcb41",
        name = "Js",
      },
      ["lock"] = {
        icon = "",
        color = "#bbbbbb",
        name = "Lock",
      },
      ["package.json"] = {
        icon = "",
        color = "#e8274b",
        name = "PackageJson",
      },
      [".eslintignore"] = {
        icon = "󰱺",
        color = "#e8274b",
        name = "EslintIgnore",
      },
      ["tags"] = {
        icon = "",
        color = "#bbbbbb",
        name = "Tags",
      },
      ["http"] = {
        icon = "󰖟",
        color = "#519aba",
        name = "Http",
      },
    },
    icon_multiple_filenames(filenames_list("tailwind.config", { "js", "cjs", "ts", "cts" }), {
      icon = "󱏿",
      color = "#4DB6AC",
      name = "tailwind",
    }),
    icon_multiple_filenames(filenames_list("vite.config", { "js", "cjs", "ts", "cts" }), {
      icon = "󱐋",
      color = "#FFAB00",
      name = "ViteJS",
    }),
    icon_multiple_filenames(filenames_list(".eslintrc", { "js", "cjs", "yaml", "yml", "json" }), {
      icon = "",
      color = "#4b32c3",
      cterm_color = "56",
      name = "Eslintrc",
    })
  ),
}

M.treesitter = {
  auto_install = true,
  ensure_installed = {
    "vim",
    "lua",
    "bash",
    "json",
    "json5",
    "jq",
    "yaml",
    "java",
    "dockerfile",
    "regex",
    "toml",

    -- Markdown
    "markdown",
    "markdown_inline",
    -- Go Lang
    "go",
    "gomod",
    "gowork",
    "gosum",

    -- Web Dev
    "javascript",
    "typescript",
    "tsx",
    "html",
    "astro",
    "css",
  },
  indent = {
    enable = true,
  },
  playground = {
    enable = true,
  },
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = { "BufWrite", "CursorHold" },
  },
  textsubjects = {
    enable = true,
    keymaps = {
      ["."] = "textsubjects-smart",
      [";"] = "textsubjects-container-outer",
      ["i;"] = "textsubjects-container-inner",
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      include_surrounding_whitespace = true,
      keymaps = {
        ["af"] = { query = "@function.outer", desc = "ts: all function" },
        ["if"] = { query = "@function.inner", desc = "ts: inner function" },
        ["ac"] = { query = "@class.outer", desc = "ts: all class" },
        ["ic"] = { query = "@class.inner", desc = "ts: inner class" },
        ["aC"] = { query = "@conditional.outer", desc = "ts: all conditional" },
        ["iC"] = { query = "@conditional.inner", desc = "ts: inner conditional" },
        ["aH"] = { query = "@assignment.lhs", desc = "ts: assignment lhs" },
        ["aL"] = { query = "@assignment.rhs", desc = "ts: assignment rhs" },
      },
    },
  },
  tree_setter = {
    enable = true,
  },
  rainbow = {
    enable = true,
    extended_mode = false,
    max_file_lines = 1000,
    query = {
      "rainbow-parens",
      html = "rainbow-tags",
      javascript = "rainbow-tags-react",
      tsx = "rainbow-tags",
    },
  },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  autotag = {
    enable = true,
  },
}

M.mason = {
  ensure_installed = {
    -- lua stuff
    "lua-language-server",
    "stylua",

    -- web dev stuff
    "css-lsp",
    "html-lsp",
    "typescript-language-server",
    "prettier",
    "eslint-lsp",
    "emmet-ls",
    "rustywind",

    -- Spell
    "codespell",
    "marksman",
    "grammarly-languageserver",

    -- Json
    "jsonlint",
    "json-lsp",

    "dockerfile-language-server",
    "yaml-language-server",

    -- golang
    "gopls",
    "goimports",
    "golines",
    "gomodifytags",
    "impl",
    "iferr",
  },

  ui = {
    icons = {
      package_pending = " ",
      package_installed = "󰄳 ",
      package_uninstalled = "󰇚 ",
    },

    keymaps = {
      toggle_server_expand = "<CR>",
      install_server = "i",
      update_server = "u",
      check_server_version = "c",
      update_all_servers = "U",
      check_outdated_servers = "C",
      uninstall_server = "X",
      cancel_installation = "<C-c>",
    },
  },
}

M.nvterm = {
  terminals = {
    shell = vim.o.shell,
    list = {},
    type_opts = {
      float = {
        relative = "editor",
        row = 0.1,
        col = 0.1,
        width = 0.8,
        height = 0.7,
        border = "single",
      },
      horizontal = { location = "rightbelow", split_ratio = 0.3 },
      vertical = { location = "rightbelow", split_ratio = 0.25 },
    },
  },
  behavior = {
    autoclose_on_quit = {
      enabled = false,
      confirm = true,
    },
    close_on_exit = true,
    auto_insert = true,
  },
}

-- git support in nvimtree
M.nvimtree = {
  filters = {
    dotfiles = false,
    custom = {
      "**/node_modules",
      "**/%.git",
      "**/%.github",
    },
  },
  git = {
    enable = true,
    ignore = false,
  },
  hijack_unnamed_buffer_when_opening = true,
  hijack_cursor = true,
  diagnostics = {
    enable = false,
    show_on_dirs = false,
    debounce_delay = 50,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  sync_root_with_cwd = true,
  renderer = {
    highlight_opened_files = "name",
    highlight_git = true,
    -- root_folder_label = ":~",
    group_empty = true,
    indent_markers = {
      enable = false,
      icons = {
        corner = "└ ",
        edge = "│ ",
        none = "  ",
      },
    },
    icons = {
      show = {
        git = true,
      },
      glyphs = {
        git = {
          unstaged = "",
          -- unstaged = "",
          staged = "",
          unmerged = "",
          renamed = "➜",
          -- untracked = "",
          untracked = "",
          deleted = "",
          ignored = "◌",
        },
      },
    },
  },
  actions = {
    open_file = {
      quit_on_open = true,
      resize_window = false,
    },
  },
  tab = {
    sync = {
      open = true,
      close = true,
    },
  },
}

M.telescope = {
  defaults = {
    preview = {
      filetype_hook = function(_, bufnr, opts)
        -- don't display jank pdf previews
        if opts.ft == "pdf" then
          require("telescope.previewers.utils").set_preview_message(bufnr, opts.winid, "Not displaying " .. opts.ft)
          return false
        end
        return true
      end,
    },
    file_ignore_patterns = {
      "node_modules",
      ".docker",
      ".git",
      "yarn.lock",
      "go.sum",
      "go.mod",
      "tags",
      "mocks",
      "refactoring",
    },
    layout_config = {
      horizontal = {
        prompt_position = "bottom",
      },
    },
  },
  extensions_list = {
    "themes",
    "terms",
    "notify",
    "frecency",
    "undo",
    "vim_bookmarks",
    "ast_grep",
    "ctags_plus",
    "luasnip",
    "import",
    "dap",
  },
  extensions = {
    fzf = {
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
      fuzzy = true,
    },
    ast_grep = {
      command = {
        "sg",
        "--json=stream",
        "-p",
      },
      grep_open_files = false,
      lang = nil,
    },
    import = {
      insert_at_top = true,
    },
  },
}

local hl_list = {}
for i, color in pairs { "#662121", "#767621", "#216631", "#325a5e", "#324b7b", "#562155" } do
  local name = "IndentBlanklineIndent" .. i
  vim.api.nvim_set_hl(0, name, { fg = color })
  table.insert(hl_list, name)
end

M.blankline = {
  filetype_exclude = {
    "help",
    "terminal",
    "lspinfo",
    "TelescopePrompt",
    "TelescopeResults",
    "nvcheatsheet",
    "lsp-installer",
    "norg",
    "Empty",
    "Trouble",
    "lazy",
    "",
  },
  buftype_exclude = { "terminal", "nofile" },
  show_end_of_line = true,
  show_foldtext = true,
  show_trailing_blankline_indent = false,
  show_first_indent_level = true,
  show_current_context = true,
  show_current_context_start = true,
  -- Uncomment this line to enable rainbown identation
  -- char_highlight_list = hl_list,
}

M.colorizer = {
  filetypes = {
    "*",
    cmp_docs = { always_update = true },
    cmp_menu = { always_update = true },
  },
  user_default_options = {
    names = false,
    RRGGBBAA = true,
    rgb_fn = true,
    tailwind = true,
    RGB = true,
    RRGGBB = true,
    AARRGGBB = true,
    hsl_fn = true,
    css = true,
    css_fn = true,
    mode = "background",
    sass = { enable = true, parsers = { "css" } },
    mode = "background", -- Available methods are false / true / "normal" / "lsp" / "both"
    virtualtext = "■",
    always_update = true,
  },
}

return M
