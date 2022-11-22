local present, copilot = pcall(require, "copilot")

if not present then
    return
end

-- Avoid conflict with nvim-cmp's tab fallback
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.copilot_tab_fallback = ''
vim.keymap.set('i', '<C-j>', [[copilot#Accept('')]], { noremap = true, silent = true, expr = true })

copilot.setup()
