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
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "windwp/nvim-ts-autotag",
    },
    opts = overrides.treesitter,
  },
  {
    "NvChad/nvterm",
    opts = overrides.nvterm,
  },
  {
    "nvim-tree/nvim-web-devicons",
    dependencies = { "justinhj/battery.nvim", config = true },
    opts = overrides.devicons,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    -- enabled = false,
    opts = overrides.blankline,
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
  { "williamboman/mason.nvim", opts = overrides.mason },
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
      "f3fora/cmp-spell",
      -- "hrsh7th/cmp-path",
      "hrsh7th/cmp-vsnip",
      "delphinus/cmp-ctags",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "hrsh7th/cmp-copilot",
      "ray-x/cmp-treesitter",
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
  --------------------------------------------- custom plugins ----------------------------------------------
  {
    "nvim-telescope/telescope-ui-select.nvim",
    event = "VeryLazy",
    config = function()
      require("telescope").load_extension "ui-select"
    end,
  },
  {
    "numToStr/Navigator.nvim",
    cmd = { "NavigatorLeft", "NavigatorRight", "NavigatorUp", "NavigatorDown" },
    config = function()
      require("Navigator").setup()
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
    "kristijanhusak/vim-js-file-import",
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    build = "npm install",
  },
  {
    "declancm/vim2vscode",
    cmd = "Code",
  },
  {
    "ThePrimeagen/harpoon",
    cmd = "Harpoon",
  },
  {
    "hrsh7th/cmp-cmdline",
    event = "CmdLineEnter",
  },
  {
    "AckslD/muren.nvim",
    cmd = "MurenToggle",
    config = true,
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
  { "HampusHauffman/bionic.nvim", cmd = { "Bionic" } },
  {
    "wuelnerdotexe/vim-astro",
    event = "VeryLazy",
    ft = "astro",
  },
  -- {
  --   "b0o/incline.nvim",
  --   event = "VeryLazy",
  --   config = function()
  --     require "custom.configs.incline"
  --   end,
  -- },
  {
    "nvim-treesitter/playground",
    cmd = "TSCaptureUnderCursor",
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
    "numToStr/Comment.nvim",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring", ft = "javascriptreact" },
    config = function()
      require("Comment").setup {
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      }
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
    "MattesGroeger/vim-bookmarks",
    cmd = "BookmarkToggle",
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
    "kevinhwang91/nvim-hlslens",
    event = "BufReadPost",
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
      require "custom.configs.hlchunk"
    end,
  },
  {
    "sindrets/diffview.nvim",
    cmd = "DiffviewOpen",
    config = true,
  },
  {
    "tenxsoydev/karen-yank.nvim",
    event = "VeryLazy",
    config = true,
  },
  {
    "chikko80/error-lens.nvim",
    event = "LspAttach",
    ft = "go",
    config = true,
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
  },
  {
    "smjonas/inc-rename.nvim",
    event = "LspAttach",
    config = true,
  },
  {
    "toppair/peek.nvim",
    build = "deno task --quiet build:fast",
    ft = { "markdown", "vimwiki" },
    config = function()
      require("peek").setup {
        app = "firefox",
        filetype = { "markdown", "vimwiki" },
      }
    end,
    init = function()
      vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
      vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    end,
  },
  -- { 'mrjones2014/smart-splits.nvim', config = true, event = "BufReadPost" },
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
              listCount = 3, -- #completions for panel  listCount = 3,          -- #completions for panel  listCount = 3,          -- #completions for panel
              inlineSuggestCount = 3, -- #completions for getCompletions
            },
          },
        },
      }
    end,
  },
  { "tpope/vim-surround", event = "VeryLazy" },
  {
    "zbirenbaum/copilot-cmp",
    event = "VeryLazy",
    dependencies = { "zbirenbaum/copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
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
  {
    "gennaro-tedesco/nvim-possession",
    lazy = false,
    dependencies = {
      "ibhagwan/fzf-lua",
    },
    config = function()
      require("nvim-possession").setup {
        autoload = false,
        sessions = {
          sessions_icon = "",
        },
      }
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
  {
    "james1236/backseat.nvim",
    cmd = { "Backseat", "BackseatClear" },
    config = function()
      require("backseat").setup {
        -- Alternatively, set the env var $OPENAI_API_KEY by putting "export OPENAI_API_KEY=sk-xxxxx" in your ~/.bashrc
        -- openai_api_key = 'sk-xxxxxxxxxxxxxx', -- Get yours from platform.openai.com/account/api-keys
        openai_model_id = "gpt-3.5-turbo", --gpt-4 (If you do not have access to a model, it says "The model does not exist")
        -- language = 'english', -- Such as 'japanese', 'french', 'pirate', 'LOLCAT'
        -- split_threshold = 100,
        -- additional_instruction = "Respond snarkily", -- (GPT-3 will probably deny this request, but GPT-4 complies)
        highlight = {
          icon = "󱚟", -- ''
          -- group = 'Comment',
        },
      }
    end,
  },
  {
    "jackMort/ChatGPT.nvim",
    cmd = "ChatGPT",
    config = function()
      require "custom.configs.gpt"
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
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
    "rainbowhxch/accelerated-jk.nvim",
    dependencies = "nvim-treesitter",
    event = "VeryLazy",
    config = function()
      require "custom.configs.accelerated-jk"
    end,
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
    cmd = { "TroubleToggle", "Trouble" },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require "custom.configs.trouble"
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
    "Pocco81/auto-save.nvim",
    event = "BufReadPost",
    config = function()
      require "custom.configs.autosave"
    end,
  },
  {
    "lvimuser/lsp-inlayhints.nvim",
    event = "LspAttach",
    config = function()
      require "custom.configs.lsp-inlayhints"
    end,
  },
  {
    "ray-x/go.nvim",
    ft = { "go", "gomod" },
    dependencies = { {
      "ray-x/guihua.lua",
      build = "cd lua/fzy && make",
    }, "nvim-treesitter" },
    config = function()
      require "custom.configs.go"
    end,
  },
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    -- ft = { "go", "gomod" },
    keys = { "<leader>ls" },
    config = function()
      require("lsp_lines").setup()
    end,
  },
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
    cmd = { "SearchBoxMatchAll", "SearchBoxReplace", "SearchBoxIncSearch" },
    config = true,
  },
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
  {
    "f-person/git-blame.nvim",
    cmd = "GitBlameToggle",
  },
  { "mfussenegger/nvim-dap", event = "VeryLazy" },
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = { "theHamsta/nvim-dap-virtual-text", config = true },
  },
  {
    "mrjones2014/nvim-ts-rainbow",
    event = "BufReadPost",
    dependencies = "nvim-treesitter",
  },
  {
    "folke/todo-comments.nvim",
    event = "BufWinEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require "custom.configs.todo"
    end,
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "BufReadPost",
    config = true,
  },
  {
    "ludovicchabant/vim-gutentags",
    lazy = false,
  },
  {
    "mg979/vim-visual-multi",
    cmd = "VisualMulti",
  },
  {
    "dstein64/vim-startuptime",
    config = function()
      vim.cmd "let $NEOVIM_MEASURE_STARTUP_TIME = 'TRUE'"
    end,
    cmd = { "StartupTime" },
  },
  { "echasnovski/mini.surround", event = "VeryLazy" },
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
    "vuki656/package-info.nvim",
    ft = { "json", "lua" },
    config = true,
  },
  { "danilamihailov/beacon.nvim", event = "BufReadPost" },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "BufWinEnter",
    config = function()
      require "custom.configs.textobjects"
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
