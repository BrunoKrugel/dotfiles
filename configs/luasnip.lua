local present, luasnip = pcall(require, "luasnip")

if not present then
  return
end

luasnip.filetype_extend("javascriptreact", { "html" })
luasnip.filetype_extend("typescriptreact", { "react-ts", "typescript", "html" })
luasnip.filetype_extend("javascriptreact", { "react", "javascript", "html" })
luasnip.filetype_extend("javascript", { "react" })
luasnip.filetype_extend("vue", { "html" })

require("luasnip/loaders/from_vscode").lazy_load()
require("luasnip.loaders.from_lua").load { paths = "~/.config/nvim/lua/custom/luasnip" }

local types = require "luasnip.util.types"

luasnip.setup {
  history = true,
  delete_check_events = "TextChanged",
  region_check_events = "CursorMoved",
  ext_opts = {
    [types.insertNode] = {
      unvisited = {
        virt_text = { { "|", "Conceal" } },
        -- virt_text_pos = "inline",
      },
      active = {
        virt_text = { { "●", "yellow" } },
      },
    },
    [types.exitNode] = {
      unvisited = {
        virt_text = { { "|", "Conceal" } },
        -- virt_text_pos = "inline",
      },
    },
    [types.choiceNode] = {
      active = {
        virt_text = { { "●", "blue" } },
      },
    },
  },
}
