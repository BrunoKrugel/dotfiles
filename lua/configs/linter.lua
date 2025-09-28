-- https://go.dev/blog/deadcode
require("lint").linters.deadcode = {
  cmd = "deadcode",
  stdin = false, -- deadcode does not support stdin
  append_fname = false, -- We will pass `./...` manually
  ignore_exitcode = true,
  args = { "-test", "./..." },
  stream = "stdout",
  name = "deadcode",
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

require("lint").linters.fieldalignment = {
  name = "fieldalignment",
  cmd = "fieldalignment",
  args = { "-json" },
  stdin = false,
  stream = "stdout",
  ignore_exitcode = true,
  parser = function(output, bufnr)
    if output == "" then
      return {}
    end
    local decoded = vim.json.decode(output, { luanil = { object = true, array = true } })
    local diagnostics = {}
    for _, issues in pairs(decoded) do
      for _, issue_list in pairs(issues) do
        for _, issue in ipairs(issue_list) do
          local pos = issue.posn
          local _, lnum, col = pos:match "^(.+):(%d+):(%d+)$"
          lnum = tonumber(lnum) or 1
          col = tonumber(col) or 1
          local message = issue.message
          local suggested_fix = ""
          if issue.suggested_fixes and #issue.suggested_fixes > 0 then
            local fix = issue.suggested_fixes[1]
            if fix.edits and #fix.edits > 0 then
              suggested_fix = fix.edits[1].new
              suggested_fix = suggested_fix:gsub("\n", "\n\t"):gsub("\t", "  ")
              message = message .. "\nSuggested struct:\n" .. suggested_fix
            end
          end
          table.insert(diagnostics, {
            bufnr = bufnr,
            lnum = lnum - 1,
            col = col - 1,
            end_lnum = lnum - 1,
            end_col = col - 1,
            severity = vim.diagnostic.severity.WARN,
            message = message,
            source = "fieldalignment",
          })
        end
      end
    end
    return diagnostics
  end,
}

require("lint").linters_by_ft = {
  dockerfile = { "hadolint" },
  javascript = { "eslint_d" },
  typescript = { "eslint_d" },
  javascriptreact = { "eslint_d" },
  typescriptreact = { "eslint_d" },
  -- go = { "deadcode", "fieldalignment", "staticcheck" },
  go = { "staticcheck" },
}
