local M = {}

M.base_30 = {
  white = "#D9E0EE",
  darker_black = "#2a2b3c",
  black = "#313346", --  nvim bg
  black2 = "#3b3d54",
  one_bg = "#2d2c3c", -- real bg of onedark
  one_bg2 = "#38364a",
  one_bg3 = "#424057",
  grey = "#75799e",
  grey_fg = "#8386a8",
  grey_fg2 = "#7c80a3",
  light_grey = "#605f6f",
  red = "#F38BA8",
  baby_pink = "#ffa5c3",
  pink = "#f5c2e7",
  line = "#383747", -- for lines like vertsplit
  green = "#a6e3a1",
  vibrant_green = "#a5c989",
  nord_blue = "#8bc2f0",
  blue = "#89b4fa",
  yellow = "#f9e2af",
  sun = "#ffe9b6",
  purple = "#d0a9e5",
  dark_purple = "#c7a0dc",
  teal = "#B5E8E0",
  orange = "#F8BD96",
  cyan = "#89DCEB",
  statusline_bg = "#232232",
  lightbg = "#2f2e3e",
  pmenu_bg = "#a6e3a1",
  folder_bg = "#74c7ec",
  lavender = "#b4befe",
}

M.base_16 = {
  base00 = "#313346",
  base01 = "#282737",
  base02 = "#2f2e3e",
  base03 = "#383747",
  base04 = "#414050",
  base05 = "#bfc6d4",
  base06 = "#ccd3e1",
  base07 = "#D9E0EE",
  base08 = "#F38BA8",
  base09 = "#F8BD96",
  base0A = "#FAE3B0",
  base0B = "#a5c989",
  base0C = "#89DCEB",
  base0D = "#89B4FA",
  base0E = "#CBA6F7",
  base0F = "#F38BA8",
}

M.polish_hl = {
  ["@variable"] = { fg = M.base_30.lavender },
  ["@property"] = { fg = M.base_30.teal },
  ["@function"] = { fg = M.base_30.green},
  ["@variable.builtin"] = { fg = M.base_30.red },
  ["Function"] = { fg = "blue" },
  ["@function"] = { fg = "blue" },
  ["@property"] = { fg = "purple" },
  ["@keyword"] = {fg = "pink"},
}

M.type = "dark"

return M
