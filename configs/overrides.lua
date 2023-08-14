local M = {}

M.devicons = {
  override_by_filename = {
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
    ["sum"] = {
      icon = "󰟓",
      color = "#cbcb40",
      cterm_color = "185",
      name = "Sum",
    },
    [".gitignore"] = {
      icon = "",
      color = "#e24329",
      cterm_color = "196",
      name = "GitIgnore",
    },
    ["js"] = {
      icon = "",
      color = "#cbcb41",
      cterm_color = "185",
      name = "Js",
    },
    ["lock"] = {
      icon = "",
      color = "#bbbbbb",
      cterm_color = "250",
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
      cterm_color = "250",
      name = "Tags",
    },
    ["http"] = {
      icon = "󰖟",
      color = "#519aba",
      name = "Http",
    },
  },
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
    use_virtual_text = false,
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
    "css-lsp",
    "html-lsp",
    "emmet-ls",

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
    "staticcheck",
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
  system_open = { cmd = "thunar" },
  sync_root_with_cwd = true,
  renderer = {
    highlight_opened_files = "name",
    highlight_git = true,
    group_empty = true,
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
  tab = {
    sync = {
      open = true,
      close = true,
    },
  },
}

M.telescope = {
  defaults = {
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
  },
  extensions_list = {
    "themes",
    "terms",
    "notify",
    "frecency",
    "undo",
    "vim_bookmarks",
    "harpoon",
    "noice",
    "ast_grep",
    "ctags_plus",
    "luasnip",
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
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
    lazy = {
      show_icon = true,
      mappings = {
        open_in_browser = "<C-o>",
        open_in_file_browser = "<M-b>",
        open_in_find_files = "<C-f>",
        open_in_live_grep = "<C-g>",
        open_plugins_picker = "<C-b>",
        open_lazy_root_find_files = "<C-r>f",
        open_lazy_root_live_grep = "<C-r>g",
      },
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
  },
}

return M
