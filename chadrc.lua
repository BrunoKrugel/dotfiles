---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require "custom.highlights"

M.ui = {
  theme = "chadracula",
  theme_toggle = { "chadracula", "one_light" },
  statusline = {
    theme = "vscode_colored",
  },
  cmp = {
    icons = true,
    lspkind_text = true,
    style = "default", -- default/flat_light/flat_dark/atom/atom_colored
  },

  hl_override = highlights.override,
  hl_add = highlights.add,
  nvdash = {
    load_on_startup = true,
  --     header = {
  --     "   🭇🬭🬭🬭🬭🬭🬭🬭🬭🬼    ",
  --     "  🭉🭁🭠🭘    🭣🭕🭌🬾   ",
  --     " 🭅█ ▁     █🭐   ",
  --     " ██🬿      🭊██   ",
  --     " 🭋█🬝🮄🮄🮄🮄🮄🮄🮄🮄🬆█🭀  ",
  --     " 🭤🭒🬺🬹🬱🬭🬭🬭🬭🬵🬹🬹🭝🭙  ",
  -- },
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
  },
}

M.plugins = "custom.plugins"

-- check core.mappings for table structure
M.mappings = require "custom.mappings"

return M
