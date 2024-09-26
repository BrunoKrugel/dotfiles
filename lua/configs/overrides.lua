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
      ["yml"] = {
        icon = "",
        color = "#EF9C66",
        name = "Yml",
      },
      ["yaml"] = {
        icon = "",
        color = "#EF9C66",
        name = "Yaml",
      },
      ["scm"] = {
        icon = "",
        color = "#90a850",
        name = "Query",
      },
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
      ["astro"] = {
        icon = "",
        color = "#f1502f",
        name = "Astro",
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
    "luadoc",
    "bash",
    "json",
    "json5",
    "jq",
    "yaml",
    "java",
    "dockerfile",
    "regex",
    "toml",

    "gitcommit",
    "git_config",
    "diff",

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
    swap = {
      enable = true,
      swap_next = {
        ["sa"] = "@parameter.inner",
      },
      swap_previous = {
        ["sA"] = "@parameter.inner",
      },
    },
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
  tree_setter = {
    enable = true,
  },
  indent = {
    enable = true,
  },
  playground = {
    enable = true,
  },
}

M.mason = {
  ui = {
    icons = {
      package_pending = " ",
      package_installed = "󰄳 ",
      package_uninstalled = "󰇚 ",
    },

    border = "rounded",
    width = 0.8,
    height = 0.8,

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
    show_on_dirs = true,
    show_on_open_dirs = false,
  },
  hijack_unnamed_buffer_when_opening = true,
  hijack_cursor = true,
  diagnostics = {
    enable = true,
    show_on_dirs = true,
    debounce_delay = 50,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  view = {
    preserve_window_proportions = true,
    width = {
      min = 40,
      padding = 2,
    },
    signcolumn = "no",
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
      git_placement = "after",
      show = {
        git = true,
        bookmarks = false,
        diagnostics = false,
        file = true,
        folder = true,
        folder_arrow = true,
        modified = true,
      },
      web_devicons = {
        folder = {
          enable = true, -- Special folder devicon icons
          color = true,
        },
      },
      -- git_placement = 'signcolumn',
      glyphs = {
        default = "󰈚",
        symlink = "",
        modified = "",
        folder = {
          default = "",
          empty = "",
          empty_open = "",
          open = "",
          symlink = "",
          symlink_open = "",
          arrow_open = " ",
          arrow_closed = " ",
        },
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

local telescope = require "telescope"
local actions = require "telescope.actions"
local previewers = require "telescope.previewers"

local new_maker = function(filepath, bufnr, opts)
  opts = opts or {}
  filepath = vim.fn.expand(filepath)
  vim.uv.fs_stat(filepath, function(_, stat)
    if not stat then
      return
    end
    if stat.size > 100000 then
      return
    else
      previewers.buffer_previewer_maker(filepath, bufnr, opts)
    end
  end)
end

local focus_preview = function(prompt_bufnr)
  local action_state = require "telescope.actions.state"
  local picker = action_state.get_current_picker(prompt_bufnr)
  local prompt_win = picker.prompt_win
  local previewer = picker.previewer
  local winid = previewer.state.winid
  local bufnr = previewer.state.bufnr
  vim.keymap.set("n", "<Tab>", function()
    vim.cmd(string.format("noautocmd lua vim.api.nvim_set_current_win(%s)", prompt_win))
  end, { buffer = bufnr })
  vim.cmd(string.format("noautocmd lua vim.api.nvim_set_current_win(%s)", winid))
  -- api.nvim_set_current_win(winid)
end

local select_one_or_multi = function(prompt_bufnr)
  local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
  local multi = picker:get_multi_selection()
  if not vim.tbl_isempty(multi) then
    require("telescope.actions").close(prompt_bufnr)
    for _, j in pairs(multi) do
      if j.path ~= nil then
        vim.cmd(string.format("%s %s", "edit", j.path))
      end
    end
  else
    require("telescope.actions").select_default(prompt_bufnr)
  end
end

M.telescope = {
  pickers = {
    find_files = {
      find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
    },
    buffers = {
      theme = "dropdown",
      previewer = false,
      mappings = {
        i = {
          ["<c-d>"] = "delete_buffer",
        },
      },
    },
  },
  defaults = {
    mappings = {
      i = {
        ["<C-k>"] = actions.move_selection_previous, -- move to prev result
        ["<C-j>"] = actions.move_selection_next, -- move to next result
        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<CR>"] = select_one_or_multi,
        ["<Tab>"] = focus_preview,
      },
    },
    path_display = {
      filename_first = {
        reverse_directories = true,
      },
    },
    buffer_previewer_maker = new_maker,
    multi_icon = "",
    prompt_prefix = "󰼛 ",
    selection_caret = "󱞩 ",
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
      ".docker",
      ".git/",
      ".git\\",
      "yarn.lock",
      "go.sum",
      "go.mod",
      "tags",
      "mocks",
      "refactoring",
      "^.git/",
      "^./.git/",
      "^node_modules/",
      "node_modules\\",
      "^build/",
      "^dist/",
      "^target/",
      "^vendor/",
      "^lazy%-lock%.json$",
      "^package%-lock%.json$",
    },
    layout_config = {
      horizontal = {
        prompt_position = "bottom",
      },
    },
  },
  extensions_list = {
    "themes",
    "undo",
    "ast_grep",
    "ctags_plus",
    "luasnip",
    "fzf",
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

return M
