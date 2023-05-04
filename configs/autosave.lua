local present, autoSave = pcall(require, "auto-save")
if not present then
  return
end

local silent = true
local save_cmd = nil

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
  -- The events in which to trigger an auto save.
  events = { "InsertLeave", "TextChanged" },

  -- If you'd prefer to silence the output of `save_fn`.
  silent = silent,

  -- If you'd prefer to write a vim command.
  save_cmd = save_cmd,

  -- What to do after checking if auto save conditions have been met.
  save_fn = function()
    if save_cmd ~= nil then
      vim.cmd(save_cmd)
    elseif silent then
      vim.cmd "silent! w"
    else
      vim.cmd "w"
    end
  end,

  -- May define a timeout, or a duration to defer the save for - this allows
  -- for formatters to run, for example if they're configured via an autocmd
  -- that listens for `BufWritePre` event.
  timeout = nil,

  -- Define some filetypes to explicitly not save, in case our existing conditions
  -- don't quite catch all the buffers we'd prefer not to write to.
  exclude_ft = {},
}

