local present, prettyFold = pcall(require, "pretty-fold")

if not present then
  return
end

prettyFold.setup {
  keep_indentation = false,
  fill_char = " ",
  sections = {
    left = {
      -- "━ ",
      function()
        return string.rep("*", vim.v.foldlevel)
      end,
      -- " ━┫",
      "content",
      -- "┣",
    },
    right = {
      -- "┫ ",
      "number_of_folded_lines",
      ": ",
      "percentage",
      -- " ┣━━",
    },
  },
}
