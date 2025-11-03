local map = vim.keymap.set
local api = vim.api
local autocmd = vim.api.nvim_create_autocmd
local create_cmd = vim.api.nvim_create_user_command

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

local function add_tags()
  local struct = vim.fn.expand "<cword>"
  local type = vim.fn.input("Type: ", "json")
  local file = vim.fn.expand "%:p"
  local view = vim.fn.winsaveview()
  local response = vim.fn.systemlist(string.format("gomodifytags -file %s -struct %s -add-tags %s", file, struct, type))
  vim.api.nvim_buf_set_lines(0, 0, -1, true, response)
  vim.fn.winrestview(view)
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

-- jump between test and source file
map("n", "<C-n>", function()
  -- check if a _test.go file exists
  local test_file = vim.fn.expand "%:p:h" .. "/" .. vim.fn.expand "%:t:r" .. "_test.go"
  if vim.fn.filereadable(test_file) == 1 then
    vim.cmd("e " .. test_file)
    return
  end

  -- check if file is a test file
  if string.match(vim.fn.expand "%:t", "_test.go$") then
    local main_file = vim.fn.expand "%:p:h" .. "/" .. string.gsub(vim.fn.expand "%:t:r", "_test", "") .. ".go"
    if vim.fn.filereadable(main_file) == 1 then
      vim.cmd("e " .. main_file)
    end
  end
end, { desc = "Jump between test and source file", silent = true })

create_cmd("GoAddTags", add_tags, { force = true })

local function highlight_go_tags()
  local bufnr = vim.api.nvim_get_current_buf()
  local parser = vim.treesitter.get_parser(bufnr, "go")
  local tree = parser:parse()[1]
  local root = tree:root()
  local queryContent = [[
    (field_declaration
      tag: (raw_string_literal (raw_string_literal_content) @tag.content)
    )
  ]]

  local query = vim.treesitter.query.parse("go", queryContent)
  for id, node in query:iter_captures(root, bufnr, 0, -1) do
    local name = query.captures[id]
    if name == "tag.content" then
      local text = vim.treesitter.get_node_text(node, bufnr)
      -- Now process the text to find keys like "json", "validate", "query"
      for key in text:gmatch "%s*([%w_]+)%s-:%s-" do
        -- Highlight operations using Neovim APIs, e.g., nvim_buf_add_highlight
        local start_row, start_col, _, _ = node:range()
        -- For demonstration, identify the range offset for each key within the text
        local start = text:find(key)
        if start then
          local key_end = start + #key
          -- Convert this relative position to a full buffer range
          api.nvim_buf_add_highlight(
            bufnr,
            -1, -- Your highlight namespace or -1 for new
            "Identifier", -- Assume this or create your linked group
            start_row,
            start_col + start - 1,
            start_col + key_end - 1
          )
        end
      end
    end
  end
end

autocmd({ "BufEnter", "TextChanged", "InsertLeave" }, {
  pattern = "*.go",
  callback = highlight_go_tags,
})
