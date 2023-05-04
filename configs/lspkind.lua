local present, lspkind = pcall(require, "lspkind")

if not present then
  return
end

lspkind.init {
  -- enables text annotations
  --
  -- default: true
  mode = "symbol",
  -- default symbol map
  -- can be either 'default' (requires nerd-fonts font) or
  -- 'codicons' for codicon preset (requires vscode-codicons font)
  --
  -- default: 'default'
  preset = "codicons",
  -- override preset symbols
  --
  -- default: {}
  symbol_map = {
    Text = "",
    Method = "",
    Function = "",
    Constructor = " ",
    Field = "",
    Variable = "",
    Class = "",
    Interface = "",
    Module = "硫",
    Property = "",
    Unit = " ",
    Value = "",
    Enum = " ",
    Keyword = "ﱃ",
    Snippet = " ",
    Color = " ",
    File = " ",
    Reference = "Ꮢ",
    Folder = " ",
    EnumMember = " ",
    Constant = " ",
    Struct = " ",
    Event = "",
    Operator = "",
    TypeParameter = " ",
    Copilot = " ",
  },
}
