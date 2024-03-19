local status, illuminate = pcall(require, "illuminate")

if not status then
  return
end

illuminate.configure {
  -- providers: provider used to get references in the buffer, ordered by priority
  providers = {
    "lsp",
    "treesitter",
    "regex",
  },
  delay = 100,
  filetypes_denylist = {
    "dirvish",
    "fugitive",
    "alpha",
    "NvimTree",
    "packer",
    "neogitstatus",
    "Trouble",
    "lir",
    "Outline",
    "spectre_panel",
    "toggleterm",
    "DressingSelect",
    "TelescopePrompt",
    "aerial",
    "Empty",
  },
  under_cursor = true,
  max_file_lines = nil,
}
