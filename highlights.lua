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
  ["@namespace"] = { fg = "white" },
  Repeat = { fg = "pink" },
  ["@function.builtin"] = { fg = "cyan" },
  ["@function.call"] = { fg = "green" },
  CopilotSuggestion = {
    fg = "#83a598",
  },
  CopilotAnnotation = {
    fg = "#03a598",
  },
  Cursor = { bg = "#FFFFFF" },
}

---@type HLTable
M.add = {
  NvimTreeOpenedFolderName = { fg = "purple", bold = true },
  SagaWinbarFolder = {
    fg = "blue",
  },
  -- Cmp Highlights
  CmpItemKindCodeium = { fg = "#51BDAC" },
  CmpItemKindTabNine = { fg = "#C73BE3" },
  -- EndOfBuffer = {
  --   bg = "black",
  --   fg = "black",
  -- },
  -- NonText = {
  --   bg = "black",
  --   fg = "black",
  -- },
  VirtColumn = { fg = "black2" },
  FoldColumn = {
    bg = "black",
  },
  Folded = {
    bg = "black",
    fg = "white",
  },
  -- Tree Sitter
  RainbowDelimiterRed = { fg = "red" },
  RainbowDelimiterYellow = { fg = "yellow" },
  RainbowDelimiterBlue = { fg = "blue" },
  RainbowDelimiterOrange = { fg = "orange" },
  RainbowDelimiterGreen = { fg = "green" },
  RainbowDelimiterViolet = { fg = "purple" },
  RainbowDelimiterCyan = { fg = "cyan" },
  -- Search highlights
  HlSearchNear = { fg = "#2E3440", bg = "#EBCB8B" },
  HlSearchLens = { fg = "#2E3440", bg = "#88bfcf" },
  HlSearchLensNear = { fg = "#2E3440", bg = "#EBCB8B" },
  -- Custom highlights
  CopilotHl = { fg = "green", bg = "statusline_bg" },
  HarpoonHl = { fg = "cyan", bg = "statusline_bg" },
  BatteryHl = { fg = "nord_blue", bg = "statusline_bg" },
  SessionHl = { fg = "#e535ab", bg = "statusline_bg" },
  NotificationHl = { fg = "white", bg = "statusline_bg" },
  GitSignsCurrentLineBlame = {
    fg = "cyan",
  },
}

return M
