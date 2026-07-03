local ok, conform = pcall(require, "conform")
if not ok then
	return
end

conform.setup({
	formatters_by_ft = {
		cs = { "csharpier" },
		lua = { "stylua" },
		-- razor removed — csharpier can't handle it, see below
	},
	formatters = {
		csharpier = {
			command = "csharpier",
			args = { "format", "--stdin-path", "$FILENAME" },
		},
		stylua = {
			command = "stylua",
			args = { "--search-parent-directories", "--stdin-filepath", "$FILENAME", "-" },
		},
	},
	format_on_save = {
		timeout_ms = 5000,
		lsp_format = "fallback",
	},
	notify_on_error = true,
})
