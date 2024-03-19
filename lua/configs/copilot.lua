local present, copilot = pcall(require, "copilot")

if not present then
  return
end

copilot.setup()

vim.api.nvim_set_hl(0, "CopilotSuggestion", { fg = "#83a598" })
vim.api.nvim_set_hl(0, "CopilotAnnotation", { fg = "#03a598" })
