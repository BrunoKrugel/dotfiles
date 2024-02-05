local present, go = pcall(require, "go")

if not present then
  return
end

local core = require "custom.utils.core"

go.setup {
  max_line_len = 300,
  lsp_inlay_hints = {
    enable = true,
    only_current_line = true,
    other_hints_prefix = "•",
  },
  trouble = true,
  lsp_keymaps = false,
  diagnostic = {
    hdlr = true,
    underline = true,
    virtual_text = false,
    signs = true,
    update_in_insert = false,
  },
  floaterm = {
    posititon = 'auto',
    width = 0.45,
    height = 0.98,
    title_colors = 'dracula',
  },
  icons = { breakpoint = "", currentpos = "" },
  gocoverage_sign = "│",
  -- lsp_diag_virtual_text = { space = 0, prefix = "" },
  --  cat
  dap_debug_gui = core.dapui,
}

vim.api.nvim_set_hl(0, "goCoverageUncover", { fg = "#F1FA8C" })
vim.api.nvim_set_hl(0, "goCoverageUncovered", { fg = "#ff7070" })
vim.api.nvim_set_hl(0, "goCoverageCovered", { fg = "#50fa7b" })
