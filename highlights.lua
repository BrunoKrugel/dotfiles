-- To find any highlight groups: "<cmd> Telescope highlights"
-- Each highlight group can take a table with variables fg, bg, bold, italic, etc
-- base30 variable names can also be used as colors

local M = {}

---@type HLTable
M.override = {
  CursorLine = {
    bg = "black2",
  },
  Comment = {
    italic = true,
  },
  NvDashAscii = {
    fg = "none",
    bg = "none",
  },
  DiffAdd = { fg = "green" },
  IndentBlanklineContextStart = {
    bg = "none",
  },
  ["@definition"] = {
    underline = false,
  },
  ["@variable"] = { fg = "purple" },
  CopilotSuggestion = {
    fg = "#83a598",
  },
  CopilotAnnotation = {
    fg = "#03a598",
  },

  --["@attribute"] = {
  --   italic = true,
  -- },
}

---@type HLTable
M.add = {
  NvimTreeOpenedFolderName = { fg = "green", bold = true },
  CopilotHl = { fg = "green", bg = "statusline_bg" },
  HarpoonHl = { fg = "cyan", bg = "statusline_bg" },
  BatteryHl = { fg = "nord_blue", bg = "statusline_bg" },
  SessionHl = { fg = "#e535ab", bg = "statusline_bg" },
  CmpItemKindCodeium = { fg = "#51BDAC" },
  CmpItemKindTabNine = { fg = "#C73BE3" },
  EndOfBuffer = {
    bg = "black",
    fg = "black",
  },
  NonText = {
    bg = "black",
    fg = "black",
  },
  FoldColumn = {
    bg = "black",
  },
}

return M
