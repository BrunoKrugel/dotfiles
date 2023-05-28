local M = {}

---@type Base46HLGroupsList
M.override = {
  CursorLine = {
    bg = "black2",
  },
  Comment = {
    italic = true,
  },
  Include = {
    fg = "pink",
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

  Cursor = {bg = "#FFFFFF"},
  --["@attribute"] = {
  --   italic = true,
  -- },
}

---@type HLTable
M.add = {
  NvimTreeOpenedFolderName = { fg = "purple", bold = true },
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

  TSRainbowRed = { fg = "red" },
  TSRainbowYellow = { fg = "yellow" },
  TSRainbowBlue = { fg = "blue" },
  TSRainbowOrange = { fg = "orange" },
  TSRainbowGreen = { fg = "green" },
  TSRainbowViolet = { fg = "purple" },
  TSRainbowCyan = { fg = "cyan" },
  HlSearchNear = { fg = "#2E3440", bg = "#EBCB8B" },
  HlSearchLens = { fg = "#2E3440", bg = "#88bfcf" },
  HlSearchLensNear = { fg = "#2E3440", bg = "#EBCB8B" },
}

return M
