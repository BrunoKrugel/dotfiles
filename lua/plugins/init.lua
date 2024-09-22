local overrides = require "configs.overrides"
local cmp_opt = require "configs.cmp"

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = overrides.mason,
        config = function(_, opts)
          require("mason").setup(opts)
          local mr = require "mason-registry"
          mr:on("package:install:success", function()
            vim.defer_fn(function()
              require("lazy.core.handler.event").trigger {
                event = "FileType",
                buf = vim.api.nvim_get_current_buf(),
              }
            end, 100)
          end)
          vim.api.nvim_create_user_command("MasonInstallAll", function()
            vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
          end, {})
          require "configs.lspconfig"
        end,
      },
      "artemave/workspace-diagnostics.nvim",
      "jubnzv/virtual-types.nvim",
      "williamboman/mason-lspconfig.nvim",
      {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        opts = {
          auto_update = true,
          run_on_start = true,
          ensure_installed = {
            "impl",
          },
        },
        cmd = "MasonToolsUpdate",
        event = "BufReadPre",
        dependencies = "williamboman/mason.nvim",
      },
    },
    config = function() end,
  },
  {
    "folke/which-key.nvim",
    enabled = true,
  },
  { "nvchad/volt" },
  { "nvchad/minty", event = "BufReadPost" },
  {
    "lewis6991/gitsigns.nvim",
    opts = function()
      require "nvchad.configs.gitsigns"
    end,
    config = function(_, opts)
      require("scrollbar.handlers.gitsigns").setup()
      require("gitsigns").setup(opts)
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    dependencies = {
      "rachartier/tiny-devicons-auto-colors.nvim",
    },
    opts = overrides.devicons,
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
      "windwp/nvim-ts-autotag",
      "filNaj/tree-setter",
      "RRethy/nvim-treesitter-textsubjects",
      "danymat/neogen",
      {
        "folke/ts-comments.nvim",
        opts = {},
      },
    },
    opts = overrides.treesitter,
    build = ":TSUpdate",
    init = function(plugin)
      -- perf: make treesitter queries available at startup.
      require("lazy.core.loader").add_to_rtp(plugin)
      require "nvim-treesitter.query_predicates"
    end,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "doxnit/cmp-luasnip-choice",
    event = "InsertEnter",
    opts = { auto_open = true },
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "antosha417/nvim-lsp-file-operations" },
    opts = require "configs.tree",
    config = function(_, opts)
      require("nvim-tree").setup(opts)
      require("nvim-tree.diagnostics").update()
    end,
  },
  {
    "NvChad/nvim-colorizer.lua",
    enabled = false,
  },
  {
    "brenoprata10/nvim-highlight-colors",
    event = { "CursorHold", "CursorMoved" },
    opts = {
      render = "virtual",
      virtual_symbol = "󰏘",
      enable_named_colors = false,
      enable_tailwind = true,
      exclude_filetypes = { "lazy" },
    },
  },
  {
    "NStefan002/visual-surround.nvim",
    event = "BufEnter",
    config = function()
      require("visual-surround").setup {
        use_default_keymaps = false,
        exit_visual_mode = false,
      }
      local surround_chars = { "{", "[", "(", "'", '"', "<" }
      local surround = require("visual-surround").surround

      for _, key in pairs(surround_chars) do
        vim.keymap.set("v", "s" .. key, function()
          surround(key)
        end, { desc = "[visual-surround] Surround selection with " .. key })
      end
    end,
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
      "tzachar/fuzzy.nvim",
      "rcarriga/cmp-dap",
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
          require "nvchad.configs.luasnip"
          ---@diagnostic disable-next-line: different-requires
          require "configs.luasnip"
        end,
      },
      {
        "windwp/nvim-autopairs",
        config = function()
          require "configs.autopair"
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
      ---@diagnostic disable-next-line: different-requires
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
  ----------------------------------------- enhance plugins ------------------------------------------
  {
    "okuuva/auto-save.nvim",
    event = { "InsertLeave", "TextChanged" },
    config = function()
      require "configs.autosave"
    end,
  },
  {
    "OXY2DEV/helpview.nvim",
    event = "VeryLazy",
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
    "rmagatti/auto-session",
    event = "VimEnter",
    config = function()
      require("auto-session").setup {
        auto_session_enabled = true,
        auto_save_enabled = true,
        auto_restore_enabled = true,
        auto_session_use_git_branch = true,
      }
    end,
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
    dependencies = {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        heading = {
          sign = false,
          icons = { " ", " ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
          width = 79,
        },
        code = {
          sign = false,
          width = "block", -- use 'language' if colorcolumn is important for you.
          right_pad = 1,
        },
        dash = {
          width = 79,
        },
        pipe_table = {
          style = "full", -- use 'normal' if colorcolumn is important for you.
        },
      },
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
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    dependencies = { "justinsgithub/wezterm-types" },
    cond = function()
      local term = vim.fn.getenv "TERM_PROGRAM"
      return term == "WezTerm"
    end,
    opts = {
      library = {
        { path = vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types", words = { "ChadrcConfig", "NvPluginSpec" } },
        { path = "wezterm-types", mods = { "wezterm" } },
      },
    },
  },
  {
    "m-demare/hlargs.nvim",
    event = "BufWinEnter",
    opts = {
      hl_priority = 200,
      extras = { named_parameters = true },
    },
  },
  {
    "tzachar/local-highlight.nvim",
    event = { "CursorHold", "CursorHoldI" },
    opts = {
      hlgroup = "Visual",
    },
  },
  {
    "mistweaverco/kulala.nvim",
    ft = { "http" },
    opts = {
      inlay = {
        loading_icon = "",
        done_icon = "",
      },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      scope = { enabled = false },
    },
  },
  {
    "smoka7/hop.nvim",
    cmd = { "HopWord", "HopLine", "HopLineStart", "HopWordCurrentLine", "HopNodes" },
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
    "echasnovski/mini.surround",
    event = { "ModeChanged" },
    ops = {},
  },
  {
    "declancm/vim2vscode",
    cmd = "Code",
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
        config = function()
          require("nvim-dap-virtual-text").setup {
            highlight_changed_variables = true,
            virt_text_pos = "eol",
            highlight_new_as_changed = true,
            show_stop_reason = true,
            commented = true,
            -- Hides tokens, secrets, and other sensitive information
            -- display_callback = function(variable)
            --   local name = string.lower(variable.name)
            --   local value = string.lower(variable.value)
            --   if name:match "secret" or name:match "api" or value:match "secret" or value:match "api" then
            --     return "*****"
            --   end

            --   if #variable.value > 15 then
            --     return " " .. string.sub(variable.value, 1, 15) .. "... "
            --   end

            --   return " " .. variable.value
            -- end,
          }
        end,
      },
      "ofirgall/goto-breakpoints.nvim",
      {
        "LiadOz/nvim-dap-repl-highlights",
        build = ":TSInstall dap_repl",
        opts = {},
      },
      {
        "rcarriga/nvim-dap-ui",
        config = function()
          require "configs.dapui"
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
    "MagicDuck/grug-far.nvim",
    event = "VeryLazy",
    config = function()
      local map = vim.keymap.set

      require("grug-far").setup {}

      local is_grugfar_open = function()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          local buf_name = vim.api.nvim_get_option_value("filetype", { buf = buf })
          if buf_name and buf_name == "grug-far" then
            return true
          end
        end
        return false
      end

      local toggle_grugfar = function()
        local open = is_grugfar_open()
        if open then
          require "grug-far/actions/close"()
        else
          vim.cmd "GrugFar"
        end
      end

      map("n", "<leader>gr", function()
        toggle_grugfar()
      end, { desc = "Toggle GrugFar" })
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
    "zeioth/garbage-day.nvim",
    event = "VeryLazy",
    opts = {
      notifications = false,
    },
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
    cmd = "TSJToggle",
    opts = {},
  },
  ----------------------------------------- ui plugins ------------------------------------------
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
      {
        "rcarriga/nvim-notify",
        opts = {
          top_down = false,
        },
        init = function()
          local banned_messages = {
            "No information available",
          }
          vim.notify = function(msg, ...)
            for _, banned in ipairs(banned_messages) do
              if msg == banned then
                return
              end
            end
            return require "notify"(msg, ...)
          end
        end,
      },
    },
    config = function()
      require "configs.noice"
      ---@diagnostic disable-next-line: different-requires
      vim.lsp.handlers["textDocument/hover"] = require("noice").hover
      ---@diagnostic disable-next-line: different-requires
      vim.lsp.handlers["textDocument/signatureHelp"] = require("noice").signature
    end,
  },
  {
    "petertriho/nvim-scrollbar",
    event = "WinScrolled",
    config = function()
      require "configs.scrollbar"
    end,
  },
  {
    "folke/todo-comments.nvim",
    event = "BufReadPost",
    config = function()
      require "configs.todo"
    end,
  },
  {
    "folke/trouble.nvim",
    ft = { "qf" },
    cmd = "Trouble",
    config = function()
      require("trouble").setup {
        modes = {
          project_diagnostics = {
            mode = "diagnostics",
            filter = {
              any = {
                {
                  function(item)
                    return item.filename:find(vim.fn.getcwd(), 1, true)
                  end,
                },
              },
            },
          },
          mydiags = {
            mode = "diagnostics",
            filter = {
              any = {
                buf = 0,
                {
                  severity = vim.diagnostic.severity.ERROR,
                  function(item)
                    return item.filename:find(true, 1, (vim.loop or vim.uv).cwd())
                  end,
                },
              },
            },
          },
        },
        auto_close = true,
        keys = {
          ["<Esc>"] = "close",
          ["<C-q>"] = "close",
          ["<C-c>"] = "close",
          ["R"] = "refresh",
          ["<space>"] = "preview",
          ["<cr>"] = "jump_close",
          ["l"] = "fold_open",
          ["h"] = "fold_close",
          ["]"] = "next",
          ["["] = "prev",
          ["[["] = false,
          ["]]"] = false,
        },
      }
    end,
  },
  {
    "b0o/schemastore.nvim",
    ft = { "json", "yaml", "yml" },
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
      require "configs.hlchunk"
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
    "BrunoKrugel/muren.nvim",
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
    event = "VeryLazy",
    opts = {
      default_mappings = {
        ours = "<leader>gco",
        theirs = "<leader>gct",
        none = "<leader>gc0",
        both = "<leader>gcb",
        next = "]c",
        prev = "[c",
      },
      disable_diagnostics = true,
      list_opener = function()
        require("trouble").open "quickfix"
      end,
    },
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
      require "configs.statuscol"
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    lazy = false,
    dependencies = "kevinhwang91/promise-async",
    config = function()
      require "configs.ufo"
    end,
  },
  -- {
  --   "chikko80/error-lens.nvim",
  --   event = "LspAttach",
  --   opts = {},
  -- },
  {
    "VonHeikemen/searchbox.nvim",
    cmd = { "SearchBoxMatchAll", "SearchBoxReplace", "SearchBoxIncSearch" },
    opts = {},
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
  -- {
  --   "utilyre/sentiment.nvim",
  --   event = "LspAttach",
  --   opts = {},
  --   init = function()
  --     vim.g.loaded_matchparen = 1
  --   end,
  -- },
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
      require "configs.command"
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
    "lewis6991/hover.nvim",
    config = function()
      require("hover").setup {
        init = function()
          require "hover.providers.lsp"
          require "hover.providers.dap"
          require "hover.providers.fold_preview"
          require "hover.providers.diagnostic"
        end,
        preview_opts = {
          border = "single",
        },
        preview_window = false,
        title = true,
        mouse_providers = {
          "LSP",
        },
        mouse_delay = 1000,
      }
    end,
  },
  {
    "Wansmer/symbol-usage.nvim",
    event = "BufReadPre",
    config = function()
      require "configs.symbol"
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
        { ft = "qf", title = "QuickFix" },
        { ft = "dap-repl", title = " Debug REPL" },
        { ft = "dapui_console", size = { height = 0.1 }, title = "Debug Console" },
        "Trouble",
        "Noice",
        {
          ft = "NoiceHistory",
          title = " Log",
          open = function()
            ---@diagnostic disable-next-line: different-requires
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
        { ft = "dapui_stacks", title = " Stacks" },
        { ft = "dapui_breakpoints", title = " Breakpoints" },
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
          ft = "grug-far",
          title = "Replace",
          size = { width = 0.2 },
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
    "utilyre/barbecue.nvim",
    event = "LspAttach",
    dependencies = { "SmiteshP/nvim-navic" },
    opts = {},
  },
  {
    "dnlhc/glance.nvim",
    cmd = "Glance",
    config = function()
      require "configs.glance"
    end,
  },
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
      require "configs.go"
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
      "dmmulroy/ts-error-translator.nvim",
    },
    config = function()
      require "configs.ts"
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
      "nvim-neotest/nvim-nio",
    },
    config = function()
      ---@diagnostic disable-next-line: different-requires
      require "configs.neotest"
    end,
  },
  {
    "andythigpen/nvim-coverage",
    ft = { "go", "javascript", "typescript", "javascriptreact", "typescriptreact" },
    opts = {
      auto_reload = true,
      lang = {
        go = {
          coverage_file = vim.fn.getcwd() .. "/coverage.out",
        },
      },
      signs = {
        covered = { hl = "CoverageCovered", text = "│" },
        uncovered = { hl = "CoverageUncovered", text = "│" },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    dependencies = { "rshkarin/mason-nvim-lint" },
    event = {
      "BufReadPre",
      "BufNewFile",
    },
    config = function()
      require "configs.linter"
    end,
  },
  {
    "stevearc/conform.nvim",
    event = "BufReadPre",
    dependencies = { "zapling/mason-conform.nvim" },
    config = function()
      require "configs.conform"
    end,
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
  {
    "sustech-data/wildfire.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "chrisgrieser/nvim-recorder",
    keys = { "q", "Q" },
    opts = {
      slots = { "a", "b", "c", "d", "e", "f", "g" },
      mapping = {
        startStopRecording = "q",
        playMacro = "Q",
        editMacro = "<leader>qe",
        switchSlot = "<leader>qt",
      },
      lessNotifications = true,
      clear = false,
      logLevel = vim.log.levels.INFO,
      dapSharedKeymaps = false,
    },
  },
  {
    "ThePrimeagen/refactoring.nvim",
    event = "BufRead",
    opts = {
      prompt_func_return_type = {
        go = true,
      },
      prompt_func_param_type = {
        go = true,
      },
    },
  },
  ----------------------------------------- completions plugins ------------------------------------------
  {
    "skywind3000/gutentags_plus",
    event = "VeryLazy",
    dependencies = { "ludovicchabant/vim-gutentags" },
    config = function()
      require "configs.tags"
    end,
  },
  {
    "github/copilot.vim",
    lazy = false,
    config = function()
      require("copilot").setup()
      vim.api.nvim_set_hl(0, "CopilotSuggestion", { fg = "#83a598" })
      vim.api.nvim_set_hl(0, "CopilotAnnotation", { fg = "#03a598" })
    end,
  },
}
