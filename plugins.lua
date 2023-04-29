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
  --     vim.notify = require("noice").notify
  --     vim.lsp.handlers["textDocument/hover"] = require("noice").hover
  --     vim.lsp.handlers["textDocument/signatureHelp"] = require("noice").signature
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
      "windwp/nvim-ts-autotag",
    },
    opts = overrides.treesitter,
  },
  {
    "nvim-tree/nvim-web-devicons",
    opts = overrides.devicons,
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
    "hrsh7th/cmp-cmdline",
    event = "CmdLineEnter",
  },
  {
    "Snyssfx/goerr-nvim",
    ft = "go",
  },
  {
    "wuelnerdotexe/vim-astro",
    ft = "astro",
  },
  {
    "nvim-treesitter/playground",
    cmd = "TSCaptureUnderCursor",
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
  -- { 
  --   "xiyaowong/virtcolumn.nvim",
  --   config = true,
  --   event = "BufReadPre",
  -- },
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
    "sindrets/diffview.nvim",
    cmd = "DiffviewOpen",
    config = true,
  },
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    config = true,
  },
  { "tenxsoydev/karen-yank.nvim", config = true },
  -- {
  --   "chikko80/error-lens.nvim",
  --   event = "BufRead",
  --   dependencies = {
  --       "nvim-telescope/telescope.nvim",
  --   }
  -- },
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
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
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
      local neotest_ns = vim.api.nvim_create_namespace("neotest")
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message =
              diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)
      require("neotest").setup({
        -- your neotest config here
        adapters = {
          require("neotest-go"),
        },
      })
    end,
  },
  -- :Backseat
  -- :BackseatClear
  {
    "james1236/backseat.nvim",
    config = function()
        require("backseat").setup({
            -- Alternatively, set the env var $OPENAI_API_KEY by putting "export OPENAI_API_KEY=sk-xxxxx" in your ~/.bashrc
            -- openai_api_key = 'sk-xxxxxxxxxxxxxx', -- Get yours from platform.openai.com/account/api-keys
            openai_model_id = 'gpt-3.5-turbo', --gpt-4 (If you do not have access to a model, it says "The model does not exist")
            -- language = 'english', -- Such as 'japanese', 'french', 'pirate', 'LOLCAT'
            -- split_threshold = 100,
            -- additional_instruction = "Respond snarkily", -- (GPT-3 will probably deny this request, but GPT-4 complies)
            -- highlight = {
            --     icon = '', -- ''
            --     group = 'Comment',
            -- }
        })
    end
  },
  {
    "luukvbaal/statuscol.nvim", config = function()
      -- local builtin = require("statuscol.builtin")
      require("statuscol").setup({
        -- configuration goes here, for example:
        -- relculright = true,
        -- segments = {
        --   { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
        --   {
        --     sign = { name = { "Diagnostic" }, maxwidth = 2, auto = true },
        --     click = "v:lua.ScSa"
        --   },
        --   { text = { builtin.lnumfunc }, click = "v:lua.ScLa", },
        --   {
        --     sign = { name = { ".*" }, maxwidth = 2, colwidth = 1, auto = true, wrap = true },
        --     click = "v:lua.ScSa"
        --   },
        -- }
      })
    end,
  },
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
    ft = { "go", "gomod" },
    dependencies = { "ray-x/guihua.lua", "nvim-treesitter" },
    config = function()
      require "custom.configs.go"
    end,
  },
  -- {
  --   "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  --   event = "BufReadPost",
  --   config = function()
  --     require("lsp_lines").setup()
  --   end,
  -- },
  {
    "github/copilot.vim",
    lazy = false,
    config = function()
      require "custom.configs.copilot"
    end,
  },
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
  { "mfussenegger/nvim-dap" },
  { "rcarriga/nvim-dap-ui" },
  { "theHamsta/nvim-dap-virtual-text" },
  { "ray-x/guihua.lua" },
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
  -- { 
  --   "mg979/vim-visual-multi",
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
}

return plugins
