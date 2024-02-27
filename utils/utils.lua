local M = {}

--- Gets the buffer number of every visible buffer
--- @return integer[]
function M.visible_buffers()
  return vim.tbl_map(vim.api.nvim_win_get_buf, vim.api.nvim_list_wins())
end

--- Close every floating window
function M.close_floating_windows()
  for _, win in pairs(vim.api.nvim_list_wins()) do
    -- Sometimes the window doesn't exist anymore for some reason
    local success, win_config = pcall(vim.api.nvim_win_get_config, win)
    if success and vim.tbl_contains({'win', 'editor'}, win_config.relative) then
      vim.api.nvim_win_close(win, false)
    end
  end
end

function M.plugin_is_loaded(plugin)
  -- Checking with `require` and `pcall` will cause Lazy to load the plugin
  local plugins = require('lazy.core.config').plugins
  return not not plugins[plugin] and plugins[plugin]._.loaded
end

return M
