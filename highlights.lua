local M = {}

---@type Base46HLGroupsList
M.override = {
  -- Cursor
  Cursor = { bg = "white" },
  CursorLine = { bg = "black2" },
  Comment = { italic = true },
  NvDashAscii = { fg = "none", bg = "none" },
  IndentBlanklineContextStart = { bg = "none" },
  -- TreeSitter highlights
  Repeat = { fg = "pink" },
  Include = { fg = "pink" },
  ["@definition"] = { underline = false },
  ["@variable"] = { fg = "purple" },
  ["@namespace"] = { fg = "white" },
  ["@function.builtin"] = { fg = "cyan" },
  ["@function.call"] = { fg = "green" },
  -- Copilot
  CopilotSuggestion = { fg = "#83a598" },
  CopilotAnnotation = { fg = "#03a598" },
  -- NvimTree
  NvimTreeGitNew = { fg = "green" },
  NvimTreeGitDirty = { fg = "yellow" },
  NvimTreeGitDeleted = { fg = "red" },
  NvimTreeCursorLine = { bg = "one_bg3" },
  -- GitSigns
  DiffChange = { fg = "yellow" },
  DiffAdd = { fg = "vibrant_green" },
  DiffText = { fg = "white", bg = "red", bold = true },
}

---@type HLTable
M.add = {
  MultiCursor = { bg = "white" },
  MultiCursorMain = { bg = "white" },

  NvimTreeOpenedFolderName = { fg = "purple", bold = true },
  NvimTreeOpenedFile = { fg = "green", bold = true },
  SagaWinbarFolder = { fg = "blue" },
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
  FoldColumn = { bg = "black" },
  Folded = { bg = "black", fg = "white" },
  -- Tree Sitter Rainbow
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
  TermHl = { fg = "vibrant_green", bg = "statusline_bg" },

  GitSignsCurrentLineBlame = {
    fg = "cyan",
  },
  -- LSP Saga
  SagaBorder = { fg = "blue" },
  HoverNormal = { fg = "white" },
  CodeActionText = { fg = "white" },
  CodeActionNumber = { link = "Number" },
}

return M
