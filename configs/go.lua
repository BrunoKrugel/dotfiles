local present, go = pcall(require, "go")

if not present then
  return
end

local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

go.setup {
  lsp_cfg = {
    capabilities = capabilities,
    -- other setups
  },
  lsp_document_formatting = true,
  -- null_ls_document_formatting_disable = true,
  max_line_len = 300,
  lsp_inlay_hints = {
    enable = true,
    only_current_line = true,
    other_hints_prefix = "• ",
  },
  trouble = true,
  lsp_keymaps = false,
  icons = { breakpoint = "", currentpos = "" },
  lsp_diag_virtual_text = false,
  gocoverage_sign = "│",
  -- lsp_diag_virtual_text = { space = 0, prefix = "" },
  --  cat
}

vim.api.nvim_set_hl(0, "goCoverageUncover", { fg = "#F1FA8C" })
vim.api.nvim_set_hl(0, "goCoverageUncovered", { fg = "#e8274b" })
vim.api.nvim_set_hl(0, "goCoverageCovered", { fg = "#50fa7b" })

