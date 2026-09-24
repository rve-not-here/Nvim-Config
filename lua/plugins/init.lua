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

safe("plugins.blink")
safe("plugins.colorscheme")
safe("plugins.dap")
safe("plugins.conform")
safe("plugins.which_key")
safe("plugins.gitsigns")
safe("plugins.mini")
safe("plugins.oil")
safe("plugins.todo_comments")
safe("plugins.treesitter")
safe("plugins.mini_surround")
safe("plugins.autopairs")
safe("plugins.neotest")
safe("plugins.snacks")
safe("plugins.ramboe_utils")
safe("plugins.comment")
safe("plugins.luasnip")
safe("plugins.noneckpain")
safe("plugins.git_conflict")
safe("plugins.img_clip")
safe("plugins.live_preview")
safe("plugins.undotree")
safe("plugins.garbage_day")
