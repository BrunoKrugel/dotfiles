local overrides = require "custom.configs.overrides"
local cmp_opt = require "custom.configs.cmp"

---@type NvPluginSpec[]
local plugins = {
  --------------------------------------------- community ---------------------------------------------
  { "BrunoKrugel/nvcommunity" },
  ----------------------------------------- override plugins ------------------------------------------
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
          require "custom.configs.null-ls"
        end,
      },
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
      { "folke/neodev.nvim", opts = {} },
    },
    config = function() end,
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
      "tom-anders/telescope-vim-bookmarks.nvim",
      "benfowler/telescope-luasnip.nvim",
      "nvim-telescope/telescope-dap.nvim",
      "Marskey/telescope-sg",
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
      "echasnovski/mini.ai",
      "piersolenski/telescope-import.nvim",
      "LiadOz/nvim-dap-repl-highlights",
      "RRethy/nvim-treesitter-textsubjects",
      {
        "Jxstxs/conceal.nvim",
        config = function()
          local conceal = require "conceal"
          conceal.setup {
            ["lua"] = {
              enabled = false,
            },
          }
          conceal.generate_conceals()
        end,
      },
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
      "hrsh7th/cmp-cmdline",
      "tzachar/cmp-fuzzy-buffer",
      "roobert/tailwindcss-colorizer-cmp.nvim",
      "tzachar/fuzzy.nvim",
      "rcarriga/cmp-dap",
      {
        "petertriho/cmp-git",
        opts = {},
        config = function()
          local cmp = require "cmp"
          ---@diagnostic disable-next-line: missing-fields
          cmp.setup.filetype("gitcommit", {
            sources = cmp.config.sources({
              { name = "git", priority = 50 },
              { name = "path", priority = 40 },
            }, {
              { name = "buffer", priority = 50 },
              { name = "emoji", insert = true, priority = 20 },
            }),
          })
        end,
      },
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
          require("plugins.configs.others").luasnip(opts)
          require "custom.configs.luasnip"
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
          item = require("cmp-tailwind-colors").format(entry, item)
          if item.kind == "Color" then
            return format_kinds(entry, item)
          end
          return item
        end
        return format_kinds(entry, item)
      end
      local cmp = require "cmp"

      cmp.setup(opts)

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = opts.mapping,
        sources = {
          { name = "buffer" },
        },
      })
      cmp.setup.cmdline(":", {
        mapping = opts.mapping,
        sources = cmp.config.sources({
          { name = "cmdline" },
        }, {
          { name = "path" },
        }),
      })

      cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
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
      require "custom.configs.session"
    end,
  },
  { "b0o/schemastore.nvim" },
  -- {
  --   "ahmedkhalf/project.nvim",
  --   opts = {
  --     manual_mode = false,
  --     detection_methods = { "pattern", "lsp" },
  --     patterns = { ".git", ".vscode", ".svn", "Makefile", "package.json" },
  --     ignore_lsp = {},
  --     exclude_dirs = {},
  --     show_hidden = false,
  --     silent_chdir = true,
  --     scope_chdir = "global",
  --     datapath = vim.fn.stdpath "data",
  --   },
  --   event = "VeryLazy",
  --   config = function(_, opts)
  --     require("project_nvim").setup(opts)
  --   end,
  -- },
  {
    "ThePrimeagen/harpoon",
    cmd = "Harpoon",
  },
  {
    "epwalsh/obsidian.nvim",
    ft = "markdown",
    config = function()
      require("obsidian").setup {
        dir = "/users/bruno.krugel/Library/Mobile Documents/iCloud~md~obsidian/Documents/Annotation",
        disable_frontmatter = true,
        completion = {
          nvim_cmp = true, -- if using nvim-cmp, otherwise set to false
        },
        -- Optional, key mappings.
        mappings = {
          -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
          ["ogf"] = require("obsidian.mapping").gf_passthrough(),
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
    "code-biscuits/nvim-biscuits",
    event = "LspAttach",
    config = function()
      require "custom.configs.biscuits"
    end,
  },
  {
    "jonahgoldwastaken/copilot-status.nvim",
    event = "LspAttach",
    config = function()
      require("copilot_status").setup {
        icons = {
          idle = " ",
          error = " ",
          offline = " ",
          warning = " ",
          loading = " ",
        },
        debug = false,
      }
    end,
  },
  {
    "rainbowhxch/accelerated-jk.nvim",
    event = "CursorMoved",
    config = function()
      require "custom.configs.accelerated"
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
    "MattesGroeger/vim-bookmarks",
    cmd = { "BookmarkToggle", "BookmarkClear" },
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
    "nvim-treesitter/nvim-treesitter-context",
    event = "LspAttach",
    opts = {
      throttle = true,
      max_lines = 0,
      patterns = {
        default = {
          "class",
          "function",
          "method",
        },
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    cmd = { "DapContinue", "DapStepOver", "DapStepInto", "DapStepOut", "DapToggleBreakpoint" },
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
    "Weissle/persistent-breakpoints.nvim",
    event = "BufReadPost",
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
    cmd = "CCToggle",
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
        encode_url = true, -- Encode URL before making request
        result = {
          show_url = false,
          show_http_info = true,
          show_headers = false,
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
  -- {
  --   "zbirenbaum/neodim",
  --   event = "LspAttach",
  --   branch = "v2",
  --   opts = {
  --     alpha = 0.75,
  --     blend_color = "#000000",
  --     update_in_insert = {
  --       enable = true,
  --       delay = 100,
  --     },
  --     hide = {
  --       virtual_text = true,
  --       signs = true,
  --       underline = true,
  --     },
  --   },
  -- },
  {
    "narutoxy/dim.lua",
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
    "rainbowhxch/beacon.nvim",
    event = "CursorMoved",
    cond = function()
      return not vim.g.neovide
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
    "weilbith/nvim-code-action-menu",
    cmd = "CodeActionMenu",
    init = function()
      vim.g.code_action_menu_show_details = true
      vim.g.code_action_menu_show_diff = true
      vim.g.code_action_menu_show_action_kind = true
    end,
    config = function()
      dofile(vim.g.base46_cache .. "git")
      dofile(vim.g.base46_cache .. "codeactionmenu")
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
    opts = {
      post_hook = function(results)
        if not results.changes then
          return
        end

        -- if more than one file is changed, save all buffers
        local filesChang = #vim.tbl_keys(results.changes)
        if filesChang > 1 then
          vim.cmd.wall()
        end

        -- FIX making the cmdline-history not navigable, pending: https://github.com/smjonas/inc-rename.nvim/issues/40
        vim.fn.histdel("cmd", "^IncRename ")
      end,
    },
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
    "m4xshen/hardtime.nvim",
    cmd = { "Hardtime" },
    opts = {},
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
    "kevinhwang91/nvim-ufo",
    event = "VimEnter",
    dependencies = {
      "kevinhwang91/promise-async",
      {
        "luukvbaal/statuscol.nvim",
        config = function()
          require "custom.configs.statuscol"
        end,
      },
    },
    config = function()
      require "custom.configs.ufo"
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
    event = "VeryLazy",
    config = function()
      require "custom.configs.command"
    end,
  },
  {
    "kevinhwang91/nvim-hlslens",
    event = "BufReadPost",
    config = function()
      require("scrollbar.handlers.search").setup {
        {
          nearest_float_when = false,
          override_lens = function(render, posList, nearest, idx, relIdx)
            local sfw = vim.v.searchforward == 1
            local indicator, text, chunks
            local absRelIdx = math.abs(relIdx)
            if absRelIdx > 1 then
              indicator = ("%d%s"):format(absRelIdx, sfw ~= (relIdx > 1) and icons.misc.up or icons.misc.down)
            elseif absRelIdx == 1 then
              indicator = sfw ~= (relIdx == 1) and icons.misc.up or icons.misc.down
            else
              indicator = icons.misc.dot
            end
            local lnum, col = unpack(posList[idx])
            if nearest then
              local cnt = #posList
              if indicator ~= "" then
                text = ("[%s %d/%d]"):format(indicator, idx, cnt)
              else
                text = ("[%d/%d]"):format(idx, cnt)
              end
              chunks = { { " ", "Ignore" }, { text, "HlSearchLensNear" } }
            else
              text = ("[%s %d]"):format(indicator, idx)
              chunks = { { " ", "Ignore" }, { text, "HlSearchLens" } }
            end
            render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
          end,
        },
      }
    end,
  },
  {
    "tzachar/highlight-undo.nvim",
    event = "BufReadPost",
    opts = {},
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
    opts = {},
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
    event = "LspAttach",
    opts = {},
  },
  {
    "VidocqH/lsp-lens.nvim",
    event = "LspAttach",
    config = true,
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
          size = { height = 0.2 },
        },
        { ft = "spectre_panel", size = { height = 0.4 } },
        { ft = "qf", title = "QuickFix" },
        { ft = "dapui_watches", title = "Watches" },
        { ft = "dap-repl", title = "Debug REPL" },
        { ft = "dapui_console", title = "Debug Console" },
        "Trouble",
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
            toggle_noice()
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
        { ft = "dapui_scopes", title = "Scopes" },
        { ft = "dapui_breakpoints", title = "Breakpoints" },
        { ft = "dapui_stacks", title = "Stacks" },
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
        bottom = { size = 20 },
        right = { size = 30 },
        top = { size = 10 },
      },
      wo = {
        winbar = false,
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
    dependencies = {
      {
        "David-Kunz/cmp-npm",
        opts = {},
      },
    },
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
      package_manager = "yarn",
    },
  },
  {
    "nvim-neotest/neotest",
    event = "LspAttach",
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
    "javiorfo/nvim-soil",
    ft = "plantuml",
    dependencies = { "javiorfo/nvim-nyctophilia" },
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
    "axelvc/template-string.nvim",
    event = "InsertEnter",
    ft = {
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
    },
    opts = {},
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
    "Zeioth/markmap.nvim",
    build = "yarn global add markmap-cli",
    cmd = { "MarkmapOpen", "MarkmapSave", "MarkmapWatch", "MarkmapWatchStop" },
    opts = {
      html_output = "/tmp/markmap.html", -- (default) Setting a empty string "" here means: [Current buffer path].html
      hide_toolbar = false, -- (default)
      grace_period = 3600000, -- (default) Stops markmap watch after 60 minutes. Set it to 0 to disable the grace_period.
    },
    config = function(_, opts)
      require("markmap").setup(opts)
    end,
  },
  {
    "malbertzard/inline-fold.nvim",
    event = "BufReadPost",
    opts = {
      defaultPlaceholder = "…",
      queries = {
        html = {
          { pattern = 'class="([^"]*)"', placeholder = "@" }, -- classes in html
          { pattern = 'href="(.-)"' }, -- hrefs in html
          { pattern = 'src="(.-)"' }, -- HTML img src attribute
        },
        go = {
          { pattern = "^%s*if err != nil {", placeholder = "if err != nil .." },
        },
      },
    },
  },
  ----------------------------------------- completions plugins ------------------------------------------
  {
    "ludovicchabant/vim-gutentags",
    -- lazy = false,
    event = { "BufNewFile", "BufReadPost" },
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
