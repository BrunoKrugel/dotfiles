local present, searchbox = pcall(require, "searchbox")

if not present then
  return
end

searchbox.setup {}

