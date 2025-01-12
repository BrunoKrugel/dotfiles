local map = vim.keymap.set
local api = vim.api

local function handler(_, result, ctx)
  if result ~= nil then
    if result.contents ~= nil then
      local content = result.contents.value
      if content ~= nil then
        if not vim.startswith(content, "```go") then
          content = "```go\n" .. content .. "```"
        end
        local mode = api.nvim_get_mode().mode
        if mode == "v" or mode == "V" then
          api.nvim_feedkeys(api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
        end
        local bufnr, winid = vim.lsp.util.open_floating_preview({ content }, "markdown")
        api.nvim_set_current_win(winid)
      end
    end
  end
end

local function golang_goto_def()
  local old = vim.lsp.buf.definition
  local opts = {
    on_list = function(options)
      if options == nil or options.items == nil or #options.items == 0 then
        return
      end
      local targetFile = options.items[1].filename
      local prefix = string.match(targetFile, "(.-)_templ%.go$")
      if prefix then
        local function_name = vim.fn.expand "<cword>"
        options.items[1].filename = prefix .. ".templ"
        vim.fn.setqflist({}, " ", options)
        vim.api.nvim_command "cfirst"
        vim.api.nvim_command("silent! /templ " .. function_name)
      else
        old()
      end
    end,
  }
  vim.lsp.buf.definition = function(o)
    o = o or {}
    o = vim.tbl_extend("keep", o, opts)
    old(o)
  end
end

local function gopls_extract_all()
  local mode = vim.api.nvim_get_mode().mode

  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  if mode == "v" or mode == "V" then
    local range = vim.lsp.buf.range_from_selection(0, mode)
    local params = vim.lsp.util.make_given_range_params(range.start, range["end"], 0, "utf-8")
    params.context = { only = { "refactor.extract.variable-all" } }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
    for _, res in pairs(result or {}) do
      for _, action in pairs(res.result or {}) do
        if action.data and action.data.arguments then
          -- Resolve the code action using gopls' expected structure
          vim.lsp.buf_request(0, "codeAction/resolve", action, function(err, resolved_action)
            if err then
              vim.notify("Error resolving code action: " .. err.message, vim.log.levels.ERROR)
              return
            end
            if resolved_action.edit then
              vim.lsp.util.apply_workspace_edit(resolved_action.edit, "utf-8")
              -- Find the first occurrence of newText edits
              local edits = resolved_action.edit.changes or resolved_action.edit.documentChanges
              local ranges = {}
              for _, edit in ipairs(edits) do
                for i, e in pairs(edit) do
                  for _, item in ipairs(e) do
                    table.insert(ranges, item.range)
                  end
                end
              end
              local minimal_distance = 1000000000
              local which_one = {}
              for _, rang in ipairs(ranges) do
                local start_row, start_col = rang.start.line, rang.start.character
                if
                  start_row == row - 1
                  and not (start_row == rang["end"].line and start_col == rang["end"].character)
                then
                  if start_col < minimal_distance then
                    which_one = { row, start_col }
                    minimal_distance = start_col
                  end
                end
              end
              api.nvim_feedkeys(api.nvim_replace_termcodes("<esc>", true, false, true), "n", false)
              vim.api.nvim_win_set_cursor(0, { which_one[1] + 1, which_one[2] })
              api.nvim_feedkeys(api.nvim_replace_termcodes("<leader>rn", true, false, true), "m", false)
            end
          end)
        end
      end
    end
  end
end

map("x", "<leader>re", function()
  gopls_extract_all()
end, { buffer = true })

map("v", "<Tab>", function()
  local mode = api.nvim_get_mode().mode
  if mode == "v" or mode == "V" then
    local o_range = require("vim.lsp.buf").range_from_selection(0, mode)
    local param = vim.lsp.util.make_position_params(0, nil)
    local range = {}
    range["end"] = {}
    range["start"] = {}
    range["end"].line = o_range["end"][1] - 1
    range["end"].character = o_range["end"][2]
    range["start"].line = o_range["start"][1] - 1
    range["start"].character = o_range["start"][2]
    param.range = range
    vim.lsp.buf_request(0, "textDocument/hover", param, handler)
  end
end, { buffer = true })
