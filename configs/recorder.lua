local popup = require "plenary.popup"

vim.keymap.set("n", "<leader>qo", function()
  MyMenu()
end, {}) -- Show macros

local function extract_chunk_after_gap(input_string)
  local chunk = input_string:match "[a-g]%s*(.+)"
  return chunk
end

local function get_line_content()
  return vim.api.nvim_buf_get_lines(0, get_line_number() - 1, get_line_number(), false)[1]
end

local window_id
function ShowMenu(opts, cb)
  local height = 20
  local width = 100
  local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

  local content = {}
  local array_length = #opts

  -- Take each macro line and turn into a table
  for i, value in ipairs(opts) do
    if i < array_length then
      local new_string = value:gsub("\n", "")
      local str = new_string:find '"'
      if str then
        new_string = new_string:sub(str + 1)
      end
      table.insert(content, new_string)
    end
  end

  window_id = popup.create(content, {
    title = "Macros",
    highlight = "MyProjectWindow",
    line = math.floor(((vim.o.lines - height) / 2) - 1),
    col = math.floor((vim.o.columns - width) / 2),
    minwidth = width,
    minheight = height,
    borderchars = borderchars,
    callback = cb,
  })

  local function closeMenu()
    vim.api.nvim_win_close(window_id, true)
  end

  local function editMacro()
    local line_content = get_line_content()
    local macro = extract_chunk_after_gap(line_content)
    local register = line_content:sub(1, 1)

    vim.api.nvim_buf_set_lines(0, 0, -1, false, {})
    vim.api.nvim_buf_set_lines(0, 0, 1, false, { macro })

    vim.keymap.set("n", "<leader>s", function()
      local line_content_updated = get_line_content()
      vim.fn.setreg(register, line_content_updated)
      closeMenu()
      require "notify" "Macro saved!"
    end, { silent = true, buffer = 0 })
  end

  vim.keymap.set("n", "<Esc>", function()
    closeMenu()
  end, { silent = true, buffer = 0 })

  vim.keymap.set("n", "e", function()
    editMacro()
  end, { silent = true, buffer = 0 })
end

local function get_multiple_registers_content(registers)
  local reg_content_array = {}
  local saved_reg_content = vim.fn.getreg "@"

  for i, register in ipairs(registers) do
    vim.cmd "redir => reg_content"
    vim.cmd('silent execute "reg ' .. register .. '"')
    vim.cmd "redir END"
    local reg_content = vim.fn.eval "reg_content"

    -- Remove header
    if reg_content ~= nil then
      for s in reg_content:gmatch "[^\r\n]+" do
        if s ~= "Type Name Content" then
          reg_content_array[i] = s
        end
      end
    end
  end

  vim.fn.setreg("@", saved_reg_content)
  return reg_content_array
end

local function get_register(input_string)
  local character_before_blank = input_string:match "([a-g])%s"
  return character_before_blank
end

local registers = { "a", "b", "c", "d", "e", "f", "g" } -- The macro slots and registers
function MyMenu()
  local opts = get_multiple_registers_content(registers)
  local cb = function(_, sel)
    local macro_register = get_register(sel)
    local cmd = "@" .. macro_register
    vim.api.nvim_feedkeys(cmd, "n", true)
  end
  ShowMenu(opts, cb)
end

require("recorder").setup {
  slots = registers,
  mapping = {
    startStopRecording = "q",
    playMacro = "Q",
    editMacro = "<leader>qe",
    switchSlot = "<leader>qt",
  },
  lessNotifications = true,
  clear = false,
  logLevel = vim.log.levels.INFO,
  dapSharedKeymaps = false,
}
