local harpoon = require "harpoon"

local buffers = {
  title = "Buffers",
  icon = " ",
  draw = function()
    local lines = {}
    local cwd = vim.fn.getcwd() .. "/"

    local all_buffers = vim.fn.getbufinfo()
    for _, buf in ipairs(all_buffers) do
      if buf.name:find "^term://" ~= nil or buf.name == "" then
        goto continue
      end

      if buf.listed == 1 then
        local buf_name = vim.fn.substitute(buf.name, "^" .. vim.fn.escape(cwd, "/-"), "", "")
        if buf.name == vim.api.nvim_buf_get_name(0) then
          table.insert(lines, "> " .. buf_name)
        else
          table.insert(lines, "  " .. buf_name)
        end
      end

      ::continue::
    end

    return {
      lines = lines,
    }
  end,
}

local harpoon_marks = {
  title = "Harpoon Marks",
  icon = "󱡀 ",
  draw = function()
    local marks = harpoon.get_mark_config().marks
    local keymaps = { "1 ", "2 ", "3 ", "4 " }
    local lines = {}

    for idx = 1, #marks do
      if idx > 4 then
        table.insert(lines, "  " .. marks[idx].filename)
      else
        table.insert(lines, keymaps[idx] .. marks[idx].filename)
      end
    end

    return {
      lines = lines,
    }
  end,
}

vim.api.nvim_set_hl(0, "SidebarNvimSectionTitle", { fg = "#f9f5d7" })

require("sidebar-nvim").setup {
  disable_default_keybindings = 0,
  bindings = nil,
  open = false,
  side = "right",
  initial_width = 35,
  hide_statusline = false,
  update_interval = 100,
  section_separator = { "", "-----", "" },
  section_title_separator = { "" },
  containers = {
    attach_shell = "/bin/sh",
    show_all = true,
    interval = 5000,
  },
  sections = {
    "git",
    "diagnostics",
    "todos",
    -- "symbols",
    "files",
    buffers,
    terms,
    harpoon_marks,
  },
}