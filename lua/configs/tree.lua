local UserDecorator = require "nvim-tree.renderer.decorator.user"

---A string with one or more highlight groups applied to it
---@class (exact) HighlightedString
---@field str string
---@field hl string[] highlight groups applied in order

---Custom user decorators must inherit from UserDecorator
---@class (exact) UserDecoratorExample: UserDecorator
---@field private my_icon HighlightedString
local UserDecoratorExample = UserDecorator:extend()

---Constructor will be called once per tree render, with no arguments.
function UserDecoratorExample:new()
  UserDecoratorExample.super.new(self, {
    enabled = true,
    hl_pos = "name",
    icon_placement = "right_align",
  })

  -- create your icon once, for convenience
  self.my_icon = { str = "E", hl = { "ExampleIcon" } }

  -- Define the icon sign only once
  -- Only needed if you are using icon_placement = "signcolumn"
  -- self:define_sign(self.my_icon)
end

---@param node Node
---@return HighlightedString[]|nil icons
function UserDecoratorExample:calculate_icons(node)
  if node.name == "example" then
    return { self.my_icon }
  else
    return nil
  end
end

---@param node Node
---@return string|nil group
function UserDecoratorExample:calculate_highlight(node)
  if node.name == "example" then
    return "ExampleHighlight"
  else
    return nil
  end
end

local function on_attach(bufnr)
  local api = require "nvim-tree.api"
  local lib = require "nvim-tree.lib"
  local tree_actions = require "nvim-tree.actions"

  local function opts(desc)
    return {
      desc = "nvim-tree: " .. desc,
      buffer = bufnr,
      noremap = true,
      silent = true,
      nowait = true,
    }
  end

  local function fancy_prompt(action_type, default_text, callback)
    local buf = api.nvim_create_buf(false, true)
    local winopts = {
      height = 1,
      style = "minimal",
      border = "single",
      row = 1,
      col = 1,
      relative = "cursor",
      width = #default_text + 15,
      title = { { action_type == "rename" and " Rename " or " Create ", "@comment.danger" } },
      title_pos = "center",
    }
    local win = api.nvim_open_win(buf, true, winopts)
    vim.wo[win].winhl = "Normal:Normal,FloatBorder:Removed"
    vim.api.nvim_set_current_win(win)
    vim.api.nvim_buf_set_lines(buf, 0, -1, true, { " " .. default_text })
    vim.bo[buf].buftype = "prompt"
    vim.fn.prompt_setprompt(buf, "")
    vim.api.nvim_input "A"

    vim.keymap.set({ "i", "n" }, "<Esc>", function()
      vim.api.nvim_buf_delete(buf, { force = true })
      vim.cmd "mode" -- Ensure normal mode
    end, { buffer = buf })

    vim.fn.prompt_setcallback(buf, function(text)
      local new_name = vim.trim(text)
      vim.api.nvim_buf_delete(buf, { force = true })
      vim.cmd "mode" -- Ensure normal mode
      if #new_name > 0 and new_name ~= default_text then
        callback(new_name)
      end
    end)
  end

  local function custom_rename()
    local node = require("nvim-tree.lib").get_node_at_cursor()
    if not node then
      return
    end
    local default_text = vim.fn.fnamemodify(node.absolute_path, ":t")
    fancy_prompt("rename", default_text, function(new_name)
      tree_actions.fs.rename_node.apply(node, new_name)
    end)
  end
  local function custom_create()
    fancy_prompt("create", "", function(new_name)
      tree_actions.fs.create_file.apply(new_name)
    end)
  end

  local function smart_close_q()
    if #vim.fn.tabpagebuflist() == 1 then
      vim.cmd.quit { mods = { confirm = true } }
    end
    api.tree.close()
  end

  local function smart_close_esc()
    if #vim.fn.tabpagebuflist() == 1 then
      return
    end
    api.tree.close()
  end

  local map = vim.keymap.set
  -- BEGIN_DEFAULT_ON_ATTACH
  map("n", "<C-]>", api.tree.change_root_to_node, opts "CD")
  map("n", "<C-e>", api.node.open.replace_tree_buffer, opts "Open: In Place")
  map("n", "<C-k>", api.node.show_info_popup, opts "Info")
  map("n", "<C-r>", api.fs.rename_sub, opts "Rename: Omit Filename")
  map("n", "<C-t>", api.node.open.tab, opts "Open: New Tab")
  map("n", "<C-v>", api.node.open.vertical, opts "Open: Vertical Split")
  map("n", "<C-x>", api.node.open.horizontal, opts "Open: Horizontal Split")
  map("n", "<BS>", api.node.navigate.parent_close, opts "Close Directory")
  map("n", "<CR>", api.node.open.edit, opts "Open")
  map("n", "<Tab>", api.node.open.preview, opts "Open Preview")
  map("n", ">", api.node.navigate.sibling.next, opts "Next Sibling")
  map("n", "<", api.node.navigate.sibling.prev, opts "Previous Sibling")
  map("n", ".", api.node.run.cmd, opts "Run Command")
  map("n", "-", api.tree.change_root_to_parent, opts "Up")
  -- map("n", "a", api.fs.create, opts "Create")
  map("n", "bmv", api.marks.bulk.move, opts "Move Bookmarked")
  map("n", "B", api.tree.toggle_no_buffer_filter, opts "Toggle No Buffer")
  map("n", "c", api.fs.copy.node, opts "Copy")
  map("n", "C", api.tree.toggle_git_clean_filter, opts "Toggle Git Clean")
  map("n", "[c", api.node.navigate.git.prev, opts "Prev Git")
  map("n", "]c", api.node.navigate.git.next, opts "Next Git")
  map("n", "d", api.fs.remove, opts "Delete")
  map("n", "D", api.fs.remove, opts "Delete")
  map("n", "E", api.tree.expand_all, opts "Expand All")
  map("n", "e", api.fs.rename_basename, opts "Rename: Basename")
  map("n", "]e", api.node.navigate.diagnostics.next, opts "Next Diagnostic")
  map("n", "[e", api.node.navigate.diagnostics.prev, opts "Prev Diagnostic")
  map("n", "F", api.live_filter.clear, opts "Clean Filter")
  map("n", "f", api.live_filter.start, opts "Filter")
  map("n", "g?", api.tree.toggle_help, opts "Help")
  map("n", "gy", api.fs.copy.absolute_path, opts "Copy Absolute Path")
  map("n", "H", api.tree.toggle_hidden_filter, opts "Toggle Dotfiles")
  map("n", "I", api.tree.toggle_gitignore_filter, opts "Toggle Git Ignore")
  map("n", "J", api.node.navigate.sibling.last, opts "Last Sibling")
  map("n", "K", api.node.navigate.sibling.first, opts "First Sibling")
  map("n", "m", api.marks.toggle, opts "Toggle Bookmark")
  map("n", "o", api.node.open.edit, opts "Open")
  map("n", "O", api.node.open.no_window_picker, opts "Open: No Window Picker")
  map("n", "p", api.fs.paste, opts "Paste")
  map("n", "P", api.node.navigate.parent, opts "Parent Directory")
  map("n", "q", smart_close_q, opts "Close")
  -- map("n", "r", api.fs.rename, opts "Rename")
  map("n", "r", custom_rename, opts "Rename")
  map("n", "a", custom_create, opts "Create")
  map("n", "R", api.tree.reload, opts "Refresh")
  map("n", "s", api.node.run.system, opts "Run System")
  map("n", "S", api.tree.search_node, opts "Search")
  map("n", "U", api.tree.toggle_custom_filter, opts "Toggle Hidden")
  map("n", "W", api.tree.collapse_all, opts "Collapse")
  map("n", "x", api.fs.cut, opts "Cut")
  map("n", "y", api.fs.copy.filename, opts "Copy Name")
  map("n", "Y", api.fs.copy.relative_path, opts "Copy Relative Path")
  map("n", "<2-LeftMouse>", api.node.open.edit, opts "Open")
  map("n", "<2-RightMouse>", api.tree.change_root_to_node, opts "CD")
  -- END_DEFAULT_ON_ATTACH

  local function tab_with_close()
    local marks = api.marks.list()
    if #marks == 0 then
      api.node.open.tab()
    else
      for _, node in pairs(api.marks.list()) do
        api.node.open.tab(node)
      end
      api.marks.clear()
    end
  end

  map("n", ".", api.tree.toggle_hidden_filter, opts "Toggle Dotfiles")
  map("n", "a", api.fs.create, opts "Create")
  map("n", "r", api.fs.rename_sub, opts "Rename: Omit Filename")
  map("n", "cd", api.tree.change_root_to_node, opts "CD")
  map("n", "<C-r>", api.tree.reload, opts "Refresh")
  map("n", "<Tab>", tab_with_close, opts "Open: New Tab")
  map("n", "<Esc>", smart_close_esc, opts "Close")
  -- map("n", "z", api.node.navigate.parent_close, opts "Close Directory")
  map("n", "t", api.marks.toggle, opts "Toggle Bookmark")
  map("n", "+", api.tree.change_root_to_node, opts "CD")
  map("n", "<leader>dj", api.node.navigate.diagnostics.next, opts "Next Diagnostic")
  map("n", "<leader>dk", api.node.navigate.diagnostics.prev, opts "Prev Diagnostic")

  map("n", "z", function()
    local node = lib.get_node_at_cursor()
    local grugFar = require "grug-far"
    if node then
      local path
      if node.type == "directory" then
        path = node.absolute_path
      else
        path = vim.fn.fnamemodify(node.absolute_path, ":h")
      end

      -- escape all spaces in the path with "\ "
      path = path:gsub(" ", "\\ ")

      local prefills = {
        paths = path,
      }

      if not grugFar.has_instance "tree" then
        grugFar.grug_far {
          instanceName = "tree",
          prefills = prefills,
          staticTitle = "Find and Replace from Tree",
        }
      else
        grugFar.open_instance "tree"
        grugFar.update_instance_prefills("tree", prefills, false)
      end
    end
  end, opts "Search in directory")
end

return {
  on_attach = on_attach,
  filters = {
    dotfiles = false,
    custom = {
      "**/node_modules",
      "**/%.git",
      "**/%.github",
    },
  },
  git = {
    enable = true,
    ignore = false,
    show_on_dirs = true,
    show_on_open_dirs = false,
  },
  hijack_unnamed_buffer_when_opening = true,
  hijack_cursor = true,
  diagnostics = {
    enable = true,
    show_on_dirs = true,
    debounce_delay = 50,
    show_on_open_dirs = false,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  view = {
    preserve_window_proportions = true,
    width = {
      min = 40,
      padding = 2,
    },
    signcolumn = "no",
  },
  sync_root_with_cwd = true,
  renderer = {
    decorators = {
      "Diagnostics",
      "Git",
      "Open",
      "Hidden",
      "Modified",
      "Bookmark",
      "Copied",
      "Cut",
    },
    highlight_opened_files = "name",
    highlight_git = false,
    highlight_diagnostics = true,
    -- root_folder_label = ":~",
    group_empty = true,
    indent_markers = {
      enable = false,
      icons = {
        corner = "└ ",
        edge = "│ ",
        none = "  ",
      },
    },
    icons = {
      git_placement = "after",
      diagnostics_placement = "after", -- right_align
      padding = " ",
      show = {
        git = true,
        bookmarks = false,
        diagnostics = true,
        file = true,
        folder = true,
        folder_arrow = true,
        modified = true,
      },
      web_devicons = {
        folder = {
          enable = true, -- Special folder devicon icons
          color = true,
        },
      },
      -- git_placement = 'signcolumn',
      glyphs = {
        default = "󰈚",
        symlink = "",
        modified = "",
        folder = {
          default = "",
          empty = "",
          empty_open = "",
          open = "",
          symlink = "",
          symlink_open = "",
          arrow_open = " ",
          arrow_closed = " ",
        },
        git = {
          unstaged = "",
          -- unstaged = "",
          staged = "",
          unmerged = "",
          renamed = "➜",
          -- untracked = "",
          untracked = "",
          deleted = "",
          ignored = "◌",
        },
      },
    },
  },
  actions = {
    open_file = {
      quit_on_open = true,
      resize_window = false,
    },
  },
  tab = {
    sync = {
      open = true,
      close = true,
    },
  },
}
