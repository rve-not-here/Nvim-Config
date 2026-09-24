-- Watches the active Omarchy theme's colors.toml and re-applies the Neovim
-- colorscheme as soon as it changes (e.g. `omarchy theme set <name>`).
--
-- The palette is read at load time by ui.palette and cached by require(), so a
-- theme switch never reaches an already-running instance. This module monitors
-- the file's mtime and re-runs the palette consumers with fresh values.
--
-- Polling is used (instead of uv.fs_event) because theme switches can rewrite
-- the file and inotify events are easy to lose when the file is replaced.

local THEME_DIR = vim.fn.expand("~/.local/state/omarchy/current/theme")
local COLORS = THEME_DIR .. "/colors.toml"

local M = {}

local timer = nil
local last_mtime = nil
local reloading = false

-- Re-read palette and re-run every consumer so the new colors take effect now.
local function reload()
	if reloading then
		return
	end
	reloading = true
	vim.schedule(function()
		reloading = false
		package.loaded["ui.palette"] = nil
		package.loaded["ui.statusline"] = nil
		package.loaded["plugins.colorscheme"] = nil

		pcall(require, "plugins.colorscheme")
		vim.api.nvim_exec_autocmds("ColorScheme", {})
		pcall(require, "ui.statusline")
		vim.cmd("redraw!")
	end)
end

local POLL_MS = 500

local function poll()
	local stat = vim.uv.fs_stat(COLORS)
	if stat then
		local mtime = stat.mtime.sec * 1000000000 + stat.mtime.nsec
		if last_mtime ~= nil and mtime ~= last_mtime then
			last_mtime = mtime
			reload()
		elseif last_mtime == nil then
			last_mtime = mtime
		end
	end
end

function M.start()
	if timer then
		return
	end
	if not vim.uv or not vim.uv.new_timer then
		return
	end
	timer = vim.uv.new_timer()
	timer:start(POLL_MS, POLL_MS, vim.schedule_wrap(poll))
end

return M
