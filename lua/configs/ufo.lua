local handler = function(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = (" ↙ %d lines"):format(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      -- str width returned from truncate() may less than 2nd argument, need padding
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, { suffix, "UfoFoldedEllipsis" })
  return newVirtText
end

-- local ftMap = {
--   go = "lsp",
-- }

require("ufo").setup {
  close_fold_kinds_for_ft = {
    default = { "imports" },
  },
  fold_virt_text_handler = handler,
  open_fold_hl_timeout = 0,
  preview = {
    win_config = {
      border = "rounded",
      winblend = 0,
    },
  },
  provider_selector = function(_, filetype, buftype)
    -- use nested markdown folding
    if filetype == "markdown" then
      return ""
    end

    -- return ftMap[filetype] or { "treesitter", "indent" }
    -- return { "treesitter", "indent" }
    local function handleFallbackException(bufnr, err, providerName)
      if type(err) == "string" and err:match "UfoFallbackException" then
        return require("ufo").getFolds(bufnr, providerName)
      else
        return require("promise").reject(err)
      end
    end

    -- only use indent until a file is opened
    return (filetype == "" or buftype == "nofile") and "indent"
      or function(bufnr)
        return require("ufo")
          .getFolds(bufnr, "lsp")
          :catch(function(err)
            return handleFallbackException(bufnr, err, "treesitter")
          end)
          :catch(function(err)
            return handleFallbackException(bufnr, err, "indent")
          end)
      end
  end,
}
