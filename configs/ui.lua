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
  vim.cmd "LazyGit"
end

_G.ClickRun = function()
  vim.cmd "CompilerOpen"
end

_G.ClickUpdate = function()
  require("base46").load_all_highlights()
  vim.notify "Highlights reloaded!"
end

_G.ClickSelect = function()
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

return M
