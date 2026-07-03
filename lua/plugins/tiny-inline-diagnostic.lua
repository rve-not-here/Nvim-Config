local ok, tiny = pcall(require, "tiny-inline-diagnostic")
if not ok then
	return
end

------------------------------------------------------------
-- Highlight Groups
------------------------------------------------------------
vim.api.nvim_set_hl(0, "TinyDiagError", {
	fg = "#e06c75",
	bg = "NONE",
	bold = true,
})

vim.api.nvim_set_hl(0, "TinyDiagWarn", {
	fg = "#e5c07b",
	bg = "NONE",
	bold = true,
})

vim.api.nvim_set_hl(0, "TinyDiagInfo", {
	fg = "#61afef",
	bg = "NONE",
})

vim.api.nvim_set_hl(0, "TinyDiagHint", {
	fg = "#98c379",
	bg = "NONE",
})

vim.api.nvim_set_hl(0, "TinyDiagArrow", {
	fg = "#5c6370",
	bold = true,
})

------------------------------------------------------------
-- Setup
------------------------------------------------------------
tiny.setup({
	preset = "modern",

	transparent_bg = true,
	transparent_cursorline = true,

	signs = {
		diag = "",
		arrow = "     ",
		vertical = " │",
		vertical_end = " └",
	},

	hi = {
		error = "TinyDiagError",
		warn = "TinyDiagWarn",
		info = "TinyDiagInfo",
		hint = "TinyDiagHint",
		arrow = "TinyDiagArrow",
		background = "CursorLine",
		mixing_color = "Normal",
	},

	disabled_ft = {},

	options = {
		--------------------------------------------------------
		-- Display
		--------------------------------------------------------
		show_source = {
			enabled = true,
			if_many = false,
		},

		show_code = true,

		use_icons_from_diagnostic = false,
		set_arrow_to_diag_color = true,

		--------------------------------------------------------
		-- Performance
		--------------------------------------------------------
		throttle = 20,
		softwrap = 60,

		--------------------------------------------------------
		-- Multiple diagnostics
		--------------------------------------------------------
		add_messages = {
			messages = true,
			display_count = false,
			use_max_severity = false,
			show_multiple_glyphs = true,
		},

		--------------------------------------------------------
		-- Multiline diagnostics
		--------------------------------------------------------
		multilines = {
			enabled = true,
			always_show = true,
			max_lines = 3,
			trim_whitespaces = true,
			tabstop = 4,
			severity = nil,
		},

		show_all_diags_on_cursorline = false,
		show_diags_only_under_cursor = true,

		show_related = {
			enabled = true,
			max_count = 3,
		},

		enable_on_insert = false,
		enable_on_select = false,

		--------------------------------------------------------
		-- Overflow handling
		--------------------------------------------------------
		overflow = {
			mode = "wrap",
			padding = 1,
		},

		break_line = {
			enabled = false,
			after = 60,
		},

		--------------------------------------------------------
		-- Virtual text priority
		--------------------------------------------------------
		virt_texts = {
			priority = 2048,
		},

		--------------------------------------------------------
		-- Severity filter
		--------------------------------------------------------
		severity = {
			vim.diagnostic.severity.ERROR,
			vim.diagnostic.severity.WARN,
			vim.diagnostic.severity.INFO,
			vim.diagnostic.severity.HINT,
		},

		--------------------------------------------------------
		-- Custom formatting
		--------------------------------------------------------
		format = function(diag)
			local parts = {}

			if diag.source and diag.source ~= "" then
				table.insert(parts, ("[%s]"):format(diag.source))
			end

			table.insert(parts, diag.message)

			if diag.code and diag.code ~= "" then
				table.insert(parts, ("(%s)"):format(diag.code))
			end

			return table.concat(parts, " ")
		end,

		--------------------------------------------------------
		-- Advanced
		--------------------------------------------------------
		overwrite_events = nil,
		override_open_float = false,

		experimental = {
			use_window_local_extmarks = false,
		},
	},
})
