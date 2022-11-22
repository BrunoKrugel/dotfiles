local present, copilot = pcall(require, "copilot")

if not present then
    return
end

copilot.setup()
