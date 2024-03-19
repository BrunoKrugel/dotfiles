local present, refactoring = pcall(require, "refactoring")

if not present then
  return
end

refactoring.setup {
  prompt_func_return_type = {
    go = true,
  },
  prompt_func_param_type = {
    go = true,
  },
}
