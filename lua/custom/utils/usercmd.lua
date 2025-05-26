---@diagnostic disable: need-check-nil
local create_cmd = vim.api.nvim_create_user_command
-- local settings = require("chadrc").settings
local g = vim.g
local fn = vim.fn

local function setAutoCmp(mode)
  if mode then
    require("cmp").setup {
      completion = {
        autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged },
      },
    }
  else
    require("cmp").setup {
      completion = {
        autocomplete = false,
      },
    }
  end
end

local function yank_file_path(expr)
  fn.setreg("+", fn.expand(expr))
  vim.notify("Yanked file path: " .. fn.getreg "+")
end

create_cmd("YankPath", function()
  yank_file_path "%"
end, { desc = "Yank current file's path relative to cwd" })

create_cmd("YankPathFull", function()
  yank_file_path "%:~"
end, { desc = "Yank current file's absolute path" })

create_cmd("DapUiOpen", ":lua require'dapui'.open()", {})
create_cmd("DapUiClose", ":lua require'dapui'.close()", {})
create_cmd("DapUiToggle", ":lua require'dapui'.toggle()", {})
create_cmd("DapUiFloatElement", ":lua require'dapui'.float_element()", {})
create_cmd("DapUiWidget", ":lua require'dap.ui.widgets'.hover()", {})
create_cmd("DapUiEval", ":lua require'dapui'.eval()", {})

create_cmd("Http", function()
  require("kulala").run()
end, {})

create_cmd("ToggleInlayHints", function()
  ---@diagnostic disable-next-line
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toogle inlay hints in current buffer" })

-- Command to toggle inline diagnostics
create_cmd("ToggleVirtualText", function()
  local current_value = vim.diagnostic.config().virtual_text
  if current_value then
    vim.diagnostic.config { virtual_text = false }
  else
    vim.diagnostic.config { virtual_text = true }
  end
end, {})

create_cmd("Format", function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end

  local opts = {
    bufnr = args.buf,
    timeout_ms = 1000,
    async = false,
    quiet = false,
    lsp_format = "fallback",
    range = range,
  }
  require("conform").format(opts)
end, { range = true })

-- -- Toggle colorcolumn
-- create_cmd("TCC", function()
--   vim.g.ccenable = not vim.g.ccenable

--   if vim.g.ccenable then
--     vim.opt.cc = settings.cc_size
--   else
--     vim.opt.cc = "0"
--   end
-- end, {})

-- Open DapUi
create_cmd("TDebug", function()
  require("dapui").toggle()
end, {})

-- Toggle CMP
g.cmptoggle = true
create_cmd("CmpToggle", function()
  g.cmptoggle = not g.cmptoggle
  if g.cmptoggle then
    vim.cmd 'echo  "CmpAutoComplete is on"'
    setAutoCmp(true)
  else
    vim.cmd 'echo  "CmpAutoComplete is off"'
    setAutoCmp(false)
  end
end, {})

create_cmd("Confetti", function()
  os.execute "open -g 'raycast://extensions/raycast/raycast/confetti'"
end, {})

create_cmd("Debug", function()
  require("dapui").toggle()
  require("dap").run {
    type = "go",
    name = "Debug: Go",
    request = "launch",
    showLog = false,
    program = "${workspaceFolder}/cmd/${workspaceFolderBasename}",
    dlvToolPath = vim.fn.exepath "dlv",
  }
end, {})

create_cmd("Healthcheck", function()
  vim.cmd "checkhealth"
end, {})

create_cmd("TestSummary", function()
  require("neotest").summary.toggle()
end, {})

create_cmd("Coverage", function()
  rrequire("coverage").load(true)
end, {})

create_cmd("GitOpen", function()
  -- Current file
  local git_root = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")
  local file = vim.fn.expand("%:p"):gsub(vim.pesc(git_root .. "/"), "")
  local line = vim.fn.line "."

  -- Git repo things
  local repo_url = vim.fn.system("git -C " .. git_root .. " config --get remote.origin.url")
  local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("\n", "")
  local commit_hash = vim.fn.system("git rev-parse HEAD"):gsub("\n", "")
  local git_ref = branch == "HEAD" and commit_hash or branch

  -- Parse GitHub URL parts
  local ssh_url_captures = { string.find(repo_url, ".*@(.*)[:/]([^/]*)/([^%s/]*)") }
  local _, _, host, user, repo = unpack(ssh_url_captures)
  repo = repo:gsub(".git$", "")

  local github_repo_url =
    string.format("https://%s/%s/%s", vim.uri_encode(host), vim.uri_encode(user), vim.uri_encode(repo))
  local github_file_url = string.format(
    "%s/blob/%s/%s#L%s",
    vim.uri_encode(github_repo_url),
    vim.uri_encode(git_ref),
    vim.uri_encode(file),
    line
  )

  vim.fn.system("open " .. github_file_url)
end, {})

vim.api.nvim_create_user_command("LintInfo", function()
  local filetype = vim.bo.filetype
  local linters = require("lint").linters_by_ft[filetype]

  if linters then
    print("Linters for " .. filetype .. ": " .. table.concat(linters, ", "))
  else
    print("No linters configured for filetype: " .. filetype)
  end
end, {})
