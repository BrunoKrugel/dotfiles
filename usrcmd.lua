local create_cmd = vim.api.nvim_create_user_command

create_cmd("PeekOpen", function()
  require("peek").open()
end, {})

create_cmd("PeekClose", function()
  require("peek").close()
end, {})

create_cmd("Nvtfloat", function()
  require("nvterm.terminal").toggle "float"
end, {})

-- Toggle colorcolumn display
create_cmd("CCToggle", function()
  vim.g.ccenabled = not vim.g.ccenabled
  if vim.g.ccenabled then
    vim.opt.colorcolumn = "120"
    vim.g.virtcolumn_char = "┊"
  else
    vim.opt.colorcolumn = "0"
  end
end, {})

create_cmd("AutosaveToggle", function()
  vim.g.autosave = not vim.g.autosave

  if vim.g.autosave then
    vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
      group = vim.api.nvim_create_augroup("Autosave", {}),
      callback = function()
        if vim.api.nvim_buf_get_name(0) and #vim.bo.buftype == 0 then
          vim.cmd "silent w"
          vim.api.nvim_echo(
            { { "󰄳", "LazyProgressDone" }, { " file autosaved at " .. os.date "%I:%M %p" } },
            false,
            {}
          )

          -- clear msg after 500ms
          vim.defer_fn(function()
            vim.api.nvim_echo({}, false, {})
          end, 800)
        end
      end,
    })
  else
    vim.api.nvim_del_augroup_by_name "Autosave"
  end
end, {})