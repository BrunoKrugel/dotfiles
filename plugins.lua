local overrides = require "custom.configs.overrides"

---@type NvPluginSpec[]
local plugins = {
  ----------------------------------------- default plugins ------------------------------------------
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
          require "custom.configs.null-ls"
        end,
      },
      "ray-x/lsp_signature.nvim",
      {
        "folke/neodev.nvim",
        opts = {},
        config = function()
          require("neodev").setup {}
        end,
      },
    },
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
  {
    "folke/which-key.nvim",
    enabled = true,
  },
  ----------------------------------------- override plugins ------------------------------------------
  {
    "williamboman/mason.nvim",
    opts = overrides.mason,
  },
  {
    "nvim-tree/nvim-web-devicons",
    -- dependencies = { "justinhj/battery.nvim", config = true },
    opts = overrides.devicons,
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = overrides.telescope,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "debugloop/telescope-undo.nvim",
      "tom-anders/telescope-vim-bookmarks.nvim",
      "tsakirist/telescope-lazy.nvim",
      "nvim-telescope/telescope-dap.nvim",
      "yagiziskirik/AirSupport.nvim",
      {
        "edolphin-ydf/goimpl.nvim",
        ft = "go",
      },
      {
        "ThePrimeagen/harpoon",
        cmd = "Harpoon",
      },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      {
        "nvim-telescope/telescope-frecency.nvim",
        dependencies = { "kkharji/sqlite.lua" },
      },
      { "JoosepAlviste/nvim-ts-context-commentstring", event = "BufRead" },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = overrides.blankline,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "windwp/nvim-ts-autotag",
      "chrisgrieser/nvim-various-textobjs",
    },
    opts = overrides.treesitter,
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },
  {
    "NvChad/nvim-colorizer.lua",
    opts = overrides.colorizer,
  },
  {
    "hrsh7th/nvim-cmp",
    opts = overrides.cmp,
    dependencies = {
      "hrsh7th/cmp-emoji",
      -- "hrsh7th/cmp-calc",
      -- "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      -- "hrsh7th/cmp-nvim-lua",
      "f3fora/cmp-spell",
      -- "hrsh7th/cmp-vsnip",
      "delphinus/cmp-ctags",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "hrsh7th/cmp-copilot",
      "ray-x/cmp-treesitter",
      {
        "hrsh7th/cmp-cmdline",
        event = "CmdLineEnter",
      },
      { "jcdickinson/codeium.nvim", config = true },
      {
        "tzachar/cmp-tabnine",
        build = "./install.sh",
        config = function()
          local tabnine = require "cmp_tabnine.config"
          tabnine:setup {} -- put your options here
        end,
      },
      {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        config = function(_, opts)
          require("plugins.configs.others").luasnip(opts) -- from default luasnip conf

          local luasnip = require "luasnip"

          luasnip.filetype_extend("javascriptreact", { "html" })
          require("luasnip/loaders/from_vscode").lazy_load() -- from default luasnip conf
        end,
      },
    },
  },
  {
    "karb94/neoscroll.nvim",
    keys = { "<C-d>", "<C-u>" },
    config = function()
      require("neoscroll").setup { mappings = {
        "<C-u>",
        "<C-d>",
      } }
    end,
  },
  ----------------------------------------- enhance plugins ------------------------------------------
  {
    "Pocco81/auto-save.nvim",
    event = "BufReadPost",
    config = function()
      require "custom.configs.autosave"
    end,
  },
  {
    "hiphish/rainbow-delimiters.nvim",
    event = "BufReadPost",
    config = function()
      local rainbow_delimiters = require "rainbow-delimiters"

      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = rainbow_delimiters.strategy["global"],
          vim = rainbow_delimiters.strategy["local"],
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      }
    end,
  },
  {
    "ethanholz/nvim-lastplace",
    event = "BufReadPost",
    config = function()
      require("nvim-lastplace").setup {
        lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
        lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
        lastplace_open_folds = true,
      }
    end,
  },
  {
    "gbprod/cutlass.nvim",
    event = "BufReadPost",
    opts = {
      cut_key = "x",
      override_del = true,
      exclude = {},
      registers = {
        select = "_",
        delete = "_",
        change = "_",
      },
    },
  },
  {
    "smoka7/multicursors.nvim",
    dependencies = {
      "smoka7/hydra.nvim",
    },
    event = "VeryLazy",
    config = true,
  },
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },
  -- {
  --   "gennaro-tedesco/nvim-possession",
  --   lazy = false,
  --   dependencies = {
  --     "ibhagwan/fzf-lua",
  --   },
  --   config = function()
  --     require("nvim-possession").setup {
  --       autoload = true,
  --       autosave = true,
  --       sessions = {
  --         sessions_icon = "",
  --       },
  --     }
  --   end,
  -- },
  {
    "code-biscuits/nvim-biscuits",
    event = "BufRead",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require "custom.configs.biscuits"
    end,
  },
  {
    "rainbowhxch/accelerated-jk.nvim",
    event = "BufReadPost",
    config = function()
      require "custom.configs.accelerated"
    end,
  },
  {
    "m-demare/hlargs.nvim",
    event = "BufWinEnter",
    config = function()
      require("hlargs").setup()
    end,
  },
  {
    "MattesGroeger/vim-bookmarks",
    cmd = "BookmarkToggle",
  },
  {
    "RRethy/vim-illuminate",
    event = { "CursorHold", "CursorHoldI" },
    dependencies = "nvim-treesitter",
    config = function()
      require "custom.configs.illuminate"
    end,
  },
  {
    "phaazon/hop.nvim",
    cmd = { "HopWord", "HopLine", "HopLineStart", "HopWordCurrentLine" },
    branch = "v2",
    config = function()
      require("hop").setup { keys = "etovxqpdygfblzhckisuran" }
    end,
  },
  {
    "nguyenvukhang/nvim-toggler",
    event = "BufReadPost",
    config = function()
      require("nvim-toggler").setup {
        -- removes the default <leader>i keymap
        remove_default_keybinds = true,
      }
    end,
  },
  { "tpope/vim-surround", event = "VeryLazy" },
  {
    "declancm/vim2vscode",
    cmd = "Code",
  },
  {
    "nvim-treesitter/playground",
    cmd = "TSCaptureUnderCursor",
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufWinEnter",
    config = function()
      require "custom.configs.context"
    end,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "theHamsta/nvim-dap-virtual-text",
        config = function()
          require "custom.configs.virtual-text"
        end,
      },
      {
        "rcarriga/nvim-dap-ui",
        config = function()
          require "custom.configs.dapui"
        end,
      },
    },
  },
  {
    "melkster/modicator.nvim",
    event = "BufWinEnter",
    config = function()
      require "custom.configs.modicator"
    end,
  },
  { "HampusHauffman/bionic.nvim", cmd = { "Bionic" } },
  {
    "lukas-reineke/virt-column.nvim",
    event = "BufReadPost",
    config = function()
      require("virt-column").setup {
        char = "┃",
        -- virtcolumn = "120",
      }
    end,
  },
  {
    "rest-nvim/rest.nvim",
    ft = { "http" },
    config = function()
      require("rest-nvim").setup {
        result_split_horizontal = true,
      }
    end,
  },
  {
    "zbirenbaum/neodim",
    event = "LspAttach",
    branch = "v2",
    config = function()
      require("neodim").setup {
        refresh_delay = 75,
        alpha = 0.75,
        blend_color = "#000000",
        hide = { underline = true, virtual_text = true, signs = true },
        priority = 150,
        disable = {},
      }
    end,
  },
  {
    "TobinPalmer/rayso.nvim",
    cmd = { "Rayso" },
    config = function()
      require("rayso").setup {
        open_cmd = "chrome",
      }
    end,
  },
  {
    "Wansmer/treesj",
    event = "BufReadPost",
    config = function()
      require("treesj").setup {
        use_default_keymaps = true,
      }
    end,
  },
  -- {
  --   "nvim-zh/colorful-winsep.nvim",
  --   event = { "WinNew" },
  --   config = function()
  --     require("colorful-winsep").setup {
  --       -- highlight for Window separator
  --       highlight = {
  --         bg = "#16161E",
  --         fg = "#1F3442",
  --       },
  --       -- timer refresh rate
  --       interval = 30,
  --       -- This plugin will not be activated for filetype in the following table.
  --       no_exec_files = { "packer", "TelescopePrompt", "mason", "CompetiTest", "NvimTree" },
  --       -- Symbols for separator lines, the order: horizontal, vertical, top left, top right, bottom left, bottom right.
  --       symbols = { "━", "┃", "┏", "┓", "┗", "┛" },
  --       close_event = function()
  --         -- Executed after closing the window separator
  --       end,
  --       create_event = function()
  --         -- Executed after creating the window separator
  --       end,
  --     }
  --   end,
  -- },
  ----------------------------------------- ui plugins ------------------------------------------
  {
    "folke/noice.nvim",
    event = "UIEnter",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require "custom.configs.noice"
    end,
  },
  -- {
  --   "kosayoda/nvim-lightbulb",
  --   event = "LspAttach",
  --   config = function()
  --     require("nvim-lightbulb").setup {
  --       autocmd = { enabled = true },
  --       sign = {
  --         enabled = true,
  --         text = "",
  --         hl = "LightBulbSign",
  --     },
  --     }
  --   end,
  -- },
  {
    "Pocco81/true-zen.nvim",
    cmd = { "TZAtaraxis" },
    config = function()
      require("true-zen").setup {}
    end,
  },
  {
    "petertriho/nvim-scrollbar",
    event = "BufReadPost",
    config = true,
  },
  {
    "folke/todo-comments.nvim",
    event = "BufReadPost",
    config = function()
      require "custom.configs.todo"
    end,
  },
  {
    "chikko80/error-lens.nvim",
    ft = "go",
    config = true,
  },
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    config = function()
      require "custom.configs.trouble"
    end,
  },
  {
    "jonahgoldwastaken/copilot-status.nvim",
    dependencies = { "copilot.lua" },
    event = "BufReadPost",
    config = function()
      require("copilot_status").setup {
        icons = {
          idle = " ",
          error = " ",
          offline = " ",
          warning = "𥉉 ",
          loading = " ",
        },
        debug = false,
      }
    end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    event = "VeryLazy",
    config = function()
      require("telescope").load_extension "ui-select"
    end,
  },
  { "rainbowhxch/beacon.nvim", event = "BufReadPost" },
  {
    "echasnovski/mini.nvim",
    event = "VeryLazy",
    config = function()
      require("mini.animate").setup {
        scroll = {
          enable = false,
        },
      }
    end,
  },
  {
    "gorbit99/codewindow.nvim",
    event = "VeryLazy",
    config = function()
      require("codewindow").setup {
        show_cursor = false, -- Show the cursor position in the minimap
        window_border = "rounded", -- The border style of the floating window (accepts all usual options)
      }
      -- vim.api.nvim_set_hl(0, 'CodewindowBorder', {fg = '#141423'})
    end,
  },
  {
    "shellRaining/hlchunk.nvim",
    event = "BufReadPost",
    config = function()
      require "custom.configs.hlchunk"
    end,
  },
  {
    "weilbith/nvim-code-action-menu",
    cmd = "CodeActionMenu",
    init = function()
      vim.g.code_action_menu_show_details = true
      vim.g.code_action_menu_show_diff = true
      vim.g.code_action_menu_show_action_kind = true
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
  },
  {
    "smjonas/inc-rename.nvim",
    event = "LspAttach",
    config = true,
  },
  {
    "AckslD/muren.nvim",
    cmd = "MurenToggle",
    config = true,
  },
  {
    "f-person/git-blame.nvim",
    cmd = "GitBlameToggle",
  },
  -- {
  --   "kevinhwang91/nvim-ufo",
  --   dependencies = {
  --     "kevinhwang91/promise-async",
  {
    "luukvbaal/statuscol.nvim",
    event = "BufReadPost",
    config = function()
      local builtin = require "statuscol.builtin"
      require("statuscol").setup {
        relculright = true,
        segments = {
          { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
          { text = { "%s" }, click = "v:lua.ScSa" },
          { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
        },
      }
    end,
  },
  --   },
  --   event = "BufReadPost",
  --   keys = { "zf", "zo", "za", "zc", "zM", "zR" },
  --   config = function()
  --     require("ufo").setup {
  --       provider_selector = function()
  --         return { "treesitter", "indent" }
  --       end,
  --     }
  --   end,
  -- },
  -- {
  --   "yaocccc/nvim-foldsign",
  --   event = "CursorHold",
  --   config = function()
  --     require("nvim-foldsign").setup {
  --       offset = -2,
  --       foldsigns = {
  --         open = "-", -- mark the beginning of a fold
  --         close = "+", -- show a closed fold
  --         seps = { "│", "┃" }, -- open fold middle marker
  --       },
  --     }
  --   end,
  -- },
  {
    "jinzhongjia/LspUI.nvim",
    event = "LspAttach",
    config = function()
      require("LspUI").setup()
    end,
  },
  {
    "lvimuser/lsp-inlayhints.nvim",
    event = "LspAttach",
    config = function()
      require "custom.configs.inlayhints"
    end,
  },
  {
    "samodostal/image.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "m00qek/baleia.nvim",
        tag = "v1.3.0",
      },
    },
    config = function()
      require("image").setup {
        render = {
          min_padding = 5,
          show_label = true,
          use_dither = true,
          foreground_color = true,
          background_color = true,
        },
        events = {
          update_on_nvim_resize = true,
        },
      }
    end,
    init = function()
      if not vim.fn.executable "ascii-image-converter" then
        vim.api.nvim_command 'echo "Command is not executable. snap install ascii-image-converter"'
      end
    end,
  },
  {
    "VonHeikemen/searchbox.nvim",
    cmd = { "SearchBoxMatchAll", "SearchBoxReplace", "SearchBoxIncSearch" },
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    config = true,
  },
  {
    "sindrets/diffview.nvim",
    cmd = "DiffviewOpen",
    config = function()
      require("diffview").setup {
        enhanced_diff_hl = true,
        view = {
          merge_tool = {
            layout = "diff3_mixed",
            disable_diagnostics = true,
          },
        },
      }
    end,
  },
  {
    "kevinhwang91/nvim-hlslens",
    event = "BufReadPost",
    config = function()
      require("scrollbar.handlers.search").setup {}
    end,
  },
  {
    "tzachar/highlight-undo.nvim",
    event = "BufReadPost",
    config = function()
      require("highlight-undo").setup {}
    end,
  },
  {
    "levouh/tint.nvim",
    event = "BufReadPost",
    config = true,
  },
  {
    "anuvyklack/pretty-fold.nvim",
    event = "BufWinEnter",
    dependencies = {
      {
        "anuvyklack/fold-preview.nvim",
        dependencies = {
          "anuvyklack/keymap-amend.nvim",
        },
        opts = {
          border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        },
      },
    },
    config = function()
      require "custom.configs.pretty-fold"
    end,
  },
  {
    "Fildo7525/pretty_hover",
    event = "LspAttach",
    config = true,
  },
  -- {
  --   "VidocqH/lsp-lens.nvim",
  --   event = "BufReadPost",
  --   config = true,
  -- },
  {
    "ziontee113/icon-picker.nvim",
    cmd = "IconPickerNormal",
    config = function()
      require("icon-picker").setup {
        disable_legacy_commands = true,
      }
    end,
  },
  {
    "sidebar-nvim/sidebar.nvim",
    key = "<leader>sb",
    dependencies = { "sidebar-nvim/sections-dap" },
    config = function()
      require "custom.configs.sidebar"
    end,
  },
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    config = function()
      require "custom.configs.lspsaga"
    end,
  },
  {
    "max397574/colortils.nvim",
    cmd = "Colortils",
    config = function()
      require("colortils").setup()
    end,
  },
  {
    "dnlhc/glance.nvim",
    event = "VeryLazy",
    config = function()
      require("glance").setup {
        -- your configuration
      }
    end,
  },
  { "lewis6991/whatthejump.nvim", event = "VeryLazy" },
  {
    "Zeioth/compiler.nvim",
    cmd = { "CompilerOpen", "CompilerToggleResults" },
    dependencies = {
      {
        "stevearc/overseer.nvim",
        commit = "3047ede61cc1308069ad1184c0d447ebee92d749",
        opts = {
          task_list = {
            direction = "bottom",
            min_height = 25,
            max_height = 25,
            default_detail = 1,
            bindings = {
              ["q"] = function()
                vim.cmd "OverseerClose"
              end,
            },
          },
        },
      },
    },
    config = function(_, opts)
      require("compiler").setup(opts)
    end,
  },
  ----------------------------------------- language plugins ------------------------------------------
  {
    "ray-x/go.nvim",
    ft = { "go", "gomod" },
    dependencies = {
      {
        "ray-x/guihua.lua",
        build = "cd lua/fzy && make",
      },
    },
    config = function()
      require "custom.configs.go"
    end,
    build = ':lua require("go.install").update_all_sync()',
  },
  -- {
  --   "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  --   -- ft = { "go", "gomod" },
  --   keys = { "<leader>ls" },
  --   config = function()
  --     require("lsp_lines").setup()
  --   end,
  -- },
  {
    "galooshi/vim-import-js",
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    build = "npm install",
  },
  {
    "pmizio/typescript-tools.nvim",
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    opts = {},
  },
  {
    "vuki656/package-info.nvim",
    ft = { "json", "lua" },
    config = true,
  },
  {
    "nvim-neotest/neotest",
    ft = { "go" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-go",
    },
    config = function()
      local neotest_ns = vim.api.nvim_create_namespace "neotest"
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)
      require("neotest").setup {
        adapters = {
          require "neotest-go" {
            args = { "-count=1", "-coverprofile coverage.out", "-covermode=count" },
          },
        },
      }
    end,
  },
  {
    "toppair/peek.nvim",
    build = "deno task --quiet build:fast",
    ft = { "markdown", "vimwiki" },
    config = function()
      require("peek").setup {
        app = "webview",
        theme = "dark",
        filetype = { "markdown", "vimwiki" },
      }
    end,
    init = function()
      vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
      vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    end,
  },
  {
    "TobinPalmer/rayso.nvim",
    cmd = { "Rayso" },
    config = function()
      require("rayso").setup {
        open_cmd = "chrome",
      }
    end,
  },
  ----------------------------------------- completions plugins ------------------------------------------
  {
    "ludovicchabant/vim-gutentags",
    event = "BufReadPost",
  },
  {
    "github/copilot.vim",
    lazy = false,
    config = function()
      require "custom.configs.copilot"
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    dependencies = {
      {
        "zbirenbaum/copilot-cmp",
        config = function()
          require("copilot_cmp").setup()
        end,
      },
    },
    config = function()
      require("copilot").setup {
        suggestion = {
          enabled = false,
          auto_trigger = false,
          keymap = {
            -- accept = "<Tab>",
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        panel = {
          enabled = false,
        },
        server_opts_overrides = {
          trace = "verbose",
          settings = {
            advanced = {
              listCount = 3,
              inlineSuggestCount = 3,
            },
          },
        },
      }
    end,
  },
}

return plugins
