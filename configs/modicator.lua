local modicator = require "modicator"

-- NOTE: Modicator requires line_numbers and cursorline to be enabled
modicator.setup {
  -- Show warning if any required option is missing
  show_warnings = true,
  highlights = {
    -- Default options for bold/italic. You can override these individually
    -- for each mode if you'd like as seen below.
    defaults = {
      -- foreground = "#f8f8f2",
      -- background = "#000000",
      bold = true,
      italic = true,
    },
    -- Color and bold/italic options for each mode. You can add a bold and/or
    -- italic key pair to override the default highlight for a specific mode if
    -- you would like.
    modes = {
      ["n"] = {
        foreground = "#f8f8f2",
      },
      ["i"] = {
        foreground = "#50fa7b",
      },
      ["v"] = {
        foreground = "#62d6e8",
      },
      ["V"] = {
        foreground = "#62d6e8",
      },
      ["�"] = { -- This symbol is the ^V character
        foreground = "#62d6e8",
      },
      ["s"] = {
        foreground = "#ff86d3",
      },
      ["S"] = {
        foreground = "#ff86d3",
      },
      ["R"] = {
        foreground = "#50fa7b",
      },
      ["c"] = {
        foreground = "#c197fd",
      },
    },
  },
}
