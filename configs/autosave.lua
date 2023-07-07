local present, autoSave = pcall(require, "auto-save")
if not present then
  return
end

autoSave.setup {
  -- The name of the augroup.
  augroup_name = "AutoSavePlug",
  execution_message = {
    message = function()
      return ""
    end,
    dim = 0.18,
    cleaning_interval = 1250,
  },
  events = { "InsertLeave", "TextChanged" },
  silent = true,
  save_fn = function()
    if save_cmd ~= nil then
      vim.cmd(save_cmd)
    elseif silent then
      vim.cmd "silent! w"
    else
      vim.cmd "w"
    end
  end,
}
