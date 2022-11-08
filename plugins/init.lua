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
          -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
          "MunifTanjim/nui.nvim",
          -- OPTIONAL:
          --   `nvim-notify` is only needed, if you want to use the notification view.
          --   If not available, we use `mini` as the fallback
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
           require("custom.plugins.configs.autosave").autosave()
        end,
      },

    -- Just work
    -- ["fatih/vim-go"] = {},
    ["ray-x/go.nvim"] = {
    config = function()
        require "custom.plugins.config.go"
    end,
    },

    ["mfussenegger/nvim-dap"] = {},
    
    ["rcarriga/nvim-dap-ui"] = {},
    
    ["theHamsta/nvim-dap-virtual-text"] = {},

    ["ray-x/guihua.lua"] = {},

    ["github/copilot.vim"] = {},

    ["p00f/nvim-ts-rainbow"] = {},

    ["tveskag/nvim-blame-line"] = {},
    
}