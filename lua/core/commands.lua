-- core/commands.lua

vim.api.nvim_create_user_command("ReloadConfig", function()
	-- Clear both the bare top-level modules (core, plugins, ...) and their
	-- submodules (core.options, plugins.blink, ...). The entry counterparts
	-- below match with a trailing dot OR exactly, so `require("core")` re-runs
	-- core/init.lua which re-requires every `core.*` submodule in turn.
	for name, _ in pairs(package.loaded) do
		for _, prefix in ipairs({ "core", "plugins", "lsp", "ui", "tools" }) do
			if name == prefix or name:match("^" .. prefix .. "%.") then
				package.loaded[name] = nil
				break
			end
		end
	end
	local file = vim.fn.expand("$MYVIMRC")
	if file == "" then
		file = vim.fn.stdpath("config") .. "/init.lua"
	end
	dofile(file)
	vim.notify("Config reloaded!", vim.log.levels.INFO)
end, {})

vim.api.nvim_create_user_command("Format", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, {})
