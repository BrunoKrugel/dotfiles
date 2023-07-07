local M = {}

function NvHandleFold()
  local c = vim.fn.getmousepo().line
  vim.cmd(tostring(c))
  vim.api.nvim_feedkeys("za", "n", true)
end

M.colored_str = function(line, str, hlgroup)
  local hl = hlgroup and "%#" .. hlgroup .. "#" or ""
  local curline = false

  if line == vim.fn.line "." then
    hl = "%#NvFoldIconOpened#"
    curline = true
  end

  return hl .. str(curline and hl or "%#LineNr#")
end

M.clickable_str = function(str)
  return "%@v:lua.NvHandleFold@" .. str .. "%X"
end

M.draw = function()
  local foldlvl = vim.fn.foldlevel
  local foldicon = function(line)
    if vim.fn.foldclosed(line) > 0 then
      return M.colored_str(line, "", "NvFoldIconClosed")
    end

    local cond = foldlvl(line) == 1 and foldlvl(line - 1) == 0
    return (cond and M.colored_str(line, "", "NvFoldIconOpened") or " ")
  end
  return M.clickable_str(foldicon(vim.v.lnum)) .. "%l "
end

M.run = function()
  vim.opt.statuscolumn = "%!v:lua.require('custom.statuscolumn').draw()"
end

return M
