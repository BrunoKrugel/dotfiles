return {
    ["jose-elias-alvarez/null-ls.nvim"] = {
      after = "nvim-lspconfig",
      config = function()
        require "custom.plugins.config.null-ls"
      end,
    },
  
    ["phaazon/hop.nvim"] = {
      opt = true,
      event = "BufReadPost",
      branch = "v2",
      config = function()
        require "custom.plugins.config.hop"
      end,
    },
  
    ["rainbowhxch/accelerated-jk.nvim"] = {
      opt = true,
      event = "BufWinEnter",
      config = function()
        require "custom.plugins.config.accelerated-jk"
      end,
    },
  
    ["RRethy/vim-illuminate"] = {
      opt = true,
      event = "BufReadPost",
      config = function()
        require "custom.plugins.config.illuminate"
      end,
    },
  
    ["dstein64/nvim-scrollview"] = {
      opt = true,
      event = { "BufReadPost" },
      config = function()
        require "custom.plugins.config.scrollview"
      end,
    },
  
    ["folke/noice.nvim"] = {
      config = function()
        require "custom.plugins.config.noice"
      end,
      requires = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
        }
    },
  
    ["folke/trouble.nvim"] = {
      config = function()
        require("trouble").setup()
      end,
      requires = {
        "kyazdani42/nvim-web-devicons"
      }
    },
  
    ["karb94/neoscroll.nvim"] = {
      opt = true,
      event = "BufReadPost",
      config = function()
        require "custom.plugins.config.neoscroll"
      end,
    },
  
    ["Pocco81/AutoSave.nvim"] = {
      module = "autosave",
      config = function()
          require("custom.plugins.config.autosave").autosave()
      end,
    },

    ["ray-x/go.nvim"] = {
      config = function()
          require "custom.plugins.config.go"
      end,
    },

    ["github/copilot.vim"] = {
      config = function()
          require "custom.plugins.config.copilot"
      end,
    },

    ["mfussenegger/nvim-dap"] = {},
    
    ["rcarriga/nvim-dap-ui"] = {},
    
    ["theHamsta/nvim-dap-virtual-text"] = {},

    ["ray-x/guihua.lua"] = {},

    ["p00f/nvim-ts-rainbow"] = {},

    ["tveskag/nvim-blame-line"] = {},

    -- Override
    ["goolord/alpha-nvim"] = {
      disable = false,
    },

    ["nvim-treesitter/nvim-treesitter"] = {
      override_options = {
        ensure_installed = {
          "lua", "go", "cpp", "c", "bash", "json", "json5", "gomod", "gowork", "yaml",
        },
      
        textobjects = {
          select = {
            enable = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]]"] = "@function.outer",
            },
            goto_previous_start = {
              ["[["] = "@function.outer",
            },
          },
        },        
        rainbow = {
          enable = true,
          extended_mode = true,
          max_file_lines = 1000,
        },
      },
    },

    ["williamboman/mason.nvim"] = {
      override_options = {
        ensure_installed = { "gopls", "goimports" }
      }
    },

    ["neovim/nvim-lspconfig"] = {
      config = function()
        require "custom.plugins.config.lspconfig"   
        -- Noice     
        vim.notify = require("noice").notify
        vim.lsp.handlers["textDocument/hover"] = require("noice").hover
        vim.lsp.handlers["textDocument/signatureHelp"] = require("noice").signature
      end,
    },
}