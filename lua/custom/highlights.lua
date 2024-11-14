local M = {}

M.override = {
  -- Cursor
  Cursor = { bg = "white", fg = "black2" },
  CursorLine = { bg = "black2" },
  Visual = { bg = "black2" },
  Comment = { italic = true },
  NvDashAscii = { fg = "purple", bg = "none" },
  IndentBlanklineContextStart = { bg = "none" },

  LspInlayHint = { fg = "#4e5665", bg = "NONE" },
  FloatBorder = { link = "TelescopeBorder" },

  CmpDoc = { bg = "black" },
  CmpDocBorder = { fg = "black", bg = "black" },

  -- DiagnosticError = { bg = "#4B252C", fg = "#FF6363" },
  -- DiagnosticWarn =  { bg = "#403733", fg = "#FA973A" },
  -- DiagnosticInfo = { bg = "#20355A", fg = "#387EFF" },
  -- DiagnosticHint = { bg = "#254435", fg = "#16C53B" },

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
  -- ["@variable.go"] = { fg = "green" },
  -- ["@variable"] = { fg = "white" },
  ["@attribute"] = { link = "Constant" },

  ["@keyword"] = { italic = true },

  ["@function.builtin"] = { fg = "cyan" },
  ["@function.method"] = { link = "Function" },
  ["@function.method.call"] = { link = "Function" },
  ["@function.call"] = { link = "Function" },

  ["@variable"] = { fg = "white" },
  ["@function.call.go"] = { fg = "green" },
  ["@variable.member"] = { fg = "white" },
  ["@constructor"] = { fg = "green" },

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

  -- Copilot
  CopilotSuggestion = { fg = "#83a598" },
  CopilotAnnotation = { fg = "#03a598" },

  -- NvimTree
  NvimTreeGitNew = { fg = "green" },
  NvimTreeGitDirty = { fg = "yellow" },
  NvimTreeGitDeleted = { fg = "red" },
  NvimTreeCursorLine = { bg = "one_bg3" },
}

M.add = {

  DapStoppedLine = { link = "Visual" },

  -- LazyDimmed = { fg = colors.grey },

  CodeActionSignHl = { fg = "#f9e2af" },

  ["@number.luadoc"] = { fg = "Comment" },
  ["@markup.quote.markdown"] = { bg = "NONE" },

  EdgyWinBar = { bg = "black", fg = "white" },
  EdgyWinBarInactive = { bg = "black", fg = "white" },
  EdgyNormal = { bg = "black", fg = "white" },

  WinBar = { link = "Normal" },
  WinBarNC = { link = "Normal" },

  YankVisual = { fg = "black2", bg = "cyan" },

  MultiCursor = { bg = "white", fg = "black2" },
  MultiCursorMain = { bg = "white", fg = "black2" },

  DapBreakpoint = { fg = "red" },
  NvimDapVirtualText = { fg = "#6272A4" },

  LightBulbSign = { bg = "black", fg = "yellow" },

  NvimTreeOpenedFolderName = { fg = "purple", bold = true },
  NvimTreeOpenedFile = { fg = "green", bold = true },
  NvimTreeFileIcon = { fg = "purple" },

  CoverageCovered = { fg = "green" },
  CoverageUncovered = { fg = "red" },

  -- Cmp Highlights
  CmpItemKindCodeium = { fg = "green" },
  CmpItemKindTabNine = { fg = "pink" },
  CmpItemKindCopilot = { fg = "cyan" },

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

  -- Search highlights
  HlSearchNear = { fg = "#2E3440", bg = "yellow" },
  HlSearchLens = { fg = "#2E3440", bg = "blue" },
  HlSearchLensNear = { fg = "#2E3440", bg = "yellow" },

  -- LSP Saga
  SagaBorder = { fg = "blue" },
  SagaFolder = { fg = "cyan" },
  HoverNormal = { fg = "white" },
  CodeActionText = { fg = "white" },
  CodeActionNumber = { link = "Number" },

  -- Custom highlights
  CopilotHl = { fg = "white", bg = "statusline_bg" },
  RecordHl = { fg = "red", bg = "statusline_bg" },
  CmpHl = { fg = "red", bg = "statusline_bg" },
  NotificationHl = { fg = "white", bg = "statusline_bg" },
  TermHl = { fg = "green", bg = "statusline_bg" },
  SplitHl = { fg = "white", bg = "black2" },
  HarpoonHl = { fg = "white", bg = "black2" },

  -- Blankline
  IndentBlanklineContextChar = { fg = "none" },
  IndentBlanklineContextStart = { bg = "none" },

  DiagnosticUnnecessary = { link = "", fg = "light_grey" },
  LspInlayHint = { link = "", fg = "light_grey" },

  GrugFarResultsMatch = { link = "DiffChange" },
  GrugFarResultsMatchAdded = { link = "DiffAdd" },
  GrugFarResultsMatchRemoved = { link = "DiffDelete" },

  -- Glance
  -- GlancePreviewNormal = { link = 'Pmenu' },
  -- GlancePreviewMatch = { link = 'Comment' },
  -- GlanceListMatch = { link = 'Search' },
  GlancePreviewMatch = { fg = "#ffffff", bg = "#304E75" },
  GlanceWinbarFileName = { link = "NvimTreeRootFolder" },
  GlanceListMatch = { fg = "#8AADF4" },
  GlanceWinbarFolderName = { link = "Comment" },
  GlanceListCursorLine = { bg = "#212635" },
  GlanceListNormal = { fg = "#8F98B8", bg = "#15182A" },
  GlancePreviewNormal = { bg = "#1A1E30" },

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

  HarpoonBorder = { fg = "cyan" },
}

return M
