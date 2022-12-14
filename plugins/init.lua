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
  
    ["Pocco81/auto-save.nvim"] = {
      config = function()
        require("auto-save").setup()
      end,
    },

    ["ray-x/go.nvim"] = {
      config = function()
          require "custom.plugins.config.go"
      end,
    },

    ["fatih/vim-go"] = {},

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
    ["goolord/alpha-nvim"] = { disable = false },

    ["folke/which-key.nvim"] = { disable = false },

    ["kyazdani42/nvim-tree.lua"] = {
      override_options = {
        filters = {
          dotfiles = true,
          custom = { "node_modules" },
        },
        git = {
          enable = true,
        },       
        renderer = {
          highlight_git = true,
          icons = {
            show = {
              git = true,
            },
          },
        },      
      }
    },

    ["nvim-treesitter/nvim-treesitter"] = {
      override_options = {
        ensure_installed = {
          "lua", "go", "cpp", "c", "bash", "json", "json5", "gomod", "gowork", "yaml",
        },
        textobjects = {
          -- syntax-aware textobjects
          enable = true,
          lsp_interop = {
            enable = enable,
            peek_definition_code = {
              ["DF"] = "@function.outer",
              ["DF"] = "@class.outer"
            }
          },          
          select = {
            enable = true,
            keymaps = {
              ["gff>"] = {
                go = "(function_definition) @function",
              },
              ["gdf"] = {
                go = "(method_declaration) @function"
              },           
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

    ["hrsh7th/nvim-cmp"] = {
      override_options = {
        formatting = {
          format = function(entry, vim_item)
            if entry.source.name == 'copilot' then
              vim_item.kind = string.format("%s %s", '???', 'Github')
            else
              local icons = require("nvchad_ui.icons").lspkind
              vim_item.kind = string.format("%s %s", icons[vim_item.kind], vim_item.kind)
            end
    
            return vim_item
          end,
        },            
        sources = {
          { name = "go" },
          { name = "luasnip" },
          { name = "copilot" },
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "nvim_lua" },
          { name = "path" },
        },
      },
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