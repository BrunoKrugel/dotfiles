local present, blameline = pcall(require, "blame_line")

if not present then
  return
end

blameline.setup {
  show_in_insert = false,
  template = "<author> • <author-time> • <summary>",
}

