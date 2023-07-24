local Win_id

function ShowMenu(opts, cb)

  local popup = require "plenary.popup"
  local height = 5
  local width = 15
  local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
  opts = { "Close All", "Show All" }

  Win_id = popup.create(opts, {
    title = "",
    highlight = "MyProjectWindow",
    -- line = math.floor(((vim.o.lines - height) / 2) - 1),
    -- col = math.floor((vim.o.columns - width) / 2),
    line = "cursor+2",
    col = "cursor-1",
    borderhighlight = "TermHl",
    titlehighlight = "TermHl",
    focusable = true,
    style = "minimal",
    relative = "cursor",
    minwidth = width,
    minheight = height,
    borderchars = borderchars,
    callback = cb,
  })
  local bufnr = vim.api.nvim_win_get_buf(Win_id)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "<cmd>lua CloseMenu()<CR>", { silent = false })
end

function MyMenu()
  local opts = {}
  local cb = function(_, sel)
    if sel == "Close All" then
      vim.notify "Close All"
    elseif sel == 2 then
      vim.notify "2"
    elseif sel == 3 then
      vim.notify "3"
    end
  end
  ShowMenu(opts, cb)
end

function SelectUI()
  vim.ui.select({ "Australia", "Belarus", "Canada", "Denmark", "Egypt", "Fiji" }, {
    prompt = "Select a country",
    format_item = function(item)
      return "I like to visit " .. item
    end,
  }, function(country, idx)
    if country then
      print("You selected " .. country .. " at index " .. idx)
    else
      print "You cancelled"
    end
  end)
end

function CloseMenu()
  vim.api.nvim_win_close(Win_id, true)
end
