local overrides = require "custom.configs.overrides"
local cmp_opt = require "custom.configs.cmp"

---@type NvPluginSpec[]
local plugins = {
  ----------------------------------------- override plugins ------------------------------------------
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
      { "folke/neodev.nvim",  ft = "lua",      opts = { experimental = { pathStrict = true } } },
    },
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    enabled = false,
  },
  {
    "folke/which-key.nvim",
    enabled = true,
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = function()
      return require("plugins.configs.others").gitsigns
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "git")
      require("scrollbar.handlers.gitsigns").setup()
      require("gitsigns").setup(opts)
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = overrides.mason,
  },
  {
    "nvim-tree/nvim-web-devicons",
    opts = overrides.devicons,
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = overrides.telescope,
    dependencies = {
      "debugloop/telescope-undo.nvim",
      "gnfisher/nvim-telescope-ctags-plus",
      "tom-anders/telescope-vim-bookmarks.nvim",
      "benfowler/telescope-luasnip.nvim",
      "Marskey/telescope-sg",
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
      "filNaj/tree-setter",
      "RRethy/nvim-treesitter-textsubjects",
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        config = function()
          require("Comment").setup {
            pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
          }
        end,
      },
    },
    opts = overrides.treesitter,
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "antosha417/nvim-lsp-file-operations" },
    opts = overrides.nvimtree,
  },
  {
    "NvChad/nvim-colorizer.lua",
    opts = overrides.colorizer,
  },
  {
    "hrsh7th/nvim-cmp",
    opts = cmp_opt.cmp,
    dependencies = {
      "delphinus/cmp-ctags",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "hrsh7th/cmp-copilot",
      "ray-x/cmp-treesitter",
      { "jcdickinson/codeium.nvim", config = true },
      {
        "tzachar/cmp-tabnine",
        build = "./install.sh",
        config = function()
          local tabnine = require "cmp_tabnine.config"
          tabnine:setup {
            max_lines = 1000,
            max_num_results = 3,
            sort = true,
            show_prediction_strength = true,
            run_on_every_keystroke = true,
            snipper_placeholder = "..",
            ignored_file_types = {},
          }
        end,
      },
      {
        "L3MON4D3/LuaSnip",
        config = function(_, opts)
          require("plugins.configs.others").luasnip(opts)
          require "custom.configs.luasnip"
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
  {
    "razak17/tailwind-fold.nvim",
    opts = {
      min_chars = 50,
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "html", "svelte", "astro", "vue", "typescriptreact" },
  },
  ----------------------------------------- test ------------------------------------------
  {
    "mfussenegger/nvim-lint",
    event = "BufWritePre",
    config = function()
      require "custom.configs.linter"
    end,
  },
  {
    "mhartington/formatter.nvim",
    event = "LspAttach",
    cmd = "FormatWrite",
    config = function()
      require "custom.configs.formatter"
    end,
  },
  ----------------------------------------- enhance plugins ------------------------------------------
  {
    "okuuva/auto-save.nvim",
    event = { "InsertLeave", "TextChanged" },
    config = function()
      require "custom.configs.autosave"
    end,
  },
  {
    "andrewferrier/debugprint.nvim",
    keys = { "<leader><leader>p" },
    config = function()
      require("debugprint").setup {
        create_keymaps = false,
        create_commands = false,
      }
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
    "cbochs/portal.nvim",
    keys = { "<leader>pj", "<leader>ph" },
  },
  {
    "gbprod/cutlass.nvim",
    event = "VeryLazy",
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
    cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
    config = true,
    dependencies = {
      "smoka7/hydra.nvim",
    },
  },
  {
    "rmagatti/auto-session",
    event = "VimEnter",
    config = function()
      require("auto-session").setup {
        log_level = "error",
        auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
        auto_session_enabled = true,
        auto_save_enabled = true,
        auto_restore_enabled = true,
        auto_session_enable_last_session = vim.loop.cwd() == vim.loop.os_homedir(),
        session_lens = {
          load_on_setup = true,
          theme_conf = { border = true },
          previewer = true,
        },
      }
    end,
  },
  -- {
  --   "axkirillov/hbac.nvim",
  --   event = "VeryLazy",
  --   config = function()
  --     require("hbac").setup {
  --       autoclose = true,
  --       threshold = 5,
  --     }
  --   end,
  -- },
  {
    "chrisgrieser/nvim-early-retirement",
    opts = {
      retirementAgeMins = 5,
      notificationOnAutoClose = false,
    },
    event = "BufReadPost",
  },
  {
    "code-biscuits/nvim-biscuits",
    event = "BufReadPost",
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
    dependencies = "mfussenegger/nvim-treehopper",
    config = function()
      require("hop").setup { keys = "etovxqpdygfblzhckisuran" }
    end,
  },
  {
    "nguyenvukhang/nvim-toggler",
    event = "BufReadPost",
    config = function()
      require("nvim-toggler").setup {
        remove_default_keybinds = true,
      }
    end,
  },
  {
    "barrett-ruth/live-server.nvim",
    cmd = "LiveServerStart",
    build = "yarn global add live-server",
    config = true,
  },
  {
    "kylechui/nvim-surround",
    keys = { "ys", "ds", "cs" },
    config = true,
  },
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
      {
        "LiadOz/nvim-dap-repl-highlights",
        config = true,
        build = function()
          if not require("nvim-treesitter.parsers").has_parser "dap_repl" then
            vim.cmd ":TSInstall dap_repl"
          end
        end,
      },
    },
  },
  {
    "mawkler/modicator.nvim",
    event = "BufWinEnter",
    init = function()
      vim.o.cursorline = true
      vim.o.number = true
      vim.o.termguicolors = true
    end,
    config = function()
      require("modicator").setup()
    end,
  },
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
    "yorickpeterse/nvim-dd",
    event = "LspAttach",
    opts = {
      timeout = 1000,
    },
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
    keys = { "<leader>to" },
    config = function()
      require("treesj").setup {
        use_default_keymaps = true,
      }
    end,
  },
  ----------------------------------------- ui plugins ------------------------------------------
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require "custom.configs.noice"
    end,
  },
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    config = function()
      require("zen-mode").setup {
        window = {
          backdrop = 0.93,
          width = 150,
          height = 1,
        },
        plugins = {
          options = {
            showcmd = true,
          },
          twilight = { enabled = false },
          gitsigns = { enabled = true },
        },
      }
    end,
  },
  {
    "petertriho/nvim-scrollbar",
    event = "BufReadPost",
    config = function()
      require "custom.configs.scrollbar"
    end,
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
  { "rainbowhxch/beacon.nvim",    event = "BufReadPost" },
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
    keys = { "<leader>mm" },
    config = function()
      require("codewindow").setup {
        show_cursor = false,
        window_border = "rounded",
      }
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
    "BrunoKrugel/lazydocker.nvim",
    cmd = "LazyDocker",
  },
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
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
  {
    "akinsho/git-conflict.nvim",
    ft = "gitcommit",
    config = function()
      require("git-conflict").setup()
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    event = "VeryLazy",
    dependencies = {
      "kevinhwang91/promise-async",
      {
        "luukvbaal/statuscol.nvim",
        event = "BufReadPost",
        config = function()
          local builtin = require "statuscol.builtin"
          require("statuscol").setup {
            relculright = true,
            bt_ignore = { "nofile", "prompt", "terminal", "packer" },
            ft_ignore = { "NvimTree", "dashboard", "nvcheatsheet" },
            segments = {
              -- Segment 1: Add padding
              {
                text = { " " },
              },
              -- Segment 2: Fold Column
              { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
              -- Segment 3: Add padding
              {
                text = { " " },
              },
              -- Segment 4: Show signs with one character width
              {
                sign = { name = { ".*" }, maxwidth = 1, colwidth = 1 },
                auto = true,
                click = "v:lua.ScSa",
              },
              -- Segment 5: Show line number
              {
                text = { " ", " ", builtin.lnumfunc, " " },
                click = "v:lua.ScLa",
                condition = { true, builtin.not_empty },
              },
              -- Segment 6: Add padding
              {
                text = { " " },
                hl = "Normal",
                condition = { true, builtin.not_empty },
              },
            },
          }
        end,
      },
    },
    config = function()
      local ftMap = {
        go = "lsp",
      }
      require("ufo").setup {
        close_fold_kinds = { "imports" },
        provider_selector = function(bufnr, filetype, buftype)
          return ftMap[filetype] or { "treesitter", "indent" }
        end,
      }
    end,
  },
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
    "adelarsq/image_preview.nvim",
    keys = { "<leader>p" },
    config = function()
      require("image_preview").setup()
    end,
  },
  {
    "VonHeikemen/searchbox.nvim",
    cmd = { "SearchBoxMatchAll", "SearchBoxReplace", "SearchBoxIncSearch" },
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
    "anuvyklack/pretty-fold.nvim",
    keys = { "<leader>a" },
    config = function()
      require "custom.configs.pretty-fold"
    end,
  },
  {
    "jghauser/fold-cycle.nvim",
    keys = { "<leader>a" },
    config = function()
      require("fold-cycle").setup()
    end,
  },
  {
    "anuvyklack/fold-preview.nvim",
    keys = { "<leader>p" },
    dependencies = {
      "anuvyklack/keymap-amend.nvim",
    },
    opts = {
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    },
  },
  {
    "Fildo7525/pretty_hover",
    keys = { "<leader>k" },
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
    cmd = "Glance",
    config = function()
      require "custom.configs.glance"
    end,
  },
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
    ft = { "go", "gomod", "gosum", "gowork" },
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
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    event = "LspAttach",
    config = function()
      require("lsp_lines").setup()
    end,
  },
  {
    "llllvvuu/nvim-js-actions",
    keys = { "<leader>jc" },
  },
  {
    "vuki656/package-info.nvim",
    event = "BufEnter package.json",
    config = true,
  },
  {
    "nvim-neotest/neotest",
    ft = { "go" },
    dependencies = {
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
  },
  {
    "sustech-data/wildfire.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
        require("wildfire").setup()
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
    "chrisgrieser/nvim-recorder",
    keys = { "q", "Q" },
    opts = {
      lessNotifications = true,
      clear = true,
    },
  },
  {
    "javiorfo/nvim-soil",
    ft = "plantuml",
    dependencies = { "javiorfo/nvim-nyctophilia" },
  },
  {
    "dmmulroy/tsc.nvim",
    cmd = { "TSC" },
    config = true,
  },
  {
    "antosha417/nvim-lsp-file-operations",
    event = "LspAttach",
    config = function()
      require("lsp-file-operations").setup()
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
