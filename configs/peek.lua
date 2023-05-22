local present, peek = pcall(require, "peek")

if not present then
  return
end

peek.setup {
  auto_load = true,
  close_on_bdelete = true,
  syntax = true,
  theme = "dark",
  update_on_change = true,
  app = "chromium",
  filetype = { "markdown" },
  throttle_at = 200000,
  throttle_time = "auto",
}
