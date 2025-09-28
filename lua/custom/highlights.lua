local M = {}

M.override = {
  -- Cursor
  Cursor = { bg = "white", fg = "black2" },
  CursorLine = { bg = "black2" },
  Visual = { bg = "black2" },
  Comment = { italic = true },
  NvDashAscii = { fg = "purple", bg = "none" },
  IndentBlanklineContextChar = { fg = "none" },
  IndentBlanklineContextStart = { bg = "none" },

  LspInlayHint = { fg = "#4e5665", bg = "NONE" },

  TelescopePromptNormal = { blend = 100 },
  -- TreeSitter highlights
  Repeat = { fg = "pink" },
  Include = { fg = "pink" },

  ["@definition"] = { underline = false },
  ["@boolean"] = { fg = "green" },
  ["@comment"] = { link = "Comment" },
  ["@operator"] = { link = "Operator" },
  ["@constant"] = { link = "Constant" },
  ["@number.float"] = { link = "Float" },
  ["@modules"] = { fg = "white" },

  ["@attribute"] = { link = "Constant" },

  ["@keyword"] = { italic = true },

  ["@function.builtin"] = { fg = "cyan" },
  ["@function.method"] = { link = "Function" },
  ["@function.method.call"] = { link = "Function" },
  ["@function.call"] = { link = "Function" },

  ["@variable"] = { fg = "white" },

  ["@variable.parameter.go"] = { fg = "white" },
  ["@function.call.go"] = { fg = "green" },

  ["@variable.member"] = { fg = "white" },
  ["@constructor"] = { fg = "blue" },

  -- ["Function"] = { fg = "green" },
  -- ["@function"] = { fg = "green" },
  ["@property"] = { fg = "purple" },

  ["@keyword.import"] = { link = "Include" },
  ["@text.danger"] = { fg = "red" },
  ["@text.note"] = { fg = "blue" },
  ["@text.header"] = { bold = true },
  ["@text.diff.add"] = { fg = "green" },
  ["@text.diff.delete"] = { fg = "red" },
  ["@text.todo"] = { fg = "blue" },
  ["@string.special"] = { fg = "blue" },
  ["@class.css"] = { fg = "green" },

  ["@class.scss"] = { link = "@class.css" },
  ["@property.css"] = { fg = "teal" },
  ["@property.scss"] = { link = "@property.css" },

  -- Lsp
  ["@lsp.type.keyword"] = { link = "Keyword" },
  ["@lsp.type.operator"] = { link = "Operator" },
  ["@lsp.type.parameter"] = { link = "@variable.parameter" },
  ["@lsp.type.property"] = { link = "@property" },
  ["@lsp.typemod.method.reference"] = { link = "Function" },
  ["@lsp.typemod.method.trait"] = { link = "Function" },
  ["@lsp.typemod.selfKeyword.defaultLibrary"] = { link = "Keyword" },

  -- NvimTree
  NvimTreeGitNew = { fg = "green" },
  NvimTreeGitDirty = { fg = "yellow" },
  NvimTreeGitDeleted = { fg = "red" },
  NvimTreeCursorLine = { bg = "one_bg3" },
}

M.add = {

  DapStoppedLine = { link = "Visual" },
  DapBreakpoint = { fg = "red" },

  NvimDapVirtualTextError = { fg = "red", italic = true },
  NvimDapVirtualText = { fg = "cyan", italic = true },
  NvimDapVirtualTextChanged = { fg = "yellow", italic = true },

  ["@number.luadoc"] = { fg = "Comment" },
  ["@markup.quote.markdown"] = { bg = "NONE" },

  WinBar = { link = "Normal" },
  WinBarNC = { link = "Normal" },

  YankVisual = { fg = "black2", bg = "cyan" },

  MultiCursor = { bg = "white", fg = "black2" },
  MultiCursorMain = { bg = "white", fg = "black2" },

  LightBulbSign = { bg = "black", fg = "yellow" },

  NvimTreeOpenedFolderName = { fg = "purple", bold = true },
  NvimTreeOpenedFile = { fg = "green", bold = true },
  NvimTreeOpenedHL = { fg = "green", bold = true },
  NvimTreeFileIcon = { fg = "purple" },

  CoverageCovered = { fg = "green" },
  CoverageUncovered = { fg = "red" },

  BlinkPairsOrange = { fg = "orange" },
  BlinkPairsPurple = { fg = "purple" },
  BlinkPairsBlue = { fg = "blue" },
  BlinkPairsRed = { fg = "red" },
  BlinkPairsYellow = { fg = "yellow" },
  BlinkPairsGreen = { fg = "green" },
  BlinkPairsCyan = { fg = "cyan" },
  BlinkPairsViolet = { fg = "violet" },

  BlinkPairsUnmatched = { fg = "red" },
  BlinkPairsMatchParen = { fg = "cyan" },

  CopilotSuggestion = { fg = "#83a598" },
  CopilotAnnotation = { fg = "#03a598" },

  -- Cmp Highlights
  CmpItemKindCodeium = { fg = "green" },
  CmpItemKindTabNine = { fg = "pink" },
  CmpItemKindSupermaven = { fg = "cyan" },

  PackageInfoOutdatedVersion = { fg = "red" },
  PackageInfoUpToDateVersion = { fg = "green" },

  VirtColumn = { fg = "black2" },
  FoldColumn = { bg = "black", fg = "white" },
  Folded = { bg = "black", fg = "white" },

  -- SpectreHeader
  -- SpectreBody
  -- SpectreFile
  -- SpectreDir
  -- SpectreSearch = { fg = "green" },
  -- SpectreBorder
  -- SpectreReplace

  ObsidianTodo = { fg = "red" },
  ObsidianDone = { fg = "green" },
  ObsidianRightArrow = { fg = "cyan" },
  ObsidianTilde = { fg = "cyan" },
  ObsidianBullet = { fg = "yellow" },
  ObsidianExtLinkIcon = { fg = "purple" },
  ObsidianRefText = { fg = "pink" },
  ObsidianHighlightText = { fg = "cyan" },
  ObsidianTag = { fg = "cyan" },

  -- Tree Sitter Rainbow
  RainbowDelimiterRed = { fg = "red" },
  RainbowDelimiterYellow = { fg = "yellow" },
  RainbowDelimiterBlue = { fg = "blue" },
  RainbowDelimiterOrange = { fg = "orange" },
  RainbowDelimiterGreen = { fg = "green" },
  RainbowDelimiterViolet = { fg = "purple" },
  RainbowDelimiterCyan = { fg = "cyan" },

  -- Diff
  DiffChange = { fg = "yellow" },
  DiffAdd = { fg = "vibrant_green" },
  DiffText = { fg = "white", bg = "red", bold = true },

  DiffviewDim1 = { fg = "grey" },
  DiffviewReference = { fg = "cyan" },
  DiffviewPrimary = { fg = "cyan" },
  DiffviewSecondary = { fg = "blue" },
  DiffviewNonText = { link = "DiffviewDim1" },
  DiffviewStatusUnmerged = { link = "GitMerge" },
  DiffviewStatusUntracked = { link = "GitNew" },
  DiffviewStatusModified = { link = "GitDirty" },
  DiffviewStatusRenamed = { link = "GitRenamed" },
  DiffviewStatusDeleted = { link = "GitDeleted" },
  DiffviewStatusAdded = { link = "GitStaged" },
  DiffviewFilePanelRootPath = { link = "NvimTreeRootFolder" },
  DiffviewFilePanelTitle = { link = "Title" },
  DiffviewFilePanelCounter = { fg = "cyan" },
  DiffviewFilePanelInsertions = { link = "GitNew" },
  DiffviewFilePanelDeletions = { link = "GitDeleted" },
  DiffviewFilePanelConflicts = { link = "GitMerge" },
  DiffviewFolderSign = { link = "NvimTreeFolderIcon" },
  DiffviewDiffDelete = { link = "Comment" },

  GitSignsChange = { fg = "green" },
  GitSignsAdd = { fg = "vibrant_green" },
  GitSignsDelete = { fg = "red" },
  GitSignsText = { fg = "white", bg = "red", bold = true },

  -- Deprecated
  cssDeprecated = { strikethrough = true },
  javaScriptDeprecated = { strikethrough = true },

  -- LSP Saga
  SagaBorder = { fg = "blue" },
  SagaFolder = { fg = "cyan" },
  HoverNormal = { fg = "white" },
  CodeActionText = { fg = "white" },
  CodeActionNumber = { link = "Number" },

  SplitHl = { fg = "white", bg = "black2" },

  -- SnacksIndent
  SnacksIndentScope = { link = "NonText" },

  DiagnosticUnnecessary = { link = "", fg = "light_grey" },
  LspInlayHint = { link = "", fg = "light_grey" },

  -- Noice
  NoiceCursor = { link = "Cursor" },
  NoiceCmdlinePopupBorder = { fg = "cyan" },
  NoiceCmdlinePopupBorderSearch = { fg = "yellow" },
  NoiceCmdlinePopup = { fg = "cyan" },
  NoiceConfirm = { fg = "cyan" },
  NoiceConfirmBorder = { fg = "cyan" },
  NoicePopup = { fg = "cyan" },
  NoicePopupBorder = { fg = "cyan" },
  NoicePopupmenu = { fg = "cyan" },

  -- Snacks
  SnacksNormal = { link = "NormalFloat" },
  SnacksWinBar = { link = "Title" },
  SnacksNormalNC = { link = "NormalFloat" },
  SnacksWinBarNC = { link = "SnacksWinBar" },

  SnacksNotifierInfo = { fg = "blue" },
  SnacksNotifierIconInfo = { fg = "blue" },
  SnacksNotifierTitleInfo = { fg = "blue", italic = true },
  SnacksNotifierFooterInfo = { link = "DiagnosticInfo" },
  SnacksNotifierBorderInfo = { fg = "blue" },
  SnacksNotifierWarn = { fg = "yellow" },
  SnacksNotifierIconWarn = { fg = "yellow" },
  SnacksNotifierTitleWarn = { fg = "yellow", italic = true },
  SnacksNotifierBorderWarn = { fg = "yellow" },
  SnacksNotifierFooterWarn = { link = "DiagnosticWarn" },
  SnacksNotifierDebug = { fg = "peach" },
  SnacksNotifierIconDebug = { fg = "peach" },
  SnacksNotifierTitleDebug = { fg = "peach", italic = true },
  SnacksNotifierBorderDebug = { fg = "peach" },
  SnacksNotifierFooterDebug = { link = "DiagnosticHint" },
  SnacksNotifierError = { fg = "red" },
  SnacksNotifierIconError = { fg = "red" },
  SnacksNotifierTitleError = { fg = "red", italic = true },
  SnacksNotifierBorderError = { fg = "red" },
  SnacksNotifierFooterError = { link = "DiagnosticError" },
  SnacksNotifierTrace = { fg = "rosewater" },
  SnacksNotifierIconTrace = { fg = "rosewater" },
  SnacksNotifierTitleTrace = { fg = "rosewater", italic = true },
  SnacksNotifierBorderTrace = { fg = "rosewater" },
  SnacksNotifierFooterTrace = { link = "DiagnosticHint" },

  SnacksDashboardNormal = { link = "Normal" },
  SnacksDashboardDesc = { fg = "blue" },
  SnacksDashboardFile = { fg = "lavender" },
  SnacksDashboardDir = { link = "NonText" },
  SnacksDashboardFooter = { fg = "yellow", italic = true },
  SnacksDashboardHeader = { fg = "blue" },
  SnacksDashboardIcon = { fg = "pink", bold = true },
  SnacksDashboardKey = { fg = "peach" },
  SnacksDashboardTerminal = { link = "SnacksDashboardNormal" },
  SnacksDashboardSpecial = { link = "Special" },
  SnacksDashboardTitle = { link = "Title" },
}

return M
