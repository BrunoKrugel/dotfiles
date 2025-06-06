require("auto-save").setup {
  -- The name of the augroup.
  augroup_name = "AutoSavePlug",
  events = { "InsertLeave" },
  silent = true,
  callbacks = {
    before_saving = function()
      -- save global autoformat status
      vim.g.OLD_AUTOFORMAT = vim.g.autoformat_enabled

      vim.g.autoformat_enabled = false
      vim.g.OLD_AUTOFORMAT_BUFFERS = {}
      -- disable all manually enabled buffers
      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.b[bufnr].autoformat_enabled then
          table.insert(vim.g.OLD_BUFFER_AUTOFORMATS, bufnr)
          vim.b[bufnr].autoformat_enabled = false
        end
      end
    end,
    after_saving = function()
      -- restore global autoformat status
      vim.g.autoformat_enabled = vim.g.OLD_AUTOFORMAT
      -- reenable all manually enabled buffers
      for _, bufnr in ipairs(vim.g.OLD_AUTOFORMAT_BUFFERS or {}) do
        vim.b[bufnr].autoformat_enabled = true
      end
    end,
  },
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
