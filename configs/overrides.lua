local M = {}

local cmp = require "cmp"

M.devicons = {
  override_by_filename = {
    ["makefile"] = {
      icon = "",
      color = "#f1502f",
      cterm_color = "239",
      name = "Makefile",
    },
    ["mod"] = {
      icon = "",
      color = "#519aba",
      name = "Mod",
    },
    ["sum"] = {
      icon = "",
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
    ["tags"] = {
      icon = "",
      color = "#bbbbbb",
      cterm_color = "250",
      name = "Tags",
    },
  },
}

M.treesitter = {
  ensure_installed = {
    "lua",
    "bash",
    "json",
    "html",
    "json5",
    "gomod",
    "gowork",
    "go",
    "gosum",
    "yaml",
    "javascript",
    "java",
    "vim",
    "regex",
    "markdown",
    "markdown_inline",
    "tsx",
    "typescript",
    "astro",
  },
  indent = {
    enable = true,
    disable = {
      "python",
    },
  },
  playground = {
    enable = true,
  },
  rainbow = {
    enable = true,
    extended_mode = false,
    max_file_lines = 1000,
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

    "gopls",
    "goimports",
  },
}

-- git support in nvimtree
M.nvimtree = {
  filters = {
    -- dotfiles = true,
    custom = { "node_modules" },
  },
  git = {
    enable = true,
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
    file_ignore_patterns = { "node_modules", ".docker", ".git", "yarn.lock" },
  },
  extensions_list = { "themes", "terms", "notify", "frecency", "undo", "vim_bookmarks", "harpoon" },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
}

M.alpha = {
  -- header = {
  --   val = {
  --     "   🭇🬭🬭🬭🬭🬭🬭🬭🬭🬼    ",
  --     "  🭉🭁🭠🭘    🭣🭕🭌🬾   ",
  --     "  🭅█ ▁     █🭐  ",
  --     "  ██🬿      🭊██   ",
  --     " 🭋█🬝🮄🮄🮄🮄🮄🮄🮄🮄🬆█🭀   ",
  --     " 🭤🭒🬺🬹🬱🬭🬭🬭🬭🬵🬹🬹🭝🭙   ",
  --     "                 ",
  --   },
  -- },
  header = {
    val = {
      [[                                           ,o88888 ]],
      [[                                        ,o8888888' ]],
      [[                  ,:o:o:oooo.        ,8O88Pd8888"  ]],
      [[              ,.::.::o:ooooOoOoO. ,oO8O8Pd888'"    ]],
      [[            ,.:.::o:ooOoOoOO8O8OOo.8OOPd8O8O"      ]],
      [[           , ..:.::o:ooOoOOOO8OOOOo.FdO8O8"        ]],
      [[          , ..:.::o:ooOoOO8O888O8O,COCOO"          ]],
      [[         , . ..:.::o:ooOoOOOO8OOOOCOCO"            ]],
      [[          . ..:.::o:ooOoOoOO8O8OCCCC"o             ]],
      [[             . ..:.::o:ooooOoCoCCC"o:o             ]],
      [[             . ..:.::o:o:,cooooCo"oo:o:            ]],
      [[          `   . . ..:.:cocoooo"'o:o:::'            ]],
      [[          .`   . ..::ccccoc"'o:o:o:::'             ]],
      [[         :.:.    ,c:cccc"':.:.:.:.:.'              ]],
      [[       ..:.:"'`::::c:"'..:.:.:.:.:.'               ]],
      [[     ...:.'.:.::::"'    . . . . .'                 ]],
      [[    .. . ....:."' `   .  . . ''                    ]],
      [[  . . . ...."'                                     ]],
      [[  .. . ."'                                         ]],
    },
  },
}

M.blankline = {
  filetype_exclude = {
    "help",
    "terminal",
    "alpha",
    "packer",
    "lspinfo",
    "TelescopePrompt",
    "TelescopeResults",
    "nvchad_cheatsheet",
    "lsp-installer",
    "norg",
    "Empty",
  },
  show_end_of_line = true,
  show_foldtext = true,
  show_trailing_blankline_indent = false,
  show_first_indent_level = false,
  show_current_context = true,
  show_current_context_start = true,
  vim.api.nvim_set_hl(0, "IndentBlanklineContextChar", { nocombine = true, fg = "none" }),
  vim.api.nvim_set_hl(0, "IndentBlanklineContextStart", { nocombine = false, underline = false, special = "none" }),
}

M.cmp = {
  mapping = {
    ["<Up>"] = require("cmp").mapping.select_prev_item(),
    ["<Down>"] = require("cmp").mapping.select_next_item(),
    ["<Tab>"] = {},
    -- ["<Tab>"] = require("cmp").mapping(function(fallback)
    --   local luasnip = require "luasnip"
    --   local copilot_keys = vim.fn["copilot#Accept"]()
    --   if require("cmp").visible() then
    --     require("cmp").select_next_item()
    --   elseif luasnip.expand_or_jumpable() then
    --     luasnip.expand_or_jump()
    --   elseif copilot_keys ~= "" and type(copilot_keys) == "string" then
    --     vim.api.nvim_feedkeys(copilot_keys, "i", true)
    --     -- vim.api.nvim_feedkeys(vim.fn['copilot#Accept'](vim.api.nvim_replace_termcodes('<Tab>', true, true, true)), 'n', true)
    --   else
    --     fallback()
    --   end
    -- end, {
    --   "i",
    --   "s",
    -- }),
  },
  sources = {
    { name = "copilot" },
    { name = "nvim_lsp" },
    { name = "cmp_tabnine" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "nvim_lua" },
    { name = "path" },
    { name = "treesitter" },
    { name = "buffer" },
    { name = "nvim_lsp_signature_help" },
    { name = "nvim_lsp_document_symbol" },
    { name = "emoji" },
    { name = "calc" },
    { name = "path" },
    { name = "vim_lsp" },
  },
}

return M
