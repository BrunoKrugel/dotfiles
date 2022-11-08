local present, autosave = pcall(require, "autosave")

if present then
    autosave.setup{
        enabled = true,
    }
end