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
    dependencies = { "justinhj/battery.nvim", config = true },
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
      {
        "mrjones2014/nvim-ts-rainbow",
        event = "BufReadPost",
      },
      "windwp/nvim-ts-autotag",
    },
    opts = overrides.treesitter,
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },
  {
    "hrsh7th/nvim-cmp",
    opts = overrides.cmp,
    dependencies = {
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-calc",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "f3fora/cmp-spell",
      "hrsh7th/cmp-vsnip",
      "delphinus/cmp-ctags",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "hrsh7th/cmp-copilot",
      "ray-x/cmp-treesitter",
      {
        "hrsh7th/cmp-cmdline",
        event = "CmdLineEnter",
      },
      "hrsh7th/cmp-nvim-lsp-signature-help",
      { "jcdickinson/codeium.nvim", config = true },
      {
        "tzachar/cmp-tabnine",
        build = "./install.sh",
        config = function()
          local tabnine = require "cmp_tabnine.config"
          tabnine:setup {} -- put your options here
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
    "ThePrimeagen/harpoon",
    cmd = "Harpoon",
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
    keys = { "<leader>i" },
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
    dependencies = { { "theHamsta/nvim-dap-virtual-text", config = true }, "rcarriga/nvim-dap-ui" },
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
    cmd = "CCToggle",
    config = function()
      require("virt-column").setup {
        char = "|",
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
  ----------------------------------------- ui plugins ------------------------------------------
  {
    "folke/noice.nvim",
    lazy = false,
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
    event = "LspAttach",
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
  { "danilamihailov/beacon.nvim", event = "BufReadPost" },
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
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      {
        "luukvbaal/statuscol.nvim",
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
    },
    event = "BufReadPost",
    keys = { "zf", "zo", "za", "zc", "zM", "zR" },
    config = function()
      require("ufo").setup {
        provider_selector = function()
          return { "treesitter", "indent" }
        end,
      }
    end,
  },
  {
    "jinzhongjia/LspUI.nvim",
    event = "VeryLazy",
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
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "m00qek/baleia.nvim",
        tag = "v1.3.0",
      },
    },
    opts = {
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
    },
    init = function()
      if not vim.fn.executable "ascii-image-converter" then
        vim.api.nvim_command 'echo "Command is not executable. snap install ascii-image-converter"'
      end
    end,
    ft = { "png", "jpg", "jpeg" },
  },
  {
    "VonHeikemen/searchbox.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    cmd = { "SearchBoxMatchAll", "SearchBoxReplace", "SearchBoxIncSearch" },
    config = true,
  },
  {
    "sindrets/diffview.nvim",
    cmd = "DiffviewOpen",
    config = true,
  },
  {
    "kevinhwang91/nvim-hlslens",
    event = "BufReadPost",
    config = function()
      require("hlslens").setup()
    end,
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
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    config = function()
      require "custom.configs.lspsaga"
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
      "nvim-treesitter",
    },
    config = function()
      require "custom.configs.go"
    end,
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
    "kristijanhusak/vim-js-file-import",
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    build = "npm install",
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
      -- get neotest namespace (api call creates or returns namespace)
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
        -- your neotest config here
        adapters = {
          require "neotest-go" {
            args = { "-count=1", "-coverprofile coverage.out", "-covermode=count" },
          },
        },
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
