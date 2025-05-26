local M = {}

_G.ClickNotifications = function()
  require("noice").cmd "history"
end

_G.ClickSplit = function()
  vim.cmd "vs"
end

_G.ClickGit = function()
    Snacks.terminal('lazygit')
end

_G.ClickUpdate = function()
  require("base46").load_all_highlights()
  vim.notify "Highlights reloaded!"
end

_G.ClickBranch = function()
  require("telescope.builtin").git_branches { use_file_path = true }
end

return M
