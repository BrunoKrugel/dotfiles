local present, context = pcall(require, "treesitter-context")

if not present then
  return
end

require("treesitter-context").setup {
  enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
  throttle = true, -- Throttles plugin updates (may improve performance)
  max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
  patterns = {
    default = {
      "class",
      "function",
      "method",
    },
  },
}
