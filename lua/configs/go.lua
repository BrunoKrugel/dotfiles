local present, go = pcall(require, "go")

if not present then
  return
end

local core = require "custom.utils.core"

go.setup {
  lsp_inlay_hints = {
    enable = false,
    -- only_current_line = true,
    other_hints_prefix = "•",
  },
  trouble = true,
  lsp_keymaps = false,
  diagnostic = false,
  lsp_codelens = true,
  floaterm = {
    posititon = "auto",
    width = 0.45,
    height = 0.98,
    title_colors = "dracula",
  },
  icons = { breakpoint = "", currentpos = "" },
  gocoverage_sign = "│",
  -- lsp_diag_virtual_text = { space = 0, prefix = "" },
  --  cat
  dap_debug_gui = core.dapui,
  dap_debug_vt = { enabled_commands = true, all_frames = true },
}

vim.api.nvim_set_hl(0, "goCoverageUncover", { fg = "#f9e2af" })
vim.api.nvim_set_hl(0, "goCoverageUncovered", { fg = "#F38BA8" })
vim.api.nvim_set_hl(0, "goCoverageCovered", { fg = "#a6e3a1" })
