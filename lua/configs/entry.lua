local my_make_entry = {}

local devicons = require "nvim-web-devicons"
local entry_display = require "telescope.pickers.entry_display"

function my_make_entry.find_files_entry_maker(opts)
  opts = opts or {}
  local default_icons, _ = devicons.get_icon("file", "", { default = true })

  local displayer = entry_display.create {
    separator = " ",
    items = {
      { width = vim.fn.strwidth(default_icons) },
      { remaining = true },
      { remaining = true },
    },
  }

  local make_display = function(entry)
    return displayer {
      { entry.devicons, entry.devicons_highlight },
      entry.file_name,
      { entry.grayed_out, "Comment" },
    }
  end

  return function(entry)
    local grayed_out

    if entry:find "/" == nil then
      grayed_out = vim.fn.fnamemodify(entry, ":p:h") -- Path from root
    else
      grayed_out = entry:gsub("/[^/]*$", "") -- Path without filename
    end

    local file_name = vim.fn.fnamemodify(entry, ":p:t")

    local icons, highlight = devicons.get_icon(entry, string.match(entry, "%a+$"), { default = true })

    return {
      valid = true,
      value = entry,
      ordinal = entry,
      display = make_display,
      devicons = icons,
      devicons_highlight = highlight,
      file_name = file_name,
      grayed_out = grayed_out,
    }
  end
end

return my_make_entry
