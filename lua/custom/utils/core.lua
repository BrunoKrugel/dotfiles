local M = {}
local merge_tb = vim.tbl_deep_extend
local breakpoint = 100

local function stbufnr()
  return vim.api.nvim_win_get_buf(vim.g.statusline_winid)
end

require "custom.utils.mouse"

M.load_mappings = function(section, mapping_opt)
  vim.schedule(function()
    local function set_section_map(section_values)
      if section_values.plugin then
        return
      end

      section_values.plugin = nil

      for mode, mode_values in pairs(section_values) do
        local default_opts = merge_tb("force", { mode = mode }, mapping_opt or {})
        for keybind, mapping_info in pairs(mode_values) do
          -- merge default + user opts
          local opts = merge_tb("force", default_opts, mapping_info.opts or {})

          mapping_info.opts, opts.mode = nil, nil
          opts.desc = mapping_info[2]

          vim.keymap.set(mode, keybind, mapping_info[1], opts)
        end
      end
    end

    local mappings = require("nvconfig").mappings

    if type(section) == "string" then
      mappings[section]["plugin"] = nil
      mappings = { mappings[section] }
    end

    for _, sect in pairs(mappings) do
      set_section_map(sect)
    end
  end)
end

local function hasLspErrors()
  local bufnr = vim.api.nvim_get_current_buf()
  local diagnostics = vim.lsp.diagnostic.get(bufnr)

  for _, diagnostic in pairs(diagnostics) do
    if diagnostic.severity == vim.lsp.protocol.DiagnosticSeverity.Error then
      return true
    end
  end

  return false
end

function Get_Conflict()
  local conflict = ""

  if package.loaded["git-conflict"] then
    local gc = require "git-conflict"
    local ok, conflict_count = pcall(gc.conflict_count)
    if ok then
      conflict = (conflict_count ~= 0) and ("%#St_lspError#%" .. " " .. conflict_count) or ""
    end
  end
  return conflict
end

function Get_dap()
  if package.loaded["dap"] then
    local ok, dap = pcall(require, "dap")
    if ok then
      local status = dap.status()
      if status ~= "" then
        return "   " .. status .. " "
      end
      return ""
    else
      return ""
    end
  else
    return ""
  end
end

function Get_Sidekick()
  local status = require("sidekick.status").get()
  if status and status.kind == "Error" then
    return " "
  end
  return " "
end

function Get_record()
  if package.loaded["recorder"] then
    local ok, recorder = pcall(require, "recorder")
    if ok then
      local status = recorder.recordingStatus()
      if status ~= "" then
        return " " .. status .. " "
      end
      return ""
    else
      return ""
    end
  else
    return ""
  end
end

M.dapui = {
  icons = { expanded = "▾", collapsed = "▸" },
  mappings = {
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  expand_lines = false,
  layouts = {
    {
      elements = {
        { id = "scopes", size = 0.40 },
        { id = "breakpoints", size = 0.20 },
        { id = "stacks", size = 0.20 },
        { id = "watches", size = 0.20 },
      },
      size = 40, -- 40 columns
      position = "left",
    },
    {
      elements = {
        {
          id = "repl",
          size = 0.5,
        },
        -- {
        --   id = "console",
        --   size = 0.5,
        -- },
      },
      size = 10, -- 25% of total lines
      position = "bottom",
    },
  },
  floating = {
    max_height = nil,
    max_width = nil,
    border = "rounded", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil,
  },
}

M.lazy = {
  change_detection = {
    enabled = true,
    notify = false,
  },
  ui = {
    size = {
      width = 0.8,
      height = 0.8,
    },
  },
  checker = { enabled = true, concurrency = 5, frequency = 2 * 86400, wait = true },
  -- concurrency = 10,
  git = {
    log = { "-8" },
    timeout = 35,
    url_format = "https://github.com/%s.git",
    filter = true,
    -- rate of network related git operations (clone, fetch, checkout)
    throttle = {
      enabled = true, -- not enabled by default
      rate = 2,
      duration = 5 * 1000, -- in ms
    },
    cooldown = 5,
  },
}

M.tabufline = {
  show_numbers = false,
  enabled = true,
  lazyload = true,
  modules = {
    buttons = function()
      return "%#SplitHl#%@v:lua.ClickUpdate@  %#SplitHl#%@v:lua.ClickGit@  %#SplitHl#%@v:lua.ClickSplit@ "
    end,
  },
  order = {
    "treeOffset",
    "buffers",
    "tabs",
    "buttons",
  },
}

M.statusline = {
  theme = "vscode_colored",
  order = {
    "modes",
    -- "relativepath",
    "icons",
    "old_git",
    "diagnostics",
    "record",
    "%=",
    "lsp_msg",
    "dap",
    "%=",
    "git_changed",
    "cursor",
    "lsp_status",
    "filetype",
    "encoding",
    "notification",
    "cwd",
  },
  modules = {
    icons = function()
      local icon = " 󰈚 "
      local filename = vim.fn.expand "%:t"
      local icon_text

      if filename ~= "Empty " then
        local devicons_present, devicons = pcall(require, "nvim-web-devicons")

        if devicons_present then
          local ft_icon, ft_icon_hl = devicons.get_icon(filename, string.match(filename, "%a+$"))
          icon = (ft_icon ~= nil and " " .. ft_icon) or ""
          local icon_hl = ft_icon_hl or "DevIconDefault"
          local hl_fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(icon_hl)), "fg")
          local hl_bg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID "StText"), "bg")
          vim.api.nvim_set_hl(0, "St_" .. icon_hl, { fg = hl_fg, bg = hl_bg })

          if string.find(filename, "toggleterm") then
            filename = '%{&ft == "toggleterm" ? " Terminal (".b:toggle_number.") " : ""}'
          end
          if string.find(filename, "NvimTree") then
            filename = '%{&ft == "NvimTree" ? " File Explorer " : ""}'
          end

          icon_text = "%#St_" .. icon_hl .. "#" .. icon .. "%#StText# " .. filename .. " "
        end
      end

      return icon_text or ("%#StText# " .. icon .. filename)
    end,

    relativepath = function()
      local path = vim.api.nvim_buf_get_name(stbufnr())
      if path == "" then
        return ""
      end

      return "%#St_relativepath# " .. vim.fn.expand "%:.:h" .. " /"
    end,

    old_git = function()
      if not vim.b[stbufnr()].gitsigns_head or vim.b[stbufnr()].gitsigns_git_status then
        return ""
      end

      return "%#StGit#  " .. vim.b[stbufnr()].gitsigns_status_dict.head .. "" .. Get_Conflict()
    end,

    git_changed = function()
      if not vim.b[stbufnr()].gitsigns_head or vim.b[stbufnr()].gitsigns_git_status or vim.o.columns < 120 then
        return ""
      end

      local git_status = vim.b[stbufnr()].gitsigns_status_dict

      local added = (git_status.added and git_status.added ~= 0) and ("%#St_lspInfo#  " .. git_status.added .. " ")
        or ""
      local changed = (git_status.changed and git_status.changed ~= 0)
          and ("%#St_lspWarning#  " .. git_status.changed .. " ")
        or ""
      local removed = (git_status.removed and git_status.removed ~= 0)
          and ("%#St_lspError#  " .. git_status.removed .. " ")
        or ""

      return (added .. changed .. removed) ~= "" and (added .. changed .. removed .. " | ") or ""
    end,

    encoding = function()
      local encode = vim.bo[stbufnr()].fileencoding
      return string.upper(encode) == "" and "" or "%#StText#" .. string.upper(encode) .. " "
    end,

    record = function()
      return "%#St_lspError#" .. Get_record()
    end,

    filetype = function()
      if vim.o.columns < breakpoint then
        return ""
      end

      local ft = vim.bo[stbufnr()].ft
      return ft == " " and " %#St_ft# {} plain text  " or " %#St_ft#{} " .. ft .. " "
    end,

    lsp_status = function()
      local count = 0
      if rawget(vim, "lsp") then
        for _, client in ipairs(vim.lsp.get_clients()) do
          if
            client.attached_buffers[vim.api.nvim_get_current_buf()]
            and (
              client.name ~= "null-ls"
              and client.name ~= "copilot"
              and client.name ~= "GitHub Copilot"
              and client.name ~= "golangci_lint_ls"
            )
          then
            count = count + 1
            local copilot = "%#CopilotHl#" .. Get_Sidekick() .. " "
            local lsp_name = client.name
            if client.name == "typescript-tools" then
              lsp_name = "typescript"
            end
            return (vim.o.columns > 100 and copilot .. ("%#St_Lsp#  " .. lsp_name .. " (" .. count .. ")"))
              or copilot .. "  LSP (" .. count .. ") "
          end
        end
      end
      return ""
    end,

    modes = function()
      local utils = require "nvchad.stl.utils"
      if not utils.is_activewin() then
        return ""
      end

      local modes = utils.modes

      modes["n"][3] = " 󰀘 "
      modes["v"][3] = "  "
      modes["i"][3] = "  "
      modes["t"][3] = "  "

      modes["ic"][1] = "INSERT"
      modes["ix"][1] = "INSERT"

      local m = vim.api.nvim_get_mode().mode
      return "%#St_" .. modes[m][2] .. "mode#" .. (modes[m][3] or "  ") .. modes[m][1] .. " "
    end,

    notification = function()
      return "%#StText#" .. "%@v:lua.ClickNotifications@ " .. " %#St_lspError#"
    end,

    dap = function()
      return "%#St_lspError#" .. Get_dap()
    end,
  },
}

local home = os.getenv "HOME" .. "/"

local replace_home_path = function(path)
  if path:find(home) then
    return "~/" .. string.gsub(path, "^" .. home, "")
  end
  return path
end

local letters = {}
for i = string.byte "a", string.byte "z" do
  local letter = string.char(i)
  if not vim.tbl_contains({ "j", "k", "h", "l" }, letter) then
    table.insert(letters, letter)
  end
end

local function set_recent_files(tb)
  local files = {}

  for _, v in ipairs(vim.v.oldfiles) do
    if #files == 5 then
      break
    end
    if vim.uv.fs_stat(v) then
      table.insert(files, v)
    end
  end

  for i, v in ipairs(files) do
    local devicon, devicon_hl = require("nvim-web-devicons").get_icon(v)
    local icon = devicon or ""
    local path = replace_home_path(v):sub(1, 100)
    local keybind = letters[i]

    local line = {
      multicolumn = true,
      no_gap = true,
      content = "fit",
      group = "recent_files",
      cmd = "e " .. path,
      keys = keybind,
    }

    table.insert(line, { txt = icon .. "  ", hl = devicon_hl })
    table.insert(line, { txt = path })
    table.insert(line, { txt = string.rep(" ", 3), pad = "full" })
    table.insert(line, { txt = keybind, hl = "comment" })

    table.insert(tb, line)
  end
end

local function set_recent_folders(tb)
  local dirs = vim.g.RECENT_PROJECTS or {}
  dirs = vim.list_slice(dirs, 0, 5)

  for i, v in ipairs(dirs) do
    local path = replace_home_path(v):sub(1, 100)
    local keybind = letters[i + 5]

    local line = {
      keys = keybind,
      multicolumn = true,
      no_gap = true,
      content = "fit",
      group = "recent_files",
      cmd = "Lazy",
    }

    table.insert(line, { txt = "  ", hl = "nviminternalError" })
    table.insert(line, { txt = path })
    table.insert(line, { txt = string.rep(" ", 3), pad = "full" })
    table.insert(line, { txt = keybind, hl = "comment" })

    table.insert(tb, line)
  end
end

M.nvdash = {
  buttons = function()
    local layout = {

      {
        multicolumn = true,
        pad = 3,
        content = "fit",
        { txt = "  Update [u]", hl = "changed", keys = "u", cmd = ":Lazy sync <cr>" },
        { txt = "  Files [f]", hl = "Added", keys = "f", cmd = ":Telescope find_files <cr>" },
        { txt = "  Config [c]", hl = "nviminternalError", keys = "c", cmd = ":e ~/.config/nvim/init.lua <cr>" },
        { txt = "󱥚  Themes [t]", keys = "t", cmd = ":Telescope themes <cr>" },
      },

      {
        txt = function()
          local stats = require("lazy").stats()
          local ms = math.floor(stats.startuptime) .. " ms"
          return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
        end,
        hl = "comment",
        content = "fit",
      },

      {
        txt = "  Most Recent files",
        hl = "floatborder",
        no_gap = true,
        group = "recent_files",
      },

      { txt = "─", hl = "comment", no_gap = true, rep = true, group = "recent_files", content = "fit" },
    }

    set_recent_files(layout)
    table.insert(layout, { txt = "", no_gap = true })

    table.insert(layout, {
      txt = "  Recent Projects",
      hl = "String",
      no_gap = true,
      group = "recent_files",
    })

    table.insert(
      layout,
      { txt = "─", hl = "comment", no_gap = true, rep = true, group = "recent_files", content = "fit" }
    )

    set_recent_folders(layout)

    return layout
  end,
  load_on_startup = true,

  header = {
    -- [[                                                   ]],
    -- [[                                              ___  ]],
    -- [[                                           ,o88888 ]],
    -- [[                                        ,o8888888' ]],
    -- [[                  ,:o:o:oooo.        ,8O88Pd8888"  ]],
    -- [[              ,.::.::o:ooooOoOo:. ,oO8O8Pd888'"    ]],
    -- [[            ,.:.::o:ooOoOoOO8O8OOo.8OOPd8O8O"      ]],
    -- [[           , ..:.::o:ooOoOOOO8OOOOo.FdO8O8"        ]],
    -- [[          , ..:.::o:ooOoOO8O888O8O,COCOO"          ]],
    -- [[         , . ..:.::o:ooOoOOOO8OOOOCOCO"            ]],
    -- [[          . ..:.::o:ooOoOoOO8O8OCCCC"o             ]],
    -- [[             . ..:.::o:ooooOoCoCCC"o:o             ]],
    -- [[             . ..:.::o:o:,cooooCo"oo:o:            ]],
    -- [[          `   . . ..:.:cocoooo"'o:o:::'            ]],
    -- [[          .`   . ..::ccccoc"'o:o:o:::'             ]],
    -- [[         :.:.    ,c:cccc"':.:.:.:.:.'              ]],
    -- [[       ..:.:"'`::::c:"'..:.:.:.:.:.'               ]],
    -- [[     ...:.'.:.::::"'    . . . . .'                 ]],
    -- [[    .. . ....:."' `   .  . . ''                    ]],
    -- [[  . . . ...."'                                     ]],
    -- [[  .. . ."'                                         ]],
    -- [[ .                                                 ]],
    -- [[                                                   ]],

    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣶⣶⣶⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⣿⣿⣿⣿⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⡿⠃⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⠿⠋⢀⣀⣀⣀⣀⣤⣤⣶⣿⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⠟⢋⣉⣁⣉⣥⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⣴⣿⣿⣿⣿⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⣠⣾⣿⣿⠿⠛⠉⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠛⠻⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⣴⡿⠟⠉⠀⠀⠀⠀⠀⠀⣽⣿⡿⠻⢿⣿⣿⣿⣿⣿⣿⣿⠀⢀⣤⠈⣿⣿⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⢀⣾⠏⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⠀⠀⣀⠙⣿⣿⣿⣿⣿⣿⠀⠸⣿⣷⣿⣿⠟⠀⠀⠀⠀⠀⠀⣀⣀⣀⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣀⡀⠀⠀]],
    [[⠀⢠⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⡀⢸⣿⣧⣿⣿⣿⣿⣿⣿⣦⣴⣿⣿⠟⠉⣀⣤⣤⣶⠶⠿⠛⠛⠛⠉⠉⠉⠁⠀⠀⠀⠀⠀⠉⠉⠛⠿⣷⡄]],
    [[⢠⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⣠⣶⣤⣭⣭⣤⣄⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣽⡇]],
    [[⢸⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣉⠙⠿⣿⣿⣿⣿⡿⠟⢡⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⡷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⠟⠀]],
    [[⠘⢿⣧⣀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣤⣴⡾⠟⠋⠁⣀⣤⣤⣤⣤⣴⣶⣿⣿⣿⣿⣷⣦⡀⠀⠀⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⠟⠁⠀⠀]],
    [[⠀⠀⠉⠛⠿⠷⣶⣶⣶⣶⡶⠿⠟⠛⠉⠁⠀⠀⢠⣾⣿⡿⠟⠛⠉⢻⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⠟⠁⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠀⠀⠀⠀⠈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⡀⠀⠀⠀⠀⠀⠀⣠⣴⡿⠋⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀⢀⣤⣶⡿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⣿⣿⣿⣿⣿⢹⣿⣿⣿⣿⣿⣿⣷⠘⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⡆⢻⣿⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣟⢿⣿⣿⣿⣿⣿⣷⡄⠹⢿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠙⠿⣦⡙⢿⣿⣿⣿⣿⣿⣦⡄⠙⠛⢿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣶⣤⣄⠀⠈⠙⠛⠛⠛⠉⠀⠀⠀⠈⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢿⡿⣿⣯⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠙⠛⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣻⣿⣿⣹⡿⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠃⠻⠿⠃⠁⠀⠀⠀⠀⠀⠀⠀⠀]],

    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣶⣶⣤⣄⣀⣀⠀⢀⣀⣀⣠⣤⣤⣴⣶⣶⣶⣶⣿⣿⣿⣿⣿⡿⠋]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢶⣶⣤⣤⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠉⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠛⠁⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡟⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠰⣦⣼⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣋⣁⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⠀⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠋⠁⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠋⠀]],
    -- [[⠀⠀⠀⠀⣠⣾⣿⣿⣿⣷⣶⣶⣦⣤⣤⡀⠀⠀⢿⣷⣄⣹⣿⣿⣿⣿⣿⡿⠟⡿⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠋⠀⠀⠀⠀]],
    -- [[⠀⠀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠈⠻⣿⣿⣿⣿⣿⣿⣿⣤⣤⣅⣀⣀⣀⡀⣀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠛⠉⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⡀⣿⣿⣿⣿⠟⣿⣿⣿⣿⣿⣿⣿⠿⠃⠀⠀⠀⠀⢻⠛⠛⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⠛⠋⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣛⡁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⣾⣧⢿⣿⠏⠀⢸⣿⣿⣿⡿⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⢰⠀⠀⠈⠿⠁⠀⠀⠀⠀⠈⠿⠁⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠋⠁⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠈⠻⡎⠟⠀⠀⠈⢿⣿⡟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠁⠀⠀⠀⠀⠀⠙⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠛⢦⣄⡀⠀⠀⠀⠀⠀⠀⣀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠻⢿⣶⣶⣶⣶⣿⣿⡿⢟⣫⣭⣟⠿⣿⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢙⣵⣮⣭⣷⣾⣿⣿⣿⣿⣷⡜⣿⣿⣿⣿⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⢹⣿⣿⣿⣿⡎⠳⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⢻⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⠟⠉⠀⣴⣿⣿⣿⣿⠿⢿⣿⣿⣿⣿⡇⠈⠙⠻⢿⣿⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠃⠀⠀⢰⣿⣿⣿⠟⠁⠀⠀⣿⣿⣿⣿⠁⠀⠀⠀⠀⠀⠉⠙⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⠏⠀⠀⠀⢠⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⡏⠀⠀⠀⠀⢸⣿⡿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠘⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],

    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠈⠻⣦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡆⠀⠀⠈⠻⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⡇⠀⠀⠀⠀⠈⠙⢷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠙⢷⣄⠀⣿⣷⣄⢀⣤⡀⠀⠀⢀⣀⣤⣶⡶⠿⢛⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣬⠻⣿⡟⣿⣶⠾⠛⠋⠉⠀⠀⢠⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⢀⣸⡿⣶⣄⣀⠀⠀⠀⠀⠸⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣧⣤⣴⣶⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⢿⣟⠛⠋⠀⠉⠛⠿⣦⣄⠀⠀⣿⠀⠀⠀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣯⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣄]],
    -- [[⢀⣽⡷⠀⠀⠀⠀⠀⠈⠙⠻⣶⣿⣤⣶⠟⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠉⠉⠉⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⢀⣨⡿⠋]],
    -- [[⠘⠻⢷⣦⡀⠀⠀⠀⠀⠀⠀⢠⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⡿⠋⠀⠀]],
    -- [[⠀⠀⠀⠹⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣴⠟⠉⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠹⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⢿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⠟⠁⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠹⣷⣠⡿⠀⠀⠀⠀⠀⠀⢠⣿⠃⠘⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⡾⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⣸⡟⠀⠀⠀⠀⡀⠀⠀⣾⡇⠀⠀⢹⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣴⠾⠀⠀⠀⠀⠀⣿⣄⣴⠟⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⢀⣿⠁⠀⠀⠀⠀⣿⡄⠀⢹⣧⠀⠀⢸⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⡶⠟⠋⣿⠀⠀⠀⠀⠀⠀⢸⣿⣁⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⢸⡏⠀⠀⠀⠀⠀⣿⢿⣄⠀⠙⢷⣤⣄⣈⣿⡀⠀⠀⠀⠀⠀⠀⢀⣤⣾⠟⠋⠀⠀⢸⡿⠀⠀⠀⠀⠀⠀⢸⡏⠉⠉⠙⠛⠛⠛⠛⠛⠷⣶⣶⡄⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⣾⡇⠀⠀⠀⠀⠀⣿⠈⠻⣦⣄⠀⠈⠉⠉⠉⠁⠀⠀⠀⠀⣠⣾⠟⠙⠏⠀⠀⠀⣠⡿⠁⠀⠀⠀⠀⠀⠀⠸⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢻⣶⡄⠀]],
    -- [[⠀⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⣿⡄⢠⡿⠛⢷⣦⣄⡀⠀⠀⠀⠀⠀⠀⠉⠙⠿⢶⣦⣴⣶⠾⠋⠀⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣸⡟⠋⠁⠀]],
    -- [[⠀⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⠘⣿⣼⠇⠀⠀⠈⣽⠟⠷⢶⣤⣤⣀⣀⡀⠀⠀⠀⠀⠀⣀⣀⣤⣾⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣴⠾⠛⠛⠻⠃⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⣸⣇⠀⠀⠀⠀⠀⠀⠈⠻⣦⣀⠀⢰⡿⠀⠀⠀⠀⠉⠙⣿⠟⠛⠛⠛⢻⡿⠛⢫⣿⠃⠀⠀⠀⠀⠀⢠⣿⣀⣠⣴⡶⠿⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⣼⡿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠈⠻⢷⣾⣇⠀⠀⠀⠀⠀⢠⣿⠀⠀⠀⠀⣼⣇⣴⠟⠁⠀⠀⠀⠀⠀⠀⣼⠟⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⢰⡿⠀⠹⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠿⢶⣦⣤⣄⣼⣇⣀⣠⣤⣴⠿⠛⠁⠀⠀⠀⠀⠀⠀⠀⣼⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⢸⡇⠀⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠉⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠸⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢶⣦⣄⣾⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠻⣷⡀⠀⠀⠀⠘⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠙⠻⣷⣤⡀⢀⣈⣻⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠈⢿⣧⣮⣿⣿⣿⠙⠿⣶⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠙⠛⠁⠀⠀⠀⠀⠉⠛⣿⣷⣶⣶⣶⣶⡶⢶⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣷⣄⣼⡟⠀⠀⠻⣧⠀⢀⠊⠢⠔⢱⡀⡀⣠⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠁⠀⠀⠀⢻⣇⠀⠀⠀⠀⠀⢀⣾⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣷⣤⣤⣴⡾⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],

    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⠶⠒⢦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⠶⠶⠞⠉⠀⠀⠀⠉⠙⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠳⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢷⣄⠀⢀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠈⠉⠛⣦⠀⣠⣤⣄⣀⣠⠤⠞⠋⠛⠛⠛⠉⠙⠛⢶⣄⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⣀⣀⣀⡀⢀⣤⣄⡀⢀⣶⢤⣀⣉⣯⣍⡁⠀⠙⡆⠀⠀⠀⠀⠀⠀⠀⠀⣿⡀⢿⡀⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⡆⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⣠⠞⠋⠉⠉⠛⣾⣇⡀⠙⠋⠁⠀⠈⠁⠀⠈⠙⠒⠚⠁⠀⠀⠀⠀⠀⠀⠀⠀⠈⠳⠾⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⡄⠀⠀⠀]],
    -- [[⠀⠀⠀⢰⠏⠀⠀⠀⠀⢀⣾⠈⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⡤⠴⠚⠛⠛⠛⠛⠛⠓⠲⠤⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣷⠀⠀⠀]],
    -- [[⠀⠀⠀⢸⣄⠀⢠⡴⠶⣫⡷⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⣠⠖⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠳⢦⡀⠀⠀⣰⠀⠀⠀⠀⠀⠀⠀⢀⣾⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠻⠷⠋⢀⡾⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠞⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢦⣠⡟⣧⠀⠀⠀⠀⢾⡗⠛⠋⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠘⢧⣀⣀⣀⣀⡀⠀⠀⠀⣠⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡿⠀⠙⣆⠀⠀⠀⠈⢷⡄⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⢀⣤⣄⡀⠀⠈⣿⠀⠀⢰⡏⠈⠙⠶⣆⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡼⠃⠀⠀⢹⡄⠀⠀⠀⠀⣷⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⢀⡾⠁⠀⠙⠓⠒⠋⠀⢠⣿⡇⠀⠀⠀⠀⠙⠲⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⠇⠀⠀⠀⠸⣇⠀⠀⢀⡼⠏⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⣰⠟⠁⠀⠀⠀⠀⠀⠀⠀⣾⢸⡇⠀⠀⠀⠀⠀⠀⠈⠙⠷⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⠏⡀⠀⠀⠀⠀⢹⠀⠀⣿⡀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⢰⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⡏⠸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⢈⠙⠶⣄⡀⠀⠀⠀⠀⠀⠀⣰⠏⢸⡇⠀⠀⠀⠀⢸⡇⠀⠈⠻⣇⠀⠀⠀⠀]],
    -- [[⣠⡶⠶⠖⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⢳⡀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠈⠙⢶⣄⠀⠀⠀⢼⣟⠀⠈⠉⠀⠀⠀⢀⣾⠀⠀⠀⠀⠙⠳⢶⣄⠀]],
    -- [[⢿⡇⠀⠀⠀⣠⠞⠛⠻⣦⠀⠀⠀⠀⠘⣷⠀⠈⢷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⠀⣸⠏⠁⠀⠀⠀⢻⣄⠀⠀⠀⠀⣤⣾⡇⠀⠀⠀⠀⠀⠀⣠⡿⠀]],
    -- [[⠈⠛⠒⠶⢿⣥⣄⣀⡀⣿⠀⠀⠀⠀⠀⢹⡄⠀⠀⠙⠷⣄⡀⠀⠀⠀⠀⠀⠀⠀⣠⡾⠋⠀⠀⠀⠀⠀⠀⠙⠳⠶⢾⣟⡇⣸⠃⢠⡾⣆⠀⠀⢀⣿⠁⠀]],
    -- [[⠀⠀⠀⣼⠉⠀⠀⠉⣧⠙⣦⡀⠀⠀⠀⠈⢧⡀⠀⠀⠀⠈⠉⠓⠲⠶⠶⠶⠖⠋⠁⠀⠀⠀⠀⠀⠀⠀⣀⣠⡴⣾⣟⡇⣰⠏⠀⣼⣀⠿⣄⠀⣰⡟⠀⠀]],
    -- [[⠀⠀⠀⢻⣄⠀⢀⣼⠃⠀⢸⠇⠀⠀⠀⠀⠈⢣⡀⠀⠀⠀⠀⢾⣄⡀⠀⠀⠀⠀⠀⣀⣠⣤⡤⠶⠚⠋⠁⣤⠴⠋⢹⣿⠟⠀⠀⠈⠙⣻⡎⠙⠃⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠈⢛⣉⡀⠀⠀⢸⡆⠀⠀⠀⠀⠀⠀⠙⢦⡀⠀⠀⠈⠛⢿⡉⣿⣋⡉⠉⠁⣀⣀⣀⡤⠶⠚⠋⠀⠀⢀⡾⠋⠀⠀⢠⣶⡿⠛⠁⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⣿⠉⠙⠓⠶⠞⠁⠀⠀⠀⠀⠀⠀⠀⠀⠙⢦⣀⠀⠀⠈⠿⠋⠉⠉⠉⠉⠉⠉⠁⠀⠀⠀⠀⣠⡴⠋⠀⣴⣦⣀⡾⠉⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠹⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠶⣤⣄⡀⠀⠀⠀⠀⠀⠀⠀⣀⣤⠴⠛⠁⠀⠀⠀⠻⣦⣤⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠙⢦⣀⣀⣀⣀⡤⠴⠶⢦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠙⠛⠛⠛⠛⠋⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠁⠀⠀⠀⠀⠻⣆⣀⣠⡴⠶⠦⣄⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣶⢶⣦⠀⠀⠈⢷⣄⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢈⣵⠛⠛⠳⡆⠀⠀⢹⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣧⡾⠁⠀⠀⠀⠀⣽⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⢠⡟⡴⠛⠋⠀⠀⠀⢀⣤⠞⠛⠛⠛⠛⠦⣤⡀⢠⡟⣧⠀⢀⣤⠼⠞⠋⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⢦⣀⣠⠾⠀⣧⣀⡤⠖⠒⠊⠉⠁⠀⠀⠀⠀⠀⠀⠀⠙⠋⠀⠙⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠁⠀⠀⠈⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],

    -- "    NvChad                       ",
    -- "       ▄▄         ▄ ▄▄▄▄▄▄▄      ",
    -- "     ▄▀███▄     ▄██ █████▀       ",
    -- "     ██▄▀███▄   ███              ",
    -- "     ███  ▀███▄ ███              ",
    -- "     ███    ▀██ ███              ",
    -- "     ███      ▀ ███              ",
    -- "     ▀██ █████▄▀█▀▄██████▄       ",
    -- "       ▀ ▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀      ",
    -- "          Powered by Neovim      ",

    -- [[                @@@%%%%%%%%%@@                ]],
    -- [[              @@@%%%%%%%%%#######%@@          ]],
    -- [[            @@@@%%%%%%%######?######%@        ]],
    -- [[            @@@@%%%%%%%#######:########%@     ]],
    -- [[          @@@@@%%%%%%#########:??#######%     ]],
    -- [[          @@@%%%%%####???###?+:??####?###@    ]],
    -- [[        @@@%%%%%%#?+???###?:+?##??###?##@     ]],
    -- [[      @??%@%%%##????????++:;+?+????????#@     ]],
    -- [[      #  ;?%#?+; ..::+?+ ::;++++++?+???#      ]],
    -- [[      %  :?%;;;:  ....:#+ :;+++????+???@      ]],
    -- [[      #;;+??+++:   ...;##: ;;;++???++?%       ]],
    -- [[      %#%+::++?#+;:::;?##+ ;;;;++??++#        ]],
    -- [[      %?% : :???+?++???######?+;;+??#         ]],
    -- [[      @%# ; ;??;;+ ;???+;;:..::.:+?%          ]],
    -- [[        @???;;?+;;;+ ;:;;......;;;#@          ]],
    -- [[        %##?++?+++;+ ??% @%%@@@@              ]],
    -- [[        @_:?_:+_:_:#%                         ]],
    -- [[                                              ]],

    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⢶⡶⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⠟⠁⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡾⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣴⣶⣿⣿⣿⣿⣿⣷⣾⣶⣶⢂⣴⠿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣤⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢋⡴⠋⠁⠀⠀⠀⢀⣴⣶⣤⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣋⠒⠁⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣷⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⣡⡾⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢟⣱⡦⠋⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀ ⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⢵⠿⠋⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⠈⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠋⠀⠀⠀⠀⠀⠀⠀⢀⢴⣿⠟⠿⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⡀⠀⠀⠀⠀⠀⠀⣠⡶⠶⣿⡍⣆⠗⢨⠄⠉⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣯⠀⠀⠀⠀⣀⣌⠻⡷⠮⠻⡇⣏⣰⡥⠄⠀⠀⠀⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠐⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣻⡟⠉⠁⣀⠀⢀⣼⣿⠟⠁⠀⢃⠀⢡⠞⠛⣠⣶⣠⡀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⣰⣿⣿⢻⣿⠏⡴⠀⣰⠏⠀⠀⠚⠙⠛⣿⡿⢿⡀⠂⠀⠀⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀]],
    -- [[⠀⠀⠀⣿⣿⣏⢟⡩⢹⣿⣟⡿⣋⣴⣷⠀⠀⠸⣻⠏⠐⡟⢘⣁⡼⠃⠀⠀⠀⠀⠤⠗⠛⠓⠒⠛⠂⠀⠀⠀⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡗⠀⠀⠀]],
    -- [[⠀⠀⠀⣿⣿⣿⣷⢬⣿⠇⣩⣾⣿⣿⣿⡖⠀⠀⠁⠀⠀⣿⡵⠛⠀⣠⣄⣀⡀⠀⠀⠀⢘⡽⠁⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣗⠀⠀⠀]],
    -- [[⠀⠀⠀⣿⣿⣿⣷⡛⠁⣰⣿⣿⣿⣿⣿⣿⡃⠀⠀⠀⢀⣫⣥⠀⣴⣿⣿⣿⠿⠿⠟⠀⢸⡃⠀⡅⠀⠀⠀⠀⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀]],
    -- [[⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣤⣄⣤⣿⡿⠟⠘⠛⠉⠉⠀⢀⠀⡀⡆⢹⣽⡈⠀⣠⣾⠇⠀⠀⠀⠈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣶⠤⠀⠀⣀⠾⠼⠲⠃⠉⢏⠃⠀⠀⣿⣿⡃⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣿⣿⡏⡅⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⠃⠀⠀⠹⠉⠁⠀⠀⠀⠀⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣄⡀⠀⠀⠀⣀⣤⣶⣾⣧⣀⡿⠀⠀⠀⠀⠀⣆⠀⠀⠀⠀⠀⠈⣿⣿⣿⣿⣿⣿⣿⡿⢻⣿⡟⠀⠀⠀ ⠀]],
    -- [[⠀⠀⠀ ⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⣿⠃⠀⠀⠰⠂⠀⠆⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⠻⣿⣷⣿⡟⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⠘⠟⠀⠀⠠⠠⠀⠀⠀⠀⠂⠀⠀⠀⠀⠀⢻⣭⣿⣿⣧⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣿⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⢻⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⡿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠙⠿⣿⣿⣿⣟⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠿⠿⢿⠿⠷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
  },
}

return M
