local present, lspsaga = pcall(require, "lspsaga")

if not present then
  return
end

lspsaga.setup {
  -- symbol_in_winbar = {
  -- 	in_custom = false,
  -- 	enable = true,
  -- 	separator = " ",
  -- 	show_file = true,
  -- 	-- define how to customize filename, eg: %:., %
  -- 	-- if not set, use default value `%:t`
  -- 	-- more information see `vim.fn.expand` or `expand`
  -- 	-- ## only valid after set `show_file = true`
  -- 	file_formatter = "",
  -- 	click_support = function(node, clicks, button, modifiers)
  -- 		-- To see all available details: vim.pretty_print(node)
  -- 		local st = node.range.start
  -- 		local en = node.range["end"]
  -- 		if button == "l" then
  -- 			if clicks == 2 then
  -- 			-- double left click to do nothing
  -- 			else -- jump to node's starting line+char
  -- 				vim.fn.cursor(st.line + 1, st.character + 1)
  -- 			end
  -- 		elseif button == "r" then
  -- 			if modifiers == "s" then
  -- 				print("lspsaga") -- shift right click to print "lspsaga"
  -- 			end -- jump to node's ending line+char
  -- 			vim.fn.cursor(en.line + 1, en.character + 1)
  -- 		elseif button == "m" then
  -- 			-- middle click to visual select node
  -- 			vim.fn.cursor(st.line + 1, st.character + 1)
  -- 			vim.cmd("normal v")
  -- 			vim.fn.cursor(en.line + 1, en.character + 1)
  -- 		end
  -- 	end,
  -- },
  -- border_style = "rounded",
  preview = {
    lines_above = 0,
    lines_below = 10,
  },
  scroll_preview = {
    scroll_down = "<C-f>",
    scroll_up = "<C-b>",
  },
  definition = {
    edit = "<C-c>o",
    vsplit = "<C-c>v",
    split = "<C-c>i",
    tabe = "<C-c>t",
    quit = "q",
    close = "<Esc>",
  },
  code_action = {
    num_shortcut = true,
    keys = {
      -- string |table type
      quit = "q",
      exec = "<CR>",
    },
  },
  request_timeout = 2000,
  finder = {
    edit = { "o", "<CR>" },
    vsplit = "s",
    split = "i",
    tabe = "t",
    quit = { "q", "<ESC>" },
  },
  lightbulb = {
    enable = false,
    enable_in_insert = true,
    sign = true,
    sign_priority = 40,
    virtual_text = true,
  },
  diagnostic = {
    show_code_action = true,
    show_source = true,
    jump_num_shortcut = true,
    keys = {
      exec_action = "o",
      quit = "q",
      go_action = "g",
    },
    theme = {},
  },
  outline = {
    win_position = "right",
    win_with = "",
    win_width = 30,
    show_detail = true,
    auto_preview = true,
    auto_refresh = true,
    auto_close = true,
    custom_sort = nil,
    keys = {
      jump = "o",
      expand_collapse = "u",
      quit = "q",
    },
  },
  symbol_in_winbar = {
    enable = true,
    separator = " ",
    hide_keyword = true,
    show_file = true,
    folder_level = 2,
    respect_root = false,
    color_mode = true,
  },
  ui = {
    -- currently only round theme
    theme = "round",
    -- this option only work in neovim 0.9
    title = true,
    -- border type can be single,double,rounded,solid,shadow.
    border = "rounded",
    winblend = 0,
    expand = "",
    collapse = "",
    preview = " ",
    code_action = "💡",
    diagnostic = "🐞",
    incoming = " ",
    outgoing = " ",
    colors = {
      --float window normal background color
      normal_bg = "#000000",
      --title background color
      title_bg = "#FF7070",
      red = "#e95678",
      magenta = "#b33076",
      orange = "#FF8700",
      yellow = "#f7bb3b",
      green = "#afd700",
      cyan = "#36d0e0",
      blue = "#61afef",
      purple = "#CBA6F7",
      white = "#d1d4cf",
      black = "#1c1c19",
    },
    kind = {},
  },
}
