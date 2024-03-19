local present, luasnip = pcall(require, "luasnip")

if not present then
  return
end

luasnip.filetype_extend("javascriptreact", { "html" })
luasnip.filetype_extend("typescriptreact", { "react-ts", "typescript", "html" })
luasnip.filetype_extend("javascriptreact", { "react", "javascript", "html" })
luasnip.filetype_extend("javascript", { "react" })
luasnip.filetype_extend("vue", { "html" })

require("luasnip/loaders/from_vscode").lazy_load()
require("luasnip.loaders.from_lua").load { paths = "~/.config/nvim/lua/custom/luasnip" }

local types = require "luasnip.util.types"

-- ChoiceNode-Popup
-- https://github.com/L3MON4D3/LuaSnip/wiki/Misc#choicenode-popup
local current_nsid = vim.api.nvim_create_namespace "LuaSnipChoiceListSelections"
local current_win = nil

local function window_for_choiceNode(choiceNode)
  local buf = vim.api.nvim_create_buf(false, true)
  local buf_text, buf_text_tmp = {}, {}
  local row_selection, row_offset = 0, 0
  for i, node in ipairs(choiceNode.choices) do
    local text = node:get_docstring()
    if node == choiceNode.active_choice then
      row_selection = i
      row_offset = #text
    end
    vim.list_extend(buf_text_tmp, text, 1, #text)
  end
  local w, h = vim.lsp.util._make_floating_popup_size(buf_text_tmp, {})
  for _, text in ipairs(buf_text_tmp) do
    local lines = {}
    for line in string.gmatch(text ~= "" and text or " ", "[^\n]+") do
      table.insert(lines, line .. string.rep(" ", w - string.len(line)))
    end
    table.insert(buf_text, table.concat(lines, "\n"))
  end
  vim.api.nvim_buf_set_text(buf, 0, 0, 0, 0, buf_text)

  -- adding highlight so we can see which one is been selected.
  local extmark = vim.api.nvim_buf_set_extmark(
    buf,
    current_nsid,
    row_selection - 1, -- row_selection is 0-indexed
    0,
    { hl_group = "DiffAdd", end_row = row_selection + row_offset - 1 }
  )

  -- shows window at a beginning of choiceNode.
  local win_col = math.min(
    unpack(vim.tbl_map(tonumber, vim.opt.colorcolumn:get())),
    vim.api.nvim_win_get_width(0) - vim.g.personal_options.signcolumn_length
  )
  local win = vim.api.nvim_open_win(buf, false, {
    relative = "win",
    width = w,
    height = h,
    bufpos = choiceNode.mark:pos_begin_end(),
    style = "minimal",
    border = "rounded",
    -- snippet selection window on color column if more than one line
    row = h > 1 and 0 or 1,
    col = h > 1 and (win_col - w - 3) or 1, -- 0-index and width of border
  })

  -- return with 3 main important so we can use them again
  return { win_id = win, extmark = extmark, buf = buf }
end

local function choice_popup(choiceNode)
  -- build stack for nested choiceNodes.
  if current_win then
    vim.api.nvim_win_close(current_win.win_id, true)
    vim.api.nvim_buf_del_extmark(current_win.buf, current_nsid, current_win.extmark)
  end
  local create_win = window_for_choiceNode(choiceNode)
  current_win = {
    win_id = create_win.win_id,
    prev = current_win,
    node = choiceNode,
    extmark = create_win.extmark,
    buf = create_win.buf,
  }
end

local function update_choice_popup(choiceNode)
  vim.api.nvim_win_close(current_win.win_id, true)
  vim.api.nvim_buf_del_extmark(current_win.buf, current_nsid, current_win.extmark)
  local create_win = window_for_choiceNode(choiceNode)
  current_win.win_id = create_win.win_id
  current_win.extmark = create_win.extmark
  current_win.buf = create_win.buf
end

local function choice_popup_close()
  vim.api.nvim_win_close(current_win.win_id, true)
  vim.api.nvim_buf_del_extmark(current_win.buf, current_nsid, current_win.extmark)
  -- now we are checking if we still have previous choice we were in after exit nested choice
  current_win = current_win.prev
  if current_win then
    -- reopen window further down in the stack.
    local create_win = window_for_choiceNode(current_win.node)
    current_win.win_id = create_win.win_id
    current_win.extmark = create_win.extmark
    current_win.buf = create_win.buf
  end
end

local choice_popup_g = vim.api.nvim_create_augroup("LuaSnipChoicePopup", { clear = true })

vim.api.nvim_create_autocmd("User", {
  pattern = "LuasnipChoiceNodeEnter",
  group = choice_popup_g,
  callback = function(_)
    choice_popup(luasnip.session.event_node)
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "LuasnipChoiceNodeLeave",
  group = choice_popup_g,
  callback = function(_)
    choice_popup_close()
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "LuasnipChangeChoice",
  group = choice_popup_g,
  callback = function(_)
    update_choice_popup(luasnip.session.event_node)
  end,
})

luasnip.setup {
  history = true,
  enable_autosnippets = true,
  update_events = { "TextChanged", "TextChangedI" },
  delete_check_events = "TextChanged",
  region_check_events = "CursorMoved",
  ext_opts = {
    [types.insertNode] = {
      unvisited = {
        virt_text = { { "|", "Conceal" } },
        hl_mode = "combine",
        -- virt_text_pos = "inline",
      },
      active = {
        virt_text = { { "●", "yellow" } },
        hl_mode = "combine",
      },
    },
    [types.exitNode] = {
      unvisited = {
        virt_text = { { "|", "Conceal" } },
        hl_mode = "combine",
        -- virt_text_pos = "inline",
      },
    },
    [types.choiceNode] = {
      active = {
        virt_text = { { "●", "blue" } },
        hl_mode = "combine",
      },
    },
  },
}
