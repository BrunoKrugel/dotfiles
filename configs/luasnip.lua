local present, luasnip = pcall(require, "luasnip")

if not present then
  return
end

luasnip.filetype_extend("javascriptreact", { "html" })
luasnip.filetype_extend("vue", { "html" })

require("luasnip/loaders/from_vscode").lazy_load()

luasnip.setup {
  ext_opts = {
    [luasnip.util.types.insertNode] = {
      unvisited = {
        virt_text = { { "|", "Conceal" } },
        -- virt_text_pos = "inline",
      },
      active = {
        virt_text = { { "󰩫", 'yellow' } },
      },
    },
    [luasnip.util.types.exitNode] = {
      unvisited = {
        virt_text = { { "|", "Conceal" } },
        -- virt_text_pos = "inline",
      },
    },
    [luasnip.util.types.choiceNode] = {
        active = {
          virt_text = { { "", 'blue' } },
        },
      },
  },
}