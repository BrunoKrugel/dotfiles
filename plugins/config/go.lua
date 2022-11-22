local present, go = pcall(require, "go")

if not present then
    return
end

go.setup{
    lsp_document_formatting = false,
    -- null_ls_document_formatting_disable = true,
    -- max_line_len = 300,
}