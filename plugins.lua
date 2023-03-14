local overrides = require("custom.configs.overrides")

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
    opts = overrides.treesitter,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },

  { "nvim-telescope/telescope.nvim",
    opts = overrides.telescope,
  },
  
  { "williamboman/mason.nvim",
    opts = overrides.mason,
  },

  {
    "anuvyklack/pretty-fold.nvim",
    config = function()
      require "custom.configs.pretty-fold"
    end,
  },

  {
    "m-demare/hlargs.nvim",
    config = function()
      require("hlargs").setup()
    end,
  },

  {
    "kevinhwang91/nvim-hlslens",
    config = function()
      require("hlslens").setup()
    end,
  },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({})
    end,
  },

  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "copilot.lua" },
    config = function ()
      require("copilot_cmp").setup()
    end
  },

  {
    "folke/which-key.nvim",
    enabled = true,
  },
  -- ------------------ OLD PLUGINS ------------------

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
    ft = { "html", "javascriptreact" },
    dependencies = "nvim-treesitter",
    config = true,
  },

  {
    "jelera/vim-javascript-syntax",
    dependencies = "nvim-treesitter",
    ft = { "javascript", "javascriptreact" },
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

  { 
    "dstein64/nvim-scrollview",
    lazy = true,
    event = { "BufReadPost" },
    config = function()
      require "custom.configs.scrollview"
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
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons"
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

  -- { "declancm/vim2vscode" }
  -- { "kizza/ask-vscode.nvim" }

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
  { "hrsh7th/cmp-emoji" },
	{ "hrsh7th/cmp-calc" },
  { "lvimuser/lsp-inlayhints.nvim",
    config = function()
      require("custom.configs.lsp-inlayhints")
    end,
  },
  { "ray-x/cmp-treesitter" },
  { "ray-x/go.nvim",
  lazy = true,
    dependencies = { "ray-x/guihua.lua" },
    ft = { "go", "gomod" },
    dependencies = "nvim-treesitter",
    config = function()
      require "custom.configs.go"
    end,
  },
  -- { "github/copilot.vim",
  --   config = function()
  --     require "custom.configs.copilot"
  --   end,
  -- },
  -- { "brenoprata10/nvim-highlight-colors",
  --   config = function()
  --     require("nvim-highlight-colors").setup()
  --   end,
  -- },
  { "VonHeikemen/searchbox.nvim",
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
  -- -- { "nvim-telescope/telescope-dap.nvim",
  { "theHamsta/nvim-dap-virtual-text" },
  { "ray-x/guihua.lua" },
  -- { 
  --   "avneesh0612/react-nextjs-snippets" 
  --   ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  -- },
  { 
    "p00f/nvim-ts-rainbow",
    event = "BufReadPost",
    dependencies = "nvim-treesitter",
  },
  { 
    "tveskag/nvim-blame-line",
    lazy = true,
    dependencies = "nvim-treesitter",
    event = "BufWinEnter",
  },
  { 
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = true,
  },
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
  -- -- { "williamboman/mason-lspconfig.nvim",
  -- --   requires = "neovim/nvim-lspconfig",
  -- --   requires = "williamboman/mason.nvim",
  -- --   config = function()
  -- --     require("mason-lspconfig").setup()
  -- --   end,
  -- -- },
  -- -- { "LeonHeidelbach/trailblazer.nvim",
  -- -- { "jackMort/ChatGPT.nvim",
  -- -- 	lazy = true,
  -- -- 	keys = { "<leader>gpt" },
  -- -- 	module_pattern = { "chatgpt*" },
  -- -- 	dependencies = { "nui.nvim", "telescope.nvim" },
  -- -- 	config = function()
  -- -- 		require("custom.plugins.gpt")
  -- -- 	end,
  -- -- 	dependencies = {
  -- -- 		"MunifTanjim/nui.nvim",
  -- -- 		"nvim-lua/plenary.nvim",
  -- -- 		"nvim-telescope/telescope.nvim",
  -- -- 	},
  -- -- },
  { "kosayoda/nvim-lightbulb",
    event = "BufWinEnter",
    dependencies = {
      "antoinemadec/FixCursorHold.nvim",
    },
  },
  { 
    "ludovicchabant/vim-gutentags",
    lazy = false,
  },
  -- { "weilbith/nvim-code-action-menu",
  --   cmd = "CodeActionMenu",
  -- },
  -- { "mg979/vim-visual-multi",
  --   lazy = true,
  --   event = "BufReadPost",
  --   setup = function()
  --     require "custom.configs.visual-multi"
  --   end,
  -- },
  { "nvim-treesitter/nvim-treesitter-textobjects",
    config = function()
      require("custom.configs.textobjects")
    end,
  },
  -- -- =============================================== LSP
  { "hrsh7th/cmp-nvim-lsp-signature-help" },
  { "hrsh7th/cmp-nvim-lsp-document-symbol" },
  { "hrsh7th/cmp-nvim-lsp" },
  -- { "jinzhongjia/LspUI.nvim",
  --   event = 'VimEnter',
  --   config=function()
  --     require "custom.configs.lspui"
  --   end
  -- },
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
      require("custom.configs.lspsaga")
    end,
    -- commit = "707c9399b1cbe063c6942604209674edf1b3cf2e",
  },
  -- { 
  --   "j-hui/fidget.nvim",
  --   event = "BufWinEnter",
  --   config = true,
  -- },
  { 
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufWinEnter",
    config = function()
      require("custom.configs.ts-context")
    end,
  },
  { 
    "melkster/modicator.nvim",
    event = "BufWinEnter",
    config = function()
      require("custom.configs.modicator")
    end,
  },
  -- { "MaximilianLloyd/ascii.nvim" },
  { "hrsh7th/nvim-cmp",
    opts = {
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

return plugins
