-- ui/statusline.lua
local ok, heirline = pcall(require, "heirline")
if not ok then
	return
end

local conditions = require("heirline.conditions")
local utils = require("heirline.utils")
local p = require("ui.palette").statusline

------------------------------------------------------------
-- helpers
------------------------------------------------------------
local space = { provider = " " }
local align_right = { provider = "%=" }

local function get_icon(filename)
	local ok_d, devicons = pcall(require, "nvim-web-devicons")
	if not ok_d then
		return "", nil
	end
	local ext = vim.fn.fnamemodify(filename, ":e")
	return devicons.get_icon_color(filename, ext, { default = true })
end

------------------------------------------------------------
-- bufferline
------------------------------------------------------------
local buf_icon = {
	provider = function(self)
		local name = vim.api.nvim_buf_get_name(self.bufnr)
		if name == "" then
			return " "
		end
		local icon = get_icon(name)
		return icon .. " "
	end,
}

local buf_name = {
	provider = function(self)
		local name = vim.api.nvim_buf_get_name(self.bufnr)
		if name == "" then
			return "[no name]"
		end
		return vim.fn.fnamemodify(name, ":t")
	end,
}

local buf_modified = {
	provider = function(self)
		return vim.bo[self.bufnr].modified and " ●" or ""
	end,
	hl = { fg = p.yellow },
}

local buf_close = {
	provider = " 󰅖 ",
	hl = { fg = p.gray },
	on_click = {
		callback = function(_, minwid)
			pcall(vim.api.nvim_buf_delete, minwid, { force = false })
		end,
		minwid = function(self)
			return self.bufnr
		end,
		name = "bufferline_close",
	},
}

local bufferline = utils.make_buflist({
	buf_icon,
	buf_name,
	buf_modified,
	buf_close,
	hl = function(self)
		return {
			bg = self.is_active and p.bg or p.dark,
			fg = self.is_active and p.fg or p.gray,
			bold = self.is_active,
		}
	end,
	on_click = {
		callback = function(_, minwid)
			vim.api.nvim_set_current_buf(minwid)
		end,
		minwid = function(self)
			return self.bufnr
		end,
		name = "bufferline_click",
	},
})

------------------------------------------------------------
-- statusline: left
------------------------------------------------------------
local mode = {
	provider = function()
		local icons = {
			n = "󰈔",
			i = "󰈙",
			v = "󰈋",
			V = "󰈏",
			["\22"] = "󰈌",
			c = " ",
			r = "󰈿",
		}
		return " " .. (icons[vim.fn.mode()] or vim.fn.mode():upper()) .. " "
	end,
	hl = function()
		local mode_colors = {
			n = p.blue,
			i = p.green,
			v = p.purple,
			V = p.purple,
			["\22"] = p.purple,
			c = p.yellow,
			r = p.red,
		}
		return {
			fg = p.bg,
			bg = mode_colors[vim.fn.mode()] or p.gray,
			bold = true,
		}
	end,
}

local recording = {
	condition = function()
		return vim.fn.reg_recording() ~= ""
	end,
	provider = function()
		return " 󰑋 rec " .. vim.fn.reg_recording() .. " "
	end,
	hl = { fg = p.bg, bg = p.red, bold = true },
}

local lsp_status = {
	condition = function()
		return #vim.lsp.get_clients({ bufnr = 0 }) > 0
	end,
	provider = function()
		local names = {}
		for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
			names[#names + 1] = client.name
		end
		return "  " .. table.concat(names, ", ") .. " "
	end,
	hl = { fg = p.cyan, italic = true },
}
local git_branch = {
	condition = conditions.is_git_repo,
	provider = function()
		local head = vim.b.gitsigns_head
		return (head and head ~= "") and (" " .. head .. " ") or ""
	end,
	hl = { fg = p.purple },
}

local git_diff = {
	condition = conditions.is_git_repo,
	provider = function()
		local bc = vim.b.gitsigns_status_dict
		if not bc then
			return ""
		end
		local parts = {}
		if (bc.added or 0) > 0 then
			parts[#parts + 1] = "%#GitSignsAdd#+" .. bc.added .. "%*"
		end
		if (bc.changed or 0) > 0 then
			parts[#parts + 1] = "%#GitSignsChange#~" .. bc.changed .. "%*"
		end
		if (bc.removed or 0) > 0 then
			parts[#parts + 1] = "%#GitSignsDelete#-" .. bc.removed .. "%*"
		end
		return #parts > 0 and (" " .. table.concat(parts, " ") .. " ") or ""
	end,
}

-- file components (now in statusline, not winbar)
local file_icon = {
	provider = function()
		local filename = vim.fn.expand("%:t")
		if filename == "" then
			return ""
		end
		local icon = get_icon(filename)
		return icon .. " "
	end,
	hl = function()
		local filename = vim.fn.expand("%:t")
		local _, color = get_icon(filename)
		return { fg = color or p.blue }
	end,
}

local file_name = {
	provider = function()
		local name = vim.fn.expand("%:.")
		return name ~= "" and (name .. " ") or "[no name] "
	end,
	hl = { fg = p.fg, bold = true },
}

local file_modified = {
	provider = function()
		return vim.bo.modified and "● " or ""
	end,
	hl = { fg = p.yellow },
}

-- breadcrumbs (defined before use)
local breadcrumbs = {
	condition = function()
		local ok_n, navic = pcall(require, "nvim-navic")
		return ok_n and navic.is_available()
	end,
	provider = function()
		local ok_n, navic = pcall(require, "nvim-navic")
		return ok_n and navic.get_location() or ""
	end,
	hl = { fg = p.gray },
}

------------------------------------------------------------
-- statusline: right
------------------------------------------------------------
local file_type = {
	provider = function()
		local ft = vim.bo.filetype
		return ft ~= "" and (" " .. ft .. " ") or ""
	end,
	hl = { fg = p.bg, bg = p.blue, bold = true },
}

local file_format = {
	provider = function()
		return " " .. vim.bo.fileformat:upper() .. " "
	end,
	hl = { fg = p.gray },
}

local diagnostics = {
	condition = conditions.has_diagnostics,
	provider = function()
		local diag = vim.diagnostic.count(0) or {}
		local severities = {
			{ vim.diagnostic.severity.ERROR, "DiagnosticSignError", " " },
			{ vim.diagnostic.severity.WARN, "DiagnosticSignWarn", " " },
			{ vim.diagnostic.severity.INFO, "DiagnosticSignInfo", " " },
			{ vim.diagnostic.severity.HINT, "DiagnosticSignHint", "" },
		}
		local parts = {}
		for _, s in ipairs(severities) do
			local count = diag[s[1]] or 0
			if count > 0 then
				parts[#parts + 1] = "%#" .. s[2] .. "#" .. s[3] .. count .. "%*"
			end
		end
		return table.concat(parts, " ")
	end,
}

local scroll_percent = {
	provider = function()
		local curr = vim.fn.line(".")
		local total = vim.fn.line("$")
		if total <= 1 then
			return " top "
		end
		local pct = math.floor(curr / total * 100)
		if pct <= 1 then
			return " top "
		end
		if pct >= 99 then
			return " bot "
		end
		return " " .. pct .. "%% "
	end,
	hl = { fg = p.gray },
}

local position = {
	provider = "  %l:%c ",
	hl = { fg = p.gray },
}

------------------------------------------------------------
-- single setup call
------------------------------------------------------------
heirline.setup({
	tabline = bufferline,
	statusline = {
		mode,
		recording,
		lsp_status,
		git_branch,
		git_diff,
		space,
		file_icon,
		file_name,
		file_modified,
		{ provider = " > ", hl = { fg = p.gray } },
		breadcrumbs,
		align_right,
		diagnostics,
		space,
		file_type,
		space,
		file_format,
		scroll_percent,
		position,
	},
})
