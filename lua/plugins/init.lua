local function safe(req)
	local ok, mod = pcall(require, req)
	if not ok then
		vim.notify("Missing plugin module: " .. req, vim.log.levels.WARN)
		return
	end
	if type(mod) == "function" then
		mod()
	end
end

safe("plugins.snippets")
safe("plugins.blink")
safe("plugins.colorscheme")
safe("plugins.dap")
safe("plugins.clue")
safe("plugins.conform")
safe("plugins.gitsigns")
safe("plugins.mini")
safe("plugins.oil")
safe("plugins.telescope")
safe("plugins.todo_comments")
safe("plugins.treesitter")
safe("plugins.notify")
safe("plugins.mini_surround")
safe("plugins.indent_blankline")
safe("plugins.autopairs")
safe("plugins.tiny-inline-diagnostic")
