local present, importCost = pcall(require, "import-cost")

if not present then
	return
end

importCost.setup({
	-- Filetypes to attach to
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},
	format = {
		-- Format string for bytes/kilobytes in virtual text
		byte_format = "%.1fb",
		kb_format = "%.1fk",
		-- Virtual text format (remove second "%s" to ignore gzipped size)
		virtual_text = "%s (gzipped: %s)",
	},
	-- Highlight of virtual text —
	-- a highlight group to link to or table as specified by nvim_set_hl()
	highlight = "Comment",
})