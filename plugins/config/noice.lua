local present, noice = pcall(require, "noice")

if not present then
  return
end

noice.setup{}