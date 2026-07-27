local ok, ts = pcall(require, "nvim-treesitter")
if not ok then
	return
end

ts.setup()

local ensure_installed = {
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
}

-- Install any parsers not already present. `nvim-treesitter`'s post-rewrite
-- API no longer has an `ensure_installed` setup option, so this is done
-- explicitly instead.
local config_ok, ts_config = pcall(require, "nvim-treesitter.config")
local installed = {}
if config_ok and ts_config.installed_parsers then
	installed = ts_config.installed_parsers()
end

local to_install = vim.tbl_filter(function(lang)
	return not vim.tbl_contains(installed, lang)
end, ensure_installed)

if #to_install > 0 then
	ts.install(to_install)
end

-- Highlighting/indent are no longer enabled via `.setup()` — start them
-- per-buffer on FileType instead.
vim.api.nvim_create_autocmd("FileType", {
	pattern = ensure_installed,
	callback = function(args)
		pcall(vim.treesitter.start, args.buf)
		vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
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
