require("lint").linters.deadcode = {
  cmd = "deadcode",
  stdin = false, -- deadcode does not support stdin
  append_fname = false, -- We will pass `./...` manually
  ignore_exitcode = true,
  args = { "-test", "./..." },
  stream = "stdout",
  parser = function(output, bufnr)
    local diagnostics = {}
    local current_file = vim.api.nvim_buf_get_name(bufnr) -- Absolute path of the current file

    for line in output:gmatch "[^\r\n]+" do
      local file, lnum, col, message = line:match "([^:]+):(%d+):(%d+): (.+)"
      if file and lnum and col and message then
        local absolute_file = vim.fn.fnamemodify(file, ":p")

        -- Only shows diagnostics for the current file
        if absolute_file == current_file then
          table.insert(diagnostics, {
            bufnr = bufnr,
            lnum = tonumber(lnum) - 1, -- Convert to 0-based indexing
            col = tonumber(col) - 1,
            end_lnum = tonumber(lnum) - 1,
            end_col = tonumber(col),
            severity = vim.diagnostic.severity.WARN,
            source = "deadcode",
            message = message,
          })
        end
      end
    end
    return diagnostics
  end,
}

require("lint").linters_by_ft = {
  yaml = {
    "yamllint",
    "actionlint",
  },
  codespell = { "codespell" },
  javascript = { "eslint_d" },
  typescript = { "eslint_d" },
  javascriptreact = { "eslint_d" },
  typescriptreact = { "eslint_d" },
  go = { "deadcode" },
}
