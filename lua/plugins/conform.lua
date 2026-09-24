local ok, conform = pcall(require, "conform")
if not ok then
	return
end

conform.setup({
	formatters_by_ft = {
		cs = { "csharpier" },
		lua = { "stylua" },
		razor = { "csharpier" },
		html = { "prettier" },
		css = { "prettier" },
		xml = { "xmllint" },
		caddy = { "caddy" },
		-- web + php (2026-09)
		javascript = { "prettier" },
		javascriptreact = { "prettier" },
		typescript = { "prettier" },
		typescriptreact = { "prettier" },
		json = { "prettier" },
		jsonc = { "prettier" },
		php = { "pint" },
		blade = { "blade-formatter" },
	},
	formatters = {
		csharpier = {
			command = "csharpier",
			args = { "format", "--write-stdout" },
			to_stdin = true,
		},
		stylua = {
			command = "stylua",
			args = { "--search-parent-directories", "--stdin-filepath", "$FILENAME", "-" },
		},
		caddy = {
			command = "caddy",
			args = { "fmt", "-" },
			stdin = true,
		},
		prettier = {
			prepend_args = {
				"--print-width",
				"160",
				"--html-whitespace-sensitivity",
				"ignore",
			},
		},
		xmllint = {
			command = "xmllint",
			args = { "--format", "-" },
			to_stdin = true,
		},
	},
	format_on_save = function(bufnr)
		-- skip special buffers, oil, and large files (see core/autocmds.lua)
		if vim.bo[bufnr].buftype ~= "" then
			return nil
		end
		local ft = vim.bo[bufnr].filetype
		if ft == "oil" or ft == "oil_preview" then
			return nil
		end
		if vim.b[bufnr].large_file then
			return nil
		end
		-- pint cold-starts slowly (Laravel container boot); give php/blade room
		local ft2 = vim.bo[bufnr].filetype
		if ft2 == "php" or ft2 == "blade" then
			return { timeout_ms = 5000, lsp_format = "fallback" }
		end
		return { timeout_ms = 2000, lsp_format = "fallback" }
	end,
	notify_on_error = true,
})
