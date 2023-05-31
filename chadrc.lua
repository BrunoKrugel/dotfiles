---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require "custom.highlights"

M.ui = {
  theme = "chadracula",
  theme_toggle = { "chadracula", "one_light" },

  statusline = {
    theme = "vscode_colored",
    overriden_modules = function()
      local st_modules = require "nvchad_ui.statusline.vscode_colored"
      -- Load info for harpoon
      local function get_marked()
        local Marked = require "harpoon.mark"
        local filename = vim.api.nvim_buf_get_name(0)
        local success, index = pcall(Marked.get_index_of, filename)
        if success and index and index ~= nil then
          return "󱡀 " .. index .. " "
        else
          return ""
        end
      end
      -- Load info for possession
      local function get_session()
        local session = require("nvim-possession").status()
        if session ~= nil then
          return "󰐃 "
        else
          return "󰐄 "
        end
      end

      local function get_npm()
        local npm = require("package-info").get_status()
        if npm ~= nil then
          return npm
        else
          return ""
        end
      end
      return {
        LSP_Diagnostics = function()
          return "%#CopilotHl#"
            .. require("copilot_status").status_string()
            .. " "
            .. "%#HarpoonHl#"
            .. get_marked()
            .. "%#BatteryHl#"
            .. require("battery").get_status_line()
            .. " "
            .. "%#SessionHl#"
            .. get_session()
            .. " "
            -- .. "%#NpmHl#"
            -- .. get_npm()
            -- .. " "
            .. st_modules.LSP_Diagnostics()
        end,

        LSP_progress = function()
          return st_modules.LSP_progress() .. " " .. "%#NpmHl#" .. get_npm()
        end,
      }
    end,
  },

  cmp = {
    icons = true,
    lspkind_text = true,
    style = "flat_dark", -- default/flat_light/flat_dark/atom/atom_colored
  },

  lsp = {
    signature = {
      disabled = false,
      silent = true,
    },
  },

  hl_override = highlights.override,
  hl_add = highlights.add,

  nvdash = {
    load_on_startup = true,
    header = {
      [[                                           ,o88888 ]],
      [[                                        ,o8888888' ]],
      [[                  ,:o:o:oooo.        ,8O88Pd8888"  ]],
      [[              ,.::.::o:ooooOoOoO. ,oO8O8Pd888'"    ]],
      [[            ,.:.::o:ooOoOoOO8O8OOo.8OOPd8O8O"      ]],
      [[           , ..:.::o:ooOoOOOO8OOOOo.FdO8O8"        ]],
      [[          , ..:.::o:ooOoOO8O888O8O,COCOO"          ]],
      [[         , . ..:.::o:ooOoOOOO8OOOOCOCO"            ]],
      [[          . ..:.::o:ooOoOoOO8O8OCCCC"o             ]],
      [[             . ..:.::o:ooooOoCoCCC"o:o             ]],
      [[             . ..:.::o:o:,cooooCo"oo:o:            ]],
      [[          `   . . ..:.:cocoooo"'o:o:::'            ]],
      [[          .`   . ..::ccccoc"'o:o:o:::'             ]],
      [[         :.:.    ,c:cccc"':.:.:.:.:.'              ]],
      [[       ..:.:"'`::::c:"'..:.:.:.:.:.'               ]],
      [[     ...:.'.:.::::"'    . . . . .'                 ]],
      [[    .. . ....:."' `   .  . . ''                    ]],
      [[  . . . ...."'                                     ]],
      [[  .. . ."'                                         ]],
      [[ . . .''                                           ]],
      [[ ..''                                              ]],
      [[                                                  ]],
    },
    buttons = {
      { "󰈭  Global Search", "Spc f w", "Telescope live_grep" },
      { "  Find File", "Spc f f", "Telescope find_files" },
      { "󰈚  Recent Files", "Spc f r", "Telescope oldfiles" },
      {"󰔫 Diagnostics", "Spc t  ", "TroubleToggle"},
      { "  Bookmarks", "Spc b a", "Telescope marks" },
      { "  Themes", "Spc t h", "Telescope themes" },
      { "  Mappings", "Spc c h", "NvCheatsheet" },
    },
  },
}

M.plugins = "custom.plugins"

-- check core.mappings for table structure
M.mappings = require "custom.mappings"

return M
