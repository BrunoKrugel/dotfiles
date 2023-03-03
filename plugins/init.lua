local overrides = require("custom.plugins.config.overrides")

return {
  ["jose-elias-alvarez/null-ls.nvim"] = {
    after = "nvim-lspconfig",
    config = function()
      require "custom.plugins.config.null-ls"
    end,
  },
  ["rmagatti/goto-preview"] = {
    config = function()
      require("goto-preview").setup({
        border = "rounded",
        default_mappings = true,
      })
    end,
  },
--  ["dmitmel/cmp-vim-lsp"] = {},
  ["abecodes/tabout.nvim"] = {
    opt = true,
    event = "InsertEnter",
    wants = "nvim-treesitter",
    after = "nvim-cmp",
    config = function()
      require "custom.plugins.config.tabout"
    end,
  },
  ["windwp/nvim-ts-autotag"] = {
    ft = { "html", "javascriptreact" },
    after = "nvim-treesitter",
    config = function()
      local present, autotag = pcall(require, "nvim-ts-autotag")

      if present then
        autotag.setup()
      end
    end,
  },
  ['jelera/vim-javascript-syntax'] = {
    after = "nvim-treesitter",
    ft = { "javascript", "javascriptreact" },
  },
  ["phaazon/hop.nvim"] = {
    opt = true,
    after = "ui",
    event = "BufReadPost",
    branch = "v2",
    config = function()
      require "custom.plugins.config.hop"
    end,
  },
  ["rainbowhxch/accelerated-jk.nvim"] = {
    opt = true,
    after = "nvim-treesitter",
    event = "BufWinEnter",
    config = function()
      require "custom.plugins.config.accelerated-jk"
    end,
  },
  ["RRethy/vim-illuminate"] = {
    opt = true,
    event = "BufReadPost",
    after = "nvim-treesitter",
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
      require "custom.plugins.config.trouble"
    end,
    requires = {
      "nvim-tree/nvim-web-devicons"
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
    event = "BufReadPost",
    -- config = function()
    --   require("auto-save").setup()
    -- end,
    config = function()
      require "custom.plugins.config.autosave"
    end,    
  },
	["tzachar/cmp-tabnine"] = {
		run = "./install.sh",
		requires = "hrsh7th/nvim-cmp",
		config = function()
			local tabnine = require("cmp_tabnine.config")

			tabnine:setup({
				max_lines = 1000,
				max_num_results = 20,
				sort = true,
				run_on_every_keystroke = true,
				snippet_placeholder = "..",
				ignored_file_types = {
					-- default is not to ignore
					-- uncomment to ignore in lua:
					-- lua = true
				},
				show_prediction_strength = false,
			})
		end,
	},
  ["hrsh7th/cmp-emoji"] = {},
	["hrsh7th/cmp-calc"] = {},
  -- ["barrett-ruth/import-cost.nvim"] = {
	-- 	build = "sh install.sh npm",
	-- 	config = function()
	-- 		require("custom.plugins.config.import-cost")
	-- 	end,
	-- },
  ["lvimuser/lsp-inlayhints.nvim"] = {
    config = function()
      require("custom.plugins.config.lsp-inlayhints")
    end,
  },
  ["ray-x/cmp-treesitter"] = {},
  ["ray-x/go.nvim"] = {
    ft = { "go", "gomod" },
    after = "nvim-treesitter",
    config = function()
      require "custom.plugins.config.go"
    end,
  },
  -- ["fatih/vim-go"] = {
  --   ft = { "go", "gomod" },
  --   after = "nvim-treesitter",
  -- },
  ["github/copilot.vim"] = {
    config = function()
      require "custom.plugins.config.copilot"
    end,
  },
  ["brenoprata10/nvim-highlight-colors"] = {
    config = function()
      require("nvim-highlight-colors").setup()
    end,
  },
  -- ["utilyre/barbecue.nvim"] = {
  --   requires = {
  --     "SmiteshP/nvim-navic",
  --     "nvim-tree/nvim-web-devicons", -- optional dependency
  --   },
  --   after = "nvim-web-devicons", -- keep this if you're using NvChad
  --   config = function()
  --     require("barbecue").setup()
  --   end,
  -- },
  ["VonHeikemen/searchbox.nvim"] = {
    requires = {
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require "custom.plugins.config.searchbox"
    end,
  },
  -- ["zbirenbaum/copilot-cmp"] = {
  --   after = "copilot.vim",
  --   config = function ()
  --     require("copilot_cmp").setup()
  --   end
  -- },

  ["mfussenegger/nvim-dap"] = {},
  ["rcarriga/nvim-dap-ui"] = {},
  ["theHamsta/nvim-dap-virtual-text"] = {},
  -- ["ray-x/guihua.lua"] = {},
  ["avneesh0612/react-nextjs-snippets"] = {},
  ["p00f/nvim-ts-rainbow"] = {
    after = "nvim-treesitter",
  },
  ["tveskag/nvim-blame-line"] = {
    opt = true,
    after = "nvim-treesitter",
    event = "BufWinEnter",
  },
  ["folke/todo-comments.nvim"] = {
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup()
    end,
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
  -- ["jackMort/ChatGPT.nvim"] = {
  -- 	opt = true,
  -- 	keys = { "<leader>gpt" },
  -- 	module_pattern = { "chatgpt*" },
  -- 	after = { "nui.nvim", "telescope.nvim" },
  -- 	config = function()
  -- 		require("custom.plugins.gpt")
  -- 	end,
  -- 	requires = {
  -- 		"MunifTanjim/nui.nvim",
  -- 		"nvim-lua/plenary.nvim",
  -- 		"nvim-telescope/telescope.nvim",
  -- 	},
  -- },
  ["kosayoda/nvim-lightbulb"] = {
    requires = {
      "antoinemadec/FixCursorHold.nvim",
    },
  },
  -- ["kevinhwang91/nvim-ufo"] = {
  -- 	requires = "kevinhwang91/promise-async",
  -- 	config = function()
  -- 		require("custom.plugins.config.ufo")
  -- 	end,
  -- },
  ["ludovicchabant/vim-gutentags"] = {},
  ["weilbith/nvim-code-action-menu"] = {
    cmd = "CodeActionMenu",
  },
  ["mg979/vim-visual-multi"] = {
    opt = true,
    event = "BufReadPost",
    setup = function()
      require "custom.plugins.config.visual-multi"
    end,
  },
  ["nvim-treesitter/nvim-treesitter-textobjects"] = {
    config = function()
      require("custom.plugins.config.textobjects")
    end,
  },
  -- =============================================== LSP
  ["hrsh7th/cmp-nvim-lsp-signature-help"] = {},
  ["hrsh7th/cmp-nvim-lsp-document-symbol"] = {},
  ["hrsh7th/cmp-nvim-lsp"] = {},
  -- ["jinzhongjia/LspUI.nvim"] = {
  --   event = 'VimEnter',
  --   config=function()
  --     require "custom.plugins.config.lspui"
  --   end
  -- },
  ["onsails/lspkind.nvim"] = {
    config = function()
      require "custom.plugins.config.lspkind"
    end,
  },
  ["glepnir/lspsaga.nvim"] = {
    config = function()
      require("custom.plugins.config.lspsaga")
    end,
    commit = "707c9399b1cbe063c6942604209674edf1b3cf2e",
  },
  ["j-hui/fidget.nvim"] = {
    config = function()
      require("fidget").setup()
    end,
  },
  ["nvim-treesitter/nvim-treesitter-context"] = {
    config = function()
      require("treesitter-context").setup({
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        throttle = true, -- Throttles plugin updates (may improve performance)
        max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
        patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
          -- For all filetypes
          -- Note that setting an entry here replaces all other patterns for this entry.
          -- By setting the 'default' entry below, you can control which nodes you want to
          -- appear in the context window.
          default = {
            "class",
            "function",
            "method",
          },
        },
      })
    end,
  },
  ["melkster/modicator.nvim"] = {
    config = function()
      require("custom.plugins.config.modicator")
    end,
  },
  ["anuvyklack/pretty-fold.nvim"] = {
    config = function()
      require("pretty-fold").setup({
        keep_indentation = false,
        fill_char = "━",
        sections = {
          left = {
            "━ ",
            function()
              return string.rep("*", vim.v.foldlevel)
            end,
            " ━┫",
            "content",
            "┣",
          },
          right = {
            "┫ ",
            "number_of_folded_lines",
            ": ",
            "percentage",
            " ┣━━",
          },
        },
      })
    end,
  },
  ["m-demare/hlargs.nvim"] = {
    config = function()
      require("hlargs").setup({})
    end,
  },
  ["kevinhwang91/nvim-hlslens"] = {
    config = function()
      require("hlslens").setup()
    end,
  },
  ["hrsh7th/vim-eft"] = {
    opt = true,
    event = "BufReadPost",
  },
  ["zbirenbaum/copilot.lua"] = {
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({})
    end,
  },
  ["zbirenbaum/copilot-cmp"] = {
    after = { "copilot.lua" },
    config = function ()
      require("copilot_cmp").setup()
    end
  },
  ["MaximilianLloyd/ascii.nvim"] = {},
  -- =============================================== Override options
  ["folke/which-key.nvim"] = { disable = false },
  ["goolord/alpha-nvim"] = {
    disable = false,
    override_options = overrides.alpha,
  },
  ["nvim-telescope/telescope.nvim"] = {
    override_options = overrides.telescope,
  },
  ["nvim-tree/nvim-tree.lua"] = {
    override_options = overrides.nvimtree,
  },
  ["nvim-treesitter/nvim-treesitter"] = {
    override_options = overrides.treesitter,
  },
  ["williamboman/mason.nvim"] = {
    override_options = overrides.mason,
  },
  ["hrsh7th/nvim-cmp"] = {
    override_options = {
      formatting = {
        format = function(entry, vim_item)
          if entry.source.name == 'copilot' then
            vim_item.kind = string.format("%s %s", '', 'Github')
          else
            local icons = require("nvchad_ui.icons").lspkind
            vim_item.kind = string.format("%s %s", icons[vim_item.kind], vim_item.kind)
          end

          local lspkind_icons = {
            Text = '',
            Method = '',
            Function = '',
            Constructor = ' ',
            Field = '',
            Variable = '',
            Class = '',
            Interface = '',
            Module = '硫',
            Property = '',
            Unit = ' ',
            Value = '',
            Enum = ' ',
            Keyword = 'ﱃ',
            Snippet = ' ',
            Color = ' ',
            File = ' ',
            Folder = ' ',
            EnumMember = ' ',
            Constant = ' ',
            Struct = ' ',
            Event = '',
            Operator = '',
            TypeParameter = ' ',
            Copilot = ' ',
          }
          return vim_item
        end,
      },
      sources = {
        { name = "copilot" },
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "treesitter" },
        { name = "emoji" },
        { name = "calc" },
        { name = "path" },
        { name = 'vim_lsp' },
        { name = 'nvim_lsp_document_symbol' },
        { name = 'nvim_lsp_signature_help' },
        { name = "copilot" },
      },
    },
  },
}
