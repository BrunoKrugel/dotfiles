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

local base_info = {
  title = "Info",
  icon = "",
  draw = function()
    local lines = {}

    -- Mode
    local modes = {
      ["n"] = "Normal",
      ["no"] = "N·Operator Pending",
      ["v"] = "Visual",
      ["V"] = "V·Line",
      [""] = "V·Block",
      ["s"] = "Select",
      ["S"] = "S·Line",
      [""] = "S·Block",
      ["i"] = "Insert",
      ["R"] = "Replace",
      ["Rv"] = "V·Replace",
      ["c"] = "Command",
      ["cv"] = "Vim Ex",
      ["ce"] = "Ex",
      ["r"] = "Prompt",
      ["rm"] = "More",
      ["r?"] = "Confirm",
      ["!"] = "Shell",
      ["t"] = "Terminal",
    }
    local mode = vim.fn.mode()
    local mode_name = modes[mode]
    table.insert(lines, "mode: " .. (mode_name and mode_name or "undefined"))

    -- Git branch
    if vim.fn.isdirectory ".git" then
      local branch = vim.fn.system "git branch --show-current 2> /dev/null | tr -d '\n'"
      if branch ~= "" then
        table.insert(lines, "branch: " .. branch)
      end
    end

    -- Project Stuff
    local current_project = require("conduct").current_project.name
    if current_project ~= nil then
      table.insert(lines, "project: " .. current_project)
      local current_session = require("conduct").current_session
      table.insert(lines, "session: " .. current_session)
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
  section_separator = { "", "──────────────────────────────", "" },
  section_title_separator = { "" },
  containers = {
    attach_shell = "/bin/sh",
    show_all = true,
    interval = 5000,
  },
  ["git"] = {
    icon = "",
  },
  ["diagnostics"] = {
    icon = "",
  },
  ["todos"] = {
    icon = "",
  },
  dap = {
    breakpoints = {
      icon = "",
    },
  },
  sections = {
    "git",
    "diagnostics",
    "todos",
    "symbols",
    -- "files",
    -- buffers,
    -- terms,
    "containers",
    require "dap-sidebar-nvim.breakpoints",
    harpoon_marks,
  },
}
