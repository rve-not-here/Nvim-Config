local ok, ts_configs = pcall(require, "nvim-treesitter.configs")
if not ok then
	return
end

ts_configs.setup({
	ensure_installed = {
		"lua",
		"vim",
		"vimdoc",
		"json",
		"yaml",
		"markdown",
		"markdown_inline",
		"bash",
		"regex",
		"c_sharp",
		"razor",
		"html",
		"css",
	},

	highlight = { enable = true },
	indent = { enable = true },

	auto_install = false,
})

-- Autotag
pcall(function()
	require("nvim-ts-autotag").setup({
		opts = {
			enable_close = true,
			enable_rename = true,
			enable_close_on_slash = false,
		},
	})
end)
