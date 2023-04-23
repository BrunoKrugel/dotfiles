local overrides = require "custom.configs.overrides"

---@type NvPluginSpec[]
local plugins = {

  -- Override plugin definition options

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- format & linting
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
    end, -- Override to setup mason-lspconfig
  },

  -- overrde plugin configs
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      { "JoosepAlviste/nvim-ts-context-commentstring", ft = "javascriptreact" },
    },
    opts = overrides.treesitter,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = overrides.blankline,
  },
  {
    "hrsh7th/nvim-cmp",
    opts = overrides.cmp,
    dependencies = {
      -- "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-calc",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      -- "hrsh7th/cmp-path",
      "hrsh7th/cmp-vsnip",
      "delphinus/cmp-ctags",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "hrsh7th/cmp-copilot",
      "ray-x/cmp-treesitter",
      "hrsh7th/cmp-nvim-lsp-signature-help",
    },
  },
  {
    "hrsh7th/cmp-cmdline",
    event = "CmdLineEnter",
  },
  {
    "Snyssfx/goerr-nvim",
    ft = "go",
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },

  { 
    "nvim-telescope/telescope.nvim", 
    opts = overrides.telescope,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "debugloop/telescope-undo.nvim",
      "tom-anders/telescope-vim-bookmarks.nvim",
    },
  },
  { "williamboman/mason.nvim", opts = overrides.mason },
  {
    "nvim-telescope/telescope-frecency.nvim",
    event = "VimEnter",
    dependencies = { "kkharji/sqlite.lua" },
  },
  -- { "mikelue/vim-maven-plugin" },
  {
    "anuvyklack/pretty-fold.nvim",
    config = function()
      require "custom.configs.pretty-fold"
    end,
  },
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup {
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      }
    end,
  },
  {
    "m-demare/hlargs.nvim",
    event = "VimEnter",
    config = function()
      require("hlargs").setup()
    end,
  },
  { 
    "xiyaowong/virtcolumn.nvim",
    event = "VimEnter",
  },
  {
    'kevinhwang91/nvim-ufo',
    dependencies = {'kevinhwang91/promise-async'},
  },
  {
    "MattesGroeger/vim-bookmarks",
    event = "BufReadPost",
  },
  {
    "jonahgoldwastaken/copilot-status.nvim",
    dependencies = { "copilot.lua" }, -- or "zbirenbaum/copilot.lua"
    lazy = true,
    event = "BufReadPost",
    config = function()
      require('copilot_status').setup({
        icons = {
          idle = " ",
          error = " ",
          offline = " ",
          warning = "𥉉 ",
          loading = " ",
        },
        debug = false,
      })
    end,
  },
  {
    "kevinhwang91/nvim-hlslens",
    config = function()
      require("hlslens").setup()
    end,
  },
  {
    "petertriho/nvim-scrollbar",
    event = "VimEnter",
    config = true,
  },
  {
    "shellRaining/hlchunk.nvim",
    event = "BufReadPost",
    config = function()
      require("hlchunk").setup {
        chunk = {
          enable = true,
          support_filetypes = {
            "*.ts",
            "*.js",
            "*.json",
            "*.go",
            "*.c",
            "*.cpp",
            "*.rs",
            "*.h",
            "*.hpp",
            "*.lua",
            "*.vue",
          },
          chars = {
            horizontal_line = "─",
            vertical_line = "│",
            left_top = "╭",
            left_bottom = "╰",
            right_arrow = ">",
          },
          style = "#806d9c",
        },

        indent = {
          enable = false,
          use_treesitter = false,
          -- You can uncomment to get more indented line look like
          chars = {
            "│",
          },
          -- you can uncomment to get more indented line style
          style = {
            vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID "Whitespace"), "fg", "gui"),
          },
          exclude_filetype = {
            dashboard = true,
            help = true,
            lspinfo = true,
            packer = true,
            checkhealth = true,
            man = true,
            mason = true,
            NvimTree = true,
            plugin = true,
          },
        },

        line_num = {
          enable = true,
          support_filetypes = {
            "...",
          },
          style = "#806d9c",
        },

        blank = {
          enable = false,
          chars = {
            "",
          },
          style = {
            vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID "Whitespace"), "fg", "gui"),
          },
          exclude_filetype = "...",
        },
      }
    end,
  },
  {
    "chikko80/error-lens.nvim",
    event = "BufRead",
    dependencies = {
        "nvim-telescope/telescope.nvim",
    }
  },
  { "tenxsoydev/karen-yank.nvim", config = true },
  -- {
  --   'ray-x/sad.nvim',
  --   dev = (plugin_folder():find('github') ~= nil),
  --   cmd = { 'Sad' },
  --   lazy = true,
  --   config = function()
  --     require('sad').setup({
  --       debug = true,
  --       vsplit = false,
  --       height_ratio = 0.8,
  --       autoclose = false,
  --     })
  --   end,
  -- },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup {
        suggestion = {
          enabled = false,
          auto_trigger = false,
          keymap = {
            accept = "<Tab>",
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
              listCount = 3, -- #completions for panel
              inlineSuggestCount = 3, -- #completions for getCompletions
            },
          },
        },
      }
    end,
  },

  {
    "zbirenbaum/copilot-cmp",
    event = "VeryLazy",
    after = { "copilot.lua" },
    dependencies = { "zbirenbaum/copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end,
  },

  {
    "folke/which-key.nvim",
    enabled = true,
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = "nvim-lspconfig",
    config = function()
      require "custom.configs.null-ls"
    end,
  },
  -- -- {
  -- --   "rmagatti/goto-preview",
  -- --   config = function()
  -- --     require("goto-preview").setup({
  -- --       border = "rounded",
  -- --       default_mappings = true,
  -- --     })
  -- --   end,
  -- -- },
  {
    "abecodes/tabout.nvim",
    lazy = true,
    event = "InsertEnter",
    dependencies = "nvim-cmp",
    config = function()
      require "custom.configs.tabout"
    end,
  },

  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    config = true,
  },

  -- {
  --   "jelera/vim-javascript-syntax",
  --   dependencies = "nvim-treesitter",
  --   ft = { "javascript", "javascriptreact" },
  -- },

  {
    "phaazon/hop.nvim",
    lazy = true,
    dependencies = "ui",
    event = "BufReadPost",
    branch = "v2",
    config = function()
      require "custom.configs.hop"
    end,
  },

  {
    "rainbowhxch/accelerated-jk.nvim",
    lazy = true,
    dependencies = "nvim-treesitter",
    event = "BufWinEnter",
    config = function()
      require "custom.configs.accelerated-jk"
    end,
  },
  
  {
    "RRethy/vim-illuminate",
    lazy = true,
    event = "BufReadPost",
    dependencies = "nvim-treesitter",
    config = function()
      require "custom.configs.illuminate"
    end,
  },

  -- {
  --   "dstein64/nvim-scrollview",
  --   lazy = true,
  --   event = { "BufReadPost" },
  --   config = function()
  --     require "custom.configs.scrollview"
  --   end,
  -- },

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
    "folke/trouble.nvim",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require "custom.configs.trouble"
    end,
  },
  {
    "karb94/neoscroll.nvim",
    lazy = true,
    event = "BufReadPost",
    config = function()
      require "custom.configs.neoscroll"
    end,
  },
  {
    "filipdutescu/renamer.nvim",
    event = "BufWinEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require "custom.configs.renamer"
    end,
  },

  {
    "Pocco81/auto-save.nvim",
    lazy = true,
    event = "BufReadPost",
    config = function()
      require "custom.configs.autosave"
    end,
  },
  {
    "lvimuser/lsp-inlayhints.nvim",
    config = function()
      require "custom.configs.lsp-inlayhints"
    end,
  },
  {
    "ray-x/go.nvim",
    lazy = true,
    dependencies = { "ray-x/guihua.lua" },
    ft = { "go", "gomod" },
    dependencies = { "ray-x/guihua.lua", "nvim-treesitter" },
    dependencies = "nvim-treesitter",
    dependencies = { "ray-x/guihua.lua", "nvim-treesitter" },
    config = function()
      require "custom.configs.go"
    end,
  },
  {
    "github/copilot.vim",
    lazy = false,
    config = function()
      require "custom.configs.copilot"
    end,
  },
  -- { "brenoprata10/nvim-highlight-colors",
  --   config = function()
  --     require("nvim-highlight-colors").setup()
  --   end,
  -- },
  {
    "VonHeikemen/searchbox.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    event = "BufReadPost",
    config = function()
      require "custom.configs.searchbox"
    end,
  },
  {
    "tzachar/cmp-tabnine",
    lazy = false,
    dependencies = "hrsh7th/nvim-cmp",
    build = "./install.sh",
    config = function()
      require('cmp_tabnine.config').setup {
        max_lines = 1000,
        max_num_results = 20,
        sort = true,
        run_on_every_keystroke = true,
        snippet_placeholder = '..',
        show_prediction_strength = false
      }
    end,
  },
  { "mfussenegger/nvim-dap" },
  { "rcarriga/nvim-dap-ui" },
  { "theHamsta/nvim-dap-virtual-text" },
  { "ray-x/guihua.lua" },
  -- {
  --   "avneesh0612/react-nextjs-snippets"
  --   ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  -- },
  {
    "mrjones2014/nvim-ts-rainbow",
    event = "BufReadPost",
    dependencies = "nvim-treesitter",
  },
  -- { 
  --   "braxtons12/blame_line.nvim",
  --   event = "BufReadPost",
  --   config = function()
  --     require "custom.configs.blameline"
  --   end,
  -- },
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = true,
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "BufReadPost",
    config = true,
  },
  -- { 
  --   "mfussenegger/nvim-jdtls",
  --   config = true,
  -- },
  -- { "neovim/nvim-lspconfig",
  --   config = function()
  --     -- require("plugins.configs.lspconfig")
  --     require "custom.configs.lspconfig"
  --     -- Noice
  --     vim.notify = require("noice").notify
  --     vim.lsp.handlers["textDocument/hover"] = require("noice").hover
  --     vim.lsp.handlers["textDocument/signatureHelp"] = require("noice").signature
  --   end,
  -- },
  -- {
  --   "kosayoda/nvim-lightbulb",
  --   event = "BufWinEnter",
  --   dependencies = {
  --     "antoinemadec/FixCursorHold.nvim",
  --   },
  -- },
  {
    "ludovicchabant/vim-gutentags",
    lazy = false,
  },
  -- { "mg979/vim-visual-multi",
  --   lazy = true,
  --   event = "BufReadPost",
  --   setup = function()
  --     require "custom.configs.visual-multi"
  --   end,
  -- },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "BufWinEnter",
    config = function()
      require "custom.configs.textobjects"
    end,
  },
  {
    "onsails/lspkind.nvim",
    config = function()
      require "custom.configs.lspkind"
    end,
  },
  {
    "glepnir/lspsaga.nvim",
    lazy = false,
    config = function()
      require "custom.configs.lspsaga"
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufWinEnter",
    config = function()
      require "custom.configs.ts-context"
    end,
  },
  {
    "melkster/modicator.nvim",
    event = "BufWinEnter",
    config = function()
      require "custom.configs.modicator"
    end,
  },
  -- { "MaximilianLloyd/ascii.nvim" },
}

return plugins
