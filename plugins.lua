local overrides = require "custom.configs.overrides"
local cmp_opt = require "custom.configs.cmp"

---@type NvPluginSpec[]
local plugins = {
  --------------------------------------------- community ---------------------------------------------
  -- { "BrunoKrugel/nvcommunity" },
  ----------------------------------------- override plugins ------------------------------------------
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- {
      --   "nvimtools/none-ls.nvim",
      --   config = function()
      --     require "custom.configs.null-ls"
      --   end,
      -- },
      {
        "williamboman/mason.nvim",
        opts = overrides.mason,
        config = function(_, opts)
          dofile(vim.g.base46_cache .. "mason")
          dofile(vim.g.base46_cache .. "lsp")
          require("mason").setup(opts)
          vim.api.nvim_create_user_command("MasonInstallAll", function()
            vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
          end, {})
          require "custom.configs.lspconfig"
        end,
      },
      "williamboman/mason-lspconfig.nvim",
    },
    config = function() end,
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
      require "plugins.configs.gitsigns"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "git")
      require("scrollbar.handlers.gitsigns").setup()
      require("gitsigns").setup(opts)
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    opts = overrides.devicons,
  },
  {
    "NvChad/nvterm",
    opts = overrides.nvterm,
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = overrides.telescope,
    dependencies = {
      "debugloop/telescope-undo.nvim",
      "gnfisher/nvim-telescope-ctags-plus",
      "benfowler/telescope-luasnip.nvim",
      "FabianWirth/search.nvim",
      "Marskey/telescope-sg",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      {
        "windwp/nvim-ts-autotag",
        opts = { enable_close_on_slash = false },
      },
      "filNaj/tree-setter",
      "echasnovski/mini.ai",
      "piersolenski/telescope-import.nvim",
      "RRethy/nvim-treesitter-textsubjects",
      "danymat/neogen",
      "kevinhwang91/promise-async",
      {
        "kevinhwang91/nvim-ufo",
        config = function()
          require "custom.configs.ufo"
        end,
      },
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        init = function()
          vim.g.skip_ts_context_commentstring_module = true
        end,
        config = function()
          require("ts_context_commentstring").setup {
            enable_autocmd = false,
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
      "tzachar/cmp-fuzzy-buffer",
      "roobert/tailwindcss-colorizer-cmp.nvim",
      "tzachar/fuzzy.nvim",
      "rcarriga/cmp-dap",
      "js-everts/cmp-tailwind-colors",
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
            show_prediction_strength = false,
            run_on_every_keystroke = true,
            snipper_placeholder = "..",
            ignored_file_types = {},
          }
        end,
      },
      {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
        config = function(_, opts)
          require("luasnip").config.set_config(opts)
          require "plugins.configs.luasnip"
          require "custom.configs.luasnip"
          require "custom.configs.autotag"
        end,
      },
      {
        "windwp/nvim-autopairs",
        config = function()
          require "custom.configs.autopair"
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
                accept_word = false,
                accept_line = false,
              },
            },
            panel = {
              enabled = false,
            },
            filetypes = {
              gitcommit = false,
              TelescopePrompt = false,
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
    },
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "cmp")
      local format_kinds = opts.formatting.format
      opts.formatting.format = function(entry, item)
        if item.kind == "Color" then
          item.kind = "⬤"
          format_kinds(entry, item)
          return require("tailwindcss-colorizer-cmp").formatter(entry, item)
        end
        return format_kinds(entry, item)
      end
      local cmp = require "cmp"

      cmp.setup(opts)

      local cmp_autopairs = require "nvim-autopairs.completion.cmp"
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = opts.mapping,
        sources = {
          { name = "buffer" },
        },
      })

      cmp.setup.filetype({ "dapui_watches", "dapui_hover" }, {
        sources = {
          { name = "dap" },
        },
      })
    end,
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
    ft = { "html", "svelte", "astro", "vue", "typescriptreact" },
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
    "RRethy/vim-illuminate",
    event = "CursorHold",
    config = function()
      require("illuminate").configure {
        providers = {
          "lsp",
          "treesitter",
          "regex",
        },
        under_cursor = false,
      }
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
    "aznhe21/actions-preview.nvim",
    event = "LspAttach",
    config = function()
      require("actions-preview").setup {
        diff = {
          algorithm = "patience",
          ignore_whitespace = true,
        },
        telescope = require("telescope.themes").get_dropdown { winblend = 10 },
      }
    end,
  },
  {
    "luckasRanarison/clear-action.nvim",
    event = "LspAttach",
    opts = {
      mappings = {
        code_action = "<leader>A",
      },
      signs = {
        icons = {
          quickfix = "襁",
          refactor = "",
          source = "",
          combined = "",
        },
      },
      popup = {
        hide_cursor = true,
      },
    },
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
    cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
    opts = {
      updatetime = 10,
      hint_config = false,
    },
    dependencies = {
      "smoka7/hydra.nvim",
    },
  },
  {
    "olimorris/persisted.nvim",
    event = "VimEnter",
    opts = {
      save_dir = vim.fn.expand(vim.fn.stdpath "data" .. "/sessions/"), -- directory where session files are saved
      silent = true,                                                   -- silent nvim message when sourcing session file
      use_git_branch = true,                                           -- create session files based on the branch of the git enabled repository
      autosave = true,                                                 -- automatically save session files when exiting Neovim
      should_autosave = nil,                                           -- function to determine if a session should be autosaved
      autoload = true,                                                 -- automatically load the session for the cwd on Neovim startup
      on_autoload_no_session = nil,
      follow_cwd = true,
      ignored_dirs = {
        { "~/.config", exact = true },
      },
      telescope = {                         -- options for the telescope extension
        reset_prompt_after_deletion = true, -- whether to reset prompt after session deleted
      },
      config = function(_, opts)
        vim.o.sessionoptions = "buffers,curdir,folds,globals,tabpages,winpos,winsize"
        require("persisted").setup(opts)
        require("telescope").load_extension "persisted"
      end,
    },
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    event = "VeryLazy",
    opts = {},
  },
  {
    "epwalsh/obsidian.nvim",
    event = {
      "BufReadPre /users/bruno.krugel/Library/Mobile Documents/iCloud~md~obsidian/Documents/Annotation/**.md",
    },
    config = function()
      require("obsidian").setup {
        dir = "/users/bruno.krugel/Library/Mobile Documents/iCloud~md~obsidian/Documents/Annotation",
        disable_frontmatter = true,
        completion = {
          nvim_cmp = true,
        },
      }
    end,
  },
  {
    "chrisgrieser/nvim-early-retirement",
    event = "VeryLazy",
    opts = {
      retirementAgeMins = 5,
      notificationOnAutoClose = false,
    },
  },
  {
    "jonahgoldwastaken/copilot-status.nvim",
    event = "LspAttach",
    config = function()
      require("copilot_status").setup {
        icons = {
          idle = " ",
          error = " ",
          offline = " ",
          warning = " ",
          loading = " ",
        },
        debug = false,
      }
    end,
  },
  {
    "m-demare/hlargs.nvim",
    event = "BufWinEnter",
    config = function()
      require("hlargs").setup {
        hl_priority = 200,
      }
    end,
  },
  {
    "tzachar/local-highlight.nvim",
    event = { "CursorHold", "CursorHoldI" },
    opts = {
      hlgroup = "Visual",
    },
  },
  {
    "smoka7/hop.nvim",
    cmd = { "HopWord", "HopLine", "HopLineStart", "HopWordCurrentLine", "HopNodes" },
    config = function()
      require("hop").setup { keys = "etovxqpdygfblzhckisuran" }
      dofile(vim.g.base46_cache .. "hop")
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
    "echasnovski/mini.surround",
    event = { "ModeChanged" },
    config = true,
  },
  {
    "declancm/vim2vscode",
    cmd = "Code",
  },
  {
    "jubnzv/virtual-types.nvim",
    event = "LspAttach",
  },
  {
    "wakatime/vim-wakatime",
    event = "BufReadPost",
  },
  {
    "mfussenegger/nvim-dap",
    cmd = { "DapContinue", "DapStepOver", "DapStepInto", "DapStepOut", "DapToggleBreakpoint" },
    dependencies = {
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {
          highlight_changed_variables = true,
          highlight_new_as_changed = true,
          show_stop_reason = true,
          commented = true,
        },
      },
      'ofirgall/goto-breakpoints.nvim',
      {
        "LiadOz/nvim-dap-repl-highlights",
        build = ":TSInstall dap_repl",
        opts = {},
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
    "Weissle/persistent-breakpoints.nvim",
    ft = "go",
    config = function()
      require("persistent-breakpoints").setup {
        load_breakpoints_event = { "BufReadPost" },
      }
    end,
  },
  {
    "mawkler/modicator.nvim",
    event = "ModeChanged",
    init = function()
      vim.o.cursorline = true
      vim.o.number = true
      vim.o.termguicolors = true
    end,
    opts = {
      show_warnings = false,
      highlights = {
        defaults = { bold = true },
      },
    },
  },
  {
    "lukas-reineke/virt-column.nvim",
    config = function()
      require("virt-column").setup {
        char = "┃",
      }
    end,
  },
  {
    "rest-nvim/rest.nvim",
    ft = { "http" },
    config = function()
      require("rest-nvim").setup {
        result_split_horizontal = true,
        result_split_in_place = true,
        skip_ssl_verification = false,
        encode_url = true,
        jump_to_request = false,
        env_file = ".env",
        custom_dynamic_variables = {},
        yank_dry_run = true,
        highlight = {
          enabled = true,
          timeout = 150,
        },
        result = {
          show_url = false,
          show_http_info = true,
          show_headers = false,
          show_statistics = {
            "time_total",
            "remote_ip",
            "response_code",
          },
          formatters = {
            json = function(body)
              -- stylua: ignore
              return vim.fn.system { "biome", "format", "--stdin", "--stdin-file-path", "foo.json", body }
            end,
            -- prettier already needed since it's the only proper yaml formatter
            html = function(body)
              return vim.fn.system { "prettier", "--parser=html", body }
            end,
          },
        },
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
    "hinell/lsp-timeout.nvim",
    event = "LspAttach",
    config = function()
      vim.g["lsp-timeout-config"] = {
        -- When focus is lost
        -- wait 5 minutes before stopping all LSP servers
        stopTimeout = 1000 * 60 * 5,
        startTimeout = 1000 * 10,
        silent = true,
        filetypes = { -- Exclude servers that miss behave on LSP stop/start.
          ignore = { "markdown", "java" },
        },
      }
    end,
  },
  {
    "0oAstro/dim.lua",
    event = "LspAttach",
    config = function()
      require("dim").setup {}
    end,
  },
  {
    "Wansmer/treesj",
    cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
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
    "petertriho/nvim-scrollbar",
    event = "WinScrolled",
    config = function()
      require "custom.configs.scrollbar"
    end,
  },
  {
    "folke/todo-comments.nvim",
    event = "BufReadPost",
    config = function()
      require "custom.configs.todo"
      dofile(vim.g.base46_cache .. "todo")
    end,
  },
  -- {
  --   "chikko80/error-lens.nvim",
  --   ft = "go",
  --   config = true,
  -- },
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    config = function()
      require "custom.configs.trouble"
      dofile(vim.g.base46_cache .. "trouble")
    end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    event = "VeryLazy",
    config = function()
      require("telescope").load_extension "ui-select"
    end,
  },
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
    "shellRaining/hlchunk.nvim",
    event = "BufReadPost",
    config = function()
      require "custom.configs.hlchunk"
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
    "AckslD/muren.nvim",
    cmd = "MurenToggle",
    config = true,
  },
  {
    "f-person/git-blame.nvim",
    cmd = "GitBlameToggle",
  },
  {
    "FabijanZulj/blame.nvim",
    cmd = "ToggleBlame",
  },
  {
    "akinsho/git-conflict.nvim",
    ft = "gitcommit",
    config = function()
      require("git-conflict").setup()
    end,
  },
  {
    "kevinhwang91/nvim-fundo",
    event = "BufReadPost",
    opts = {},
    build = function()
      require("fundo").install()
    end,
  },
  {
    "luukvbaal/statuscol.nvim",
    lazy = false,
    config = function()
      require "custom.configs.statuscol"
    end,
  },
  {
    "lvimuser/lsp-inlayhints.nvim",
    branch = "anticonceal",
    event = "LspAttach",
    config = function()
      require "custom.configs.inlayhints"
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
        hooks = {
          diff_buf_win_enter = function(_, _, ctx)
            if ctx.layout_name:match "^diff2" then
              if ctx.symbol == "a" then
                vim.opt_local.winhl = table.concat({
                  "DiffAdd:DiffviewDiffAddAsDelete",
                  "DiffDelete:DiffviewDiffDelete",
                }, ",")
              elseif ctx.symbol == "b" then
                vim.opt_local.winhl = table.concat({
                  "DiffDelete:DiffviewDiffDelete",
                }, ",")
              end
            end
          end,
        },
      }
    end,
  },
  {
    "utilyre/sentiment.nvim",
    event = "LspAttach",
    opts = {},
    init = function()
      vim.g.loaded_matchparen = 1
    end,
  },
  {
    "0xAdk/full_visual_line.nvim",
    keys = { "V" },
    config = function()
      require("full_visual_line").setup {}
    end,
  },
  {
    "FeiyouG/command_center.nvim",
    cmd = "Commandcenter",
    config = function()
      require "custom.configs.command"
    end,
  },
  {
    "kevinhwang91/nvim-hlslens",
    event = "BufReadPost",
    config = function()
      require("hlslens").setup {
        build_position_cb = function(plist, _, _, _)
          require("scrollbar.handlers.search").handler.show(plist.start_pos)
        end,
      }

      vim.cmd [[
          augroup scrollbar_search_hide
              autocmd!
              autocmd CmdlineLeave : lua require('scrollbar.handlers.search').handler.hide()
          augroup END
      ]]
    end,
  },
  {
    "tzachar/highlight-undo.nvim",
    event = "BufReadPost",
    opts = {},
  },
  {
    "jghauser/fold-cycle.nvim",
    opts = {},
  },
  {
    "anuvyklack/fold-preview.nvim",
    dependencies = {
      "anuvyklack/keymap-amend.nvim",
    },
    opts = {
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    },
  },
  {
    "Fildo7525/pretty_hover",
    opts = {},
  },
  {
    "Wansmer/symbol-usage.nvim",
    event = "BufReadPre",
    config = function()
      require "custom.configs.symbol"
    end,
  },
  {
    "folke/edgy.nvim",
    event = "BufReadPost",
    init = function()
      vim.opt.laststatus = 3
      vim.opt.splitkeep = "screen"
    end,
    opts = {
      fix_win_height = vim.fn.has "nvim-0.10.0" == 0,
      bottom = {
        {
          ft = "toggleterm",
          size = { height = 0.1 },
        },
        { ft = "spectre_panel", size = { height = 0.4 } },
        { ft = "qf", title = "QuickFix" },
        { ft = "dap-repl", title = " Debug REPL" },
        { ft = "dapui_console", size = { height = 0.1 }, title = "Debug Console" },
        "Trouble",
        "Noice",
        {
          ft = "help",
          size = { height = 20 },
          -- only show help buffers
          filter = function(buf)
            return vim.bo[buf].buftype == "help"
          end,
        },
        {
          ft = "NoiceHistory",
          title = " Log",
          open = function()
            require("noice").cmd "history"
          end,
        },
        {
          ft = "neotest-output-panel",
          title = " Test Output",
          open = function()
            vim.cmd.vsplit()
            require("neotest").output_panel.toggle()
          end,
        },
        {
          ft = "DiffviewFileHistory",
          title = " Diffs",
        },
      },
      left = {
        { ft = "undotree", title = "Undo Tree" },
        { ft = "dapui_scopes", title = " Scopes" },
        { ft = "dapui_watches", title = " Watches" },
        { ft = "dapui_breakpoints", title = " Breakpoints" },
        { ft = "dapui_stacks", title = " Stacks" },
        {
          ft = "diff",
          title = " Diffs",
        },

        {
          ft = "DiffviewFileHistory",
          title = " Diffs",
        },
        {
          ft = "DiffviewFiles",
          title = " Diffs",
        },
        {
          ft = "neotest-summary",
          title = "  Tests",
          open = function()
            require("neotest").summary.toggle()
          end,
        },
      },
      right = {
        "dapui_scopes",
        "sagaoutline",
        "neotest-output-panel",
        "neotest-summary",
      },
      options = {
        left = { size = 40 },
        bottom = { size = 10 },
        right = { size = 30 },
        top = { size = 10 },
      },
      wo = {
        winbar = true,
        signcolumn = "no",
      },
    },
  },
  {
    "nvim-pack/nvim-spectre",
    cmd = { "Spectre", "SpectreOpen", "SpectreClose" },
    opts = { is_block_ui_break = true },
  },
  {
    "akinsho/toggleterm.nvim",
    keys = { [[<C-\>]] },
    cmd = { "ToggleTerm", "ToggleTermOpenAll", "ToggleTermCloseAll" },
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 0.25 * vim.api.nvim_win_get_height(0)
        elseif term.direction == "vertical" then
          return 0.25 * vim.api.nvim_win_get_width(0)
        elseif term.direction == "float" then
          return 85
        end
      end,
      open_mapping = [[<C-\>]],
      hide_numbers = true,
      shade_terminals = false,
      insert_mappings = true,
      start_in_insert = true,
      persist_size = true,
      direction = "horizontal",
      close_on_exit = true,
      shell = vim.o.shell,
      autochdir = true,
      highlights = {
        NormalFloat = {
          link = "Normal",
        },
        FloatBorder = {
          link = "FloatBorder",
        },
      },
      float_opts = {
        border = "rounded",
        winblend = 0,
      },
    },
  },
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    config = function()
      require "custom.configs.lspsaga"
    end,
  },
  {
    "artemave/workspace-diagnostics.nvim",
    event = "LspAttach",
    opts = {},
  },
  {
    "dnlhc/glance.nvim",
    cmd = "Glance",
    config = function()
      require "custom.configs.glance"
    end,
  },
  -- {
  --   "Zeioth/compiler.nvim",
  --   cmd = { "CompilerOpen", "CompilerToggleResults" },
  --   dependencies = {
  --     {
  --       "stevearc/overseer.nvim",
  --       commit = "3047ede61cc1308069ad1184c0d447ebee92d749",
  --       opts = {
  --         task_list = {
  --           direction = "bottom",
  --           min_height = 25,
  --           max_height = 25,
  --           default_detail = 1,
  --           bindings = {
  --             ["q"] = function()
  --               vim.cmd "OverseerClose"
  --             end,
  --           },
  --         },
  --       },
  --     },
  --   },
  --   config = function(_, opts)
  --     require("compiler").setup(opts)
  --   end,
  -- },
  ----------------------------------------- language plugins ------------------------------------------
  {
    "ray-x/go.nvim",
    ft = { "go", "gomod", "gosum", "gowork", "gotmpl" },
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
    "pmizio/typescript-tools.nvim",
    ft = {
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
    },
    dependencies = {
      "OlegGulevskyy/better-ts-errors.nvim",
    },
    config = function()
      require "custom.configs.ts"
    end,
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
    "BrunoKrugel/package-info.nvim",
    event = "BufEnter package.json",
    opts = {
      icons = {
        enable = true,
        style = {
          up_to_date = "  ",
          outdated = "  ",
        },
      },
      autostart = true,
      hide_up_to_date = true,
      hide_unstable_versions = true,
    },
  },
  {
    "nvim-neotest/neotest",
    ft = { "go", "javascript", "typescript", "javascriptreact", "typescriptreact" },
    dependencies = {
      "nvim-neotest/neotest-go",
      "haydenmeade/neotest-jest",
    },
    config = function()
      require "custom.configs.neotest"
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
    "mfussenegger/nvim-lint",
    event = "BufWritePre",
    config = function()
      require "custom.configs.linter"
    end,
  },
  {
    "stevearc/conform.nvim",
    event = "BufReadPost",
    config = function()
      require "custom.configs.conform"
    end,
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
  {
    "sustech-data/wildfire.nvim",
    event = "VeryLazy",
    config = function()
      require("wildfire").setup()
    end,
  },
  {
    "chrisgrieser/nvim-recorder",
    keys = { "q", "Q" },
    config = function()
      require "custom.configs.recorder"
    end,
  },
  {
    "dmmulroy/tsc.nvim",
    cmd = { "TSC" },
    opts = {
      auto_open_qflist = true,
      spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
    },
  },
  {
    "antosha417/nvim-lsp-file-operations",
    event = "LspAttach",
    config = function()
      require("lsp-file-operations").setup()
    end,
  },
  {
    "ThePrimeagen/refactoring.nvim",
    event = "BufRead",
    config = function()
      require "custom.configs.refactoring"
    end,
  },
  {
    "chrisgrieser/nvim-origami",
    event = "BufReadPost",
    opts = {
      keepFoldsAcrossSessions = true,
      pauseFoldsOnSearch = true,
      setupFoldKeymaps = false,
    },
  },
  {
    "malbertzard/inline-fold.nvim",
    event = "BufReadPost",
    opts = {
      defaultPlaceholder = "…",
      queries = {
        html = {
          { pattern = 'class="([^"]*)"', placeholder = "@" }, -- classes in html
          { pattern = 'href="(.-)"' },                        -- hrefs in html
          { pattern = 'src="(.-)"' },                         -- HTML img src attribute
        },
        go = {
          { pattern = "^%s*if err != nil {", placeholder = "if err != nil .." },
        },
      },
    },
  },
  ----------------------------------------- completions plugins ------------------------------------------
  {
    "skywind3000/gutentags_plus",
    event = "VeryLazy",
    dependencies = { "ludovicchabant/vim-gutentags" },
    config = function()
      require "custom.configs.tags"
    end,
  },
  {
    "github/copilot.vim",
    lazy = false,
    config = function()
      require "custom.configs.copilot"
    end,
  },
}

return plugins
