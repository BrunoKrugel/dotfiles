local M = {}
local merge_tb = vim.tbl_deep_extend
local breakpoint = 100

local function stbufnr()
  return vim.api.nvim_win_get_buf(vim.g.statusline_winid)
end

require "custom.utils.mouse"

-- 󰞏 on
-- 󱜞 off

-- M.remove_mappings = function(section)
--   vim.schedule(function()
--     local function remove_section_map(section_values)
--       if section_values.plugin then
--         return
--       end

--       for mode, mode_values in pairs(section_values) do
--         for keybind, _ in pairs(mode_values) do
--           local _, _ = pcall(vim.api.nvim_del_keymap, mode, keybind)
--         end
--       end
--     end

--     local mappings = require("core.utils").load_config().mappings

--     if type(section) == "string" then
--       mappings[section]["plugin"] = nil
--       mappings = { mappings[section] }
--     end

--     for _, sect in pairs(mappings) do
--       remove_section_map(sect)
--     end
--   end)
-- end

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

function Get_Version()
  if vim.g.status_version ~= nil then
    return vim.g.status_version
  else
    return ""
  end
end

function Get_Cmp()
  if vim.g.cmptoggle == true then
    return "󰞏  "
  else
    return "󱜞  "
  end
end

function Get_npm()
  local ok, package = pcall(require, "package-info")
  if ok then
    local status = package.get_status()
    if status ~= "" then
      return "  " .. status .. " "
    end
    return ""
  else
    return ""
  end
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
  concurrency = 15,
  git = {
    log = { "-8" },
    timeout = 35,
    url_format = "https://github.com/%s.git",
    filter = true,
  },
}

M.tabufline = {
  show_numbers = false,
  enabled = true,
  lazyload = true,
  modules = {
    buttons = function()
      return "%#SplitHl#%@v:lua.ClickUpdate@  %#SplitHl#%@v:lua.ClickGit@  %#SplitHl#%@v:lua.ClickRun@  %#SplitHl#%@v:lua.ClickSplit@ "
    end,
    harpoon = function()
      local options = {
        icon = "󰀱 ",
        indicators = { "1", "2", "3", "4" },
        active_indicators = { "[1]", "[2]", "[3]", "[4]" },
        separator = " ",
      }
      local list = require("harpoon"):list()
      local root_dir = list.config:get_root_dir()
      local current_file_path = vim.api.nvim_buf_get_name(0)

      local length = math.min(list:length(), #options.indicators)

      local status = {}
      local get_full_path = function(root, value)
        if vim.loop.os_uname().sysname == "Windows_NT" then
          return root .. "\\" .. value
        end

        return root .. "/" .. value
      end

      for i = 1, length do
        local value = list:get(i).value
        local full_path = get_full_path(root_dir, value)

        if full_path == current_file_path then
          table.insert(status, options.active_indicators[i])
        else
          table.insert(status, options.indicators[i])
        end
      end

      -- TODO: Only show if Harpoon is open
      return "%#HarpoonHl# 󰀱 " ..  table.concat(status, options.separator) .. " | "
    end,
  },
  order = {
    "treeOffset",
    "buffers",
    "tabs",
    "harpoon",
    "buttons",
  },
}

M.statusline = {
  theme = "vscode_colored",
  order = {
    "modes",
    "icons",
    "old_git",
    "diagnostics",
    "record",
    "%=",
    "lsp_msg",
    -- "noice",
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

          icon_text = "%#St_" .. icon_hl .. "# " .. icon .. "%#StText# " .. filename .. " "
        end
      end

      return icon_text or ("%#StText# " .. icon .. filename)
    end,

    old_git = function()
      if not vim.b[stbufnr()].gitsigns_head or vim.b[stbufnr()].gitsigns_git_status then
        return "%##"
      end

      return "%#StGit#  " .. vim.b[stbufnr()].gitsigns_status_dict.head .. ""
    end,

    noice = function()
      local status = require("noice").api.status.mode.get()
      if status then
        return "%#NoiceVirtualText#" .. status
      end

      return "%##"
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
      return string.upper(encode) == "" and "" or "%#St_encode#" .. string.upper(encode) .. " "
    end,

    record = function()
      return "%#RecordHl#" .. Get_record()
    end,

    filetype = function()

      if vim.o.columns < breakpoint then
        return ""
      end

      local ft = vim.bo[stbufnr()].ft
      return ft == " " and " %#St_ft# {} plain text  " or " %#St_ft#{} " .. ft .. " "
    end,

    lsp_status = function()
      if rawget(vim, "lsp") then
        for _, client in ipairs(vim.lsp.get_active_clients()) do
          if
            client.attached_buffers[vim.api.nvim_get_current_buf()]
            and (client.name ~= "null-ls" and client.name ~= "copilot")
          then
            local copilot = "%#CopilotHl#" .. require("copilot_status").status_string() .. " "
            local lsp_name = client.name
            if client.name == "typescript-tools" then
              lsp_name = "typescript"
            end
            return (vim.o.columns > 100 and copilot .. "%#St_Lsp# " .. lsp_name) or copilot .. "  LSP"
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

      modes["n"][3] = "  "
      modes["v"][3] = "  "
      modes["i"][3] = "  "
      modes["t"][3] = "  "

      local m = vim.api.nvim_get_mode().mode
      return "%#St_" .. modes[m][2] .. "mode#" .. (modes[m][3] or "  ") .. modes[m][1] .. " "
    end,

    notification = function()
      return "%#NotificationHl# " .. Get_Version() .. "%@v:lua.ClickMe@ " .. " %#CmpHl#" .. Get_Cmp()
    end,

    dap = function()
      return "%#DapHl#" .. Get_dap()
    end,
  },
}

M.nvdash = {
  load_on_startup = true,
  buttons = {
    { "  Find File", "Spc f f", "Telescope find_files" },
    { "󰈚  Recent Files", "Spc f o", "Telescope oldfiles" },
    { "󰈭  Find Word", "Spc f w", "Telescope live_grep" },
    { "  Themes", "Spc t h", "Telescope themes" },
    { "  Mappings", "Spc c h", "NvCheatsheet" },

    function()
      local stats = require("lazy").stats()
      local plugins = "  Loaded " .. stats.count .. " plugins in "
      local time = math.floor(stats.startuptime) .. " ms  "
      return plugins .. time
    end,
  },
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

    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣶⣶⣶⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⣿⣿⣿⣿⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⡿⠃⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⠿⠋⢀⣀⣀⣀⣀⣤⣤⣶⣿⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⠟⢋⣉⣁⣉⣥⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⣴⣿⣿⣿⣿⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⣠⣾⣿⣿⠿⠛⠉⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠛⠻⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⣴⡿⠟⠉⠀⠀⠀⠀⠀⠀⣽⣿⡿⠻⢿⣿⣿⣿⣿⣿⣿⣿⠀⢀⣤⠈⣿⣿⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⢀⣾⠏⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⠀⠀⣀⠙⣿⣿⣿⣿⣿⣿⠀⠸⣿⣷⣿⣿⠟⠀⠀⠀⠀⠀⠀⣀⣀⣀⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣀⡀⠀⠀]],
    -- [[⠀⢠⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⡀⢸⣿⣧⣿⣿⣿⣿⣿⣿⣦⣴⣿⣿⠟⠉⣀⣤⣤⣶⠶⠿⠛⠛⠛⠉⠉⠉⠁⠀⠀⠀⠀⠀⠉⠉⠛⠿⣷⡄]],
    -- [[⢠⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⣠⣶⣤⣭⣭⣤⣄⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣽⡇]],
    -- [[⢸⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣉⠙⠿⣿⣿⣿⣿⡿⠟⢡⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⡷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⠟⠀]],
    -- [[⠘⢿⣧⣀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣤⣴⡾⠟⠋⠁⣀⣤⣤⣤⣤⣴⣶⣿⣿⣿⣿⣷⣦⡀⠀⠀⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⠟⠁⠀⠀]],
    -- [[⠀⠀⠉⠛⠿⠷⣶⣶⣶⣶⡶⠿⠟⠛⠉⠁⠀⠀⢠⣾⣿⡿⠟⠛⠉⢻⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⠟⠁⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠀⠀⠀⠀⠈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⡀⠀⠀⠀⠀⠀⠀⣠⣴⡿⠋⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀⢀⣤⣶⡿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⣿⣿⣿⣿⣿⢹⣿⣿⣿⣿⣿⣿⣷⠘⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⡆⢻⣿⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣟⢿⣿⣿⣿⣿⣿⣷⡄⠹⢿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠙⠿⣦⡙⢿⣿⣿⣿⣿⣿⣦⡄⠙⠛⢿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣶⣤⣄⠀⠈⠙⠛⠛⠛⠉⠀⠀⠀⠈⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢿⡿⣿⣯⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠙⠛⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣻⣿⣿⣹⡿⠀⠀⠀⠀⠀⠀⠀⠀]],
    -- [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠃⠻⠿⠃⠁⠀⠀⠀⠀⠀⠀⠀⠀]],

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

    "  NvChad                     ",
    "     ▄▄         ▄ ▄▄▄▄▄▄▄    ",
    "   ▄▀███▄     ▄██ █████▀     ",
    "   ██▄▀███▄   ███            ",
    "   ███  ▀███▄ ███            ",
    "   ███    ▀██ ███            ",
    "   ███      ▀ ███            ",
    "   ▀██ █████▄▀█▀▄██████▄     ",
    "     ▀ ▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀    ",
    "        Powered by Neovim    ",

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
