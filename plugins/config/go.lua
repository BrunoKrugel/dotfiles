local present, go = pcall(require, "go")

if not present then
    return
end

go.setup{
    lsp_document_formatting = false,
}