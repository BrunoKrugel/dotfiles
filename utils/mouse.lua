local M = {}

_G.ClickMe = function()
  require("noice").cmd "history"
end

_G.ClickTerm = function()
  require("nvterm.terminal").toggle "horizontal"
end

_G.ClickSplit = function()
  vim.cmd "vs"
end

_G.ClickGit = function()
  vim.cmd "ToggleBlame"
end

_G.ClickRun = function()
  vim.cmd "CompilerOpen"
end

_G.ClickUpdate = function()
  require("base46").load_all_highlights()
  vim.notify "Highlights reloaded!"
end

return M
