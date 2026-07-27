local ok, clue = pcall(require, "mini.clue")
if not ok then
	return
end

clue.setup({
	triggers = {
		-- Leader triggers
		{ mode = "n", keys = "<leader>" },
		{ mode = "x", keys = "<leader>" },

		-- Built-in keys
		{ mode = "n", keys = "g" },
		{ mode = "n", keys = "[" },
		{ mode = "n", keys = "]" },
		{ mode = "n", keys = "z" },

		-- Window navigation
		{ mode = "n", keys = "<C-w>" },
	},

	clues = {
		-- Built-in key groups
		clue.gen_clues.g(),
		clue.gen_clues.z(),
		clue.gen_clues.builtin_completion(),
		clue.gen_clues.marks(),

		--------------------------------------------------------
		-- Telescope
		--------------------------------------------------------
		{ mode = "n", keys = "<leader>f", desc = "+Telescope" },
		{ mode = "n", keys = "<leader>ff", desc = "Find files" },
		{ mode = "n", keys = "<leader>fg", desc = "Live grep" },
		{ mode = "n", keys = "<leader>fb", desc = "Buffers" },
		{ mode = "n", keys = "<leader>fh", desc = "Help tags" },
		{ mode = "n", keys = "<leader>fr", desc = "Recent files" },
		{ mode = "n", keys = "<leader>fs", desc = "Grep string" },
		{ mode = "n", keys = "<leader>fd", desc = "Diagnostics" },
		{ mode = "n", keys = "<leader>fc", desc = "Commands" },
		{ mode = "n", keys = "<leader>fk", desc = "Keymaps" },
		{ mode = "n", keys = "<leader>fz", desc = "Fuzzy buffer" },
		{ mode = "n", keys = "<leader>ft", desc = "Treesitter symbols" },
		{ mode = "n", keys = "<leader>fw", desc = "Workspace symbols" },

		--------------------------------------------------------
		-- Git
		--------------------------------------------------------
		{ mode = "n", keys = "<leader>g", desc = "+Git" },
		{ mode = "n", keys = "<leader>gs", desc = "Status" },
		{ mode = "n", keys = "<leader>gb", desc = "Blame" },
		{ mode = "n", keys = "<leader>gd", desc = "Diff split" },
		{ mode = "n", keys = "<leader>gl", desc = "Log" },
		{ mode = "n", keys = "<leader>gp", desc = "Push" },
		{ mode = "n", keys = "<leader>gP", desc = "Pull" },
		{ mode = "n", keys = "<leader>gc", desc = "Commit" },
		{ mode = "n", keys = "<leader>gw", desc = "Stage file" },
		{ mode = "n", keys = "<leader>gt", desc = "Git status (Telescope)" },
		{ mode = "n", keys = "<leader>gv", desc = "Diffview open" },
		{ mode = "n", keys = "<leader>gV", desc = "Diffview close" },
		{ mode = "n", keys = "<leader>gh", desc = "Repo history" },
		{ mode = "n", keys = "<leader>gH", desc = "File history" },

		--------------------------------------------------------
		-- Buffers
		--------------------------------------------------------
		{ mode = "n", keys = "<leader>b", desc = "+Buffers" },
		{ mode = "n", keys = "<leader>bn", desc = "Next buffer" },
		{ mode = "n", keys = "<leader>bp", desc = "Previous buffer" },
		{ mode = "n", keys = "<leader>bf", desc = "First buffer" },
		{ mode = "n", keys = "<leader>bl", desc = "Last buffer" },
		{ mode = "n", keys = "<leader>bd", desc = "Delete buffer" },

		--------------------------------------------------------
		-- Splits
		--------------------------------------------------------
		{ mode = "n", keys = "<leader>s", desc = "+Splits" },
		{ mode = "n", keys = "<leader>sv", desc = "Vertical split" },
		{ mode = "n", keys = "<leader>sh", desc = "Horizontal split" },
		{ mode = "n", keys = "<leader>sc", desc = "Close split" },

		--------------------------------------------------------
		-- Diagnostics
		--------------------------------------------------------
		{ mode = "n", keys = "]d", desc = "Next diagnostic" },
		{ mode = "n", keys = "[d", desc = "Previous diagnostic" },

		--------------------------------------------------------
		-- LSP
		--------------------------------------------------------
		{ mode = "n", keys = "gd", desc = "Go to definition" },
		{ mode = "n", keys = "gD", desc = "Go to declaration" },
		{ mode = "n", keys = "gr", desc = "Go to references" },
		{ mode = "n", keys = "gi", desc = "Go to implementation" },
		{ mode = "n", keys = "K", desc = "Hover" },
		{ mode = "n", keys = "<leader>k", desc = "Signature help" },
		{ mode = "n", keys = "<leader>rn", desc = "Rename" },
		{ mode = "n", keys = "<leader>ca", desc = "Code action" },
		{ mode = "n", keys = "<leader>cf", desc = "Format" },
		{ mode = "n", keys = "<leader>ci", desc = "Toggle inlay hints" },
		{ mode = "n", keys = "<leader>e", desc = "Diagnostic float" },

		--------------------------------------------------------
		-- Gitsigns
		--------------------------------------------------------
		{ mode = "n", keys = "<leader>h", desc = "+Gitsigns" },
		{ mode = "n", keys = "<leader>hs", desc = "Stage hunk" },
		{ mode = "n", keys = "<leader>hr", desc = "Reset hunk" },
		{ mode = "n", keys = "<leader>hS", desc = "Stage buffer" },
		{ mode = "n", keys = "<leader>hu", desc = "Undo stage hunk" },
		{ mode = "n", keys = "<leader>hR", desc = "Reset buffer" },
		{ mode = "n", keys = "<leader>hp", desc = "Preview hunk" },
		{ mode = "n", keys = "<leader>hb", desc = "Blame line" },
		{ mode = "n", keys = "<leader>hd", desc = "Diff this" },
		{ mode = "n", keys = "<leader>hD", desc = "Diff this ~" },
		{ mode = "n", keys = "<leader>tb", desc = "Toggle blame" },
		{ mode = "n", keys = "<leader>td", desc = "Toggle deleted" },

		--------------------------------------------------------
		-- Todo-comments
		--------------------------------------------------------
		{ mode = "n", keys = "]t", desc = "Next TODO" },
		{ mode = "n", keys = "[t", desc = "Previous TODO" },
		{ mode = "n", keys = "<leader>Ft", desc = "Find todos (Telescope)" },

		--------------------------------------------------------
		-- DAP (Debugger)
		--------------------------------------------------------
		{ mode = "n", keys = "<leader>d", desc = "+Debug" },
		{ mode = "n", keys = "<leader>db", desc = "Toggle breakpoint" },
		{ mode = "n", keys = "<leader>dB", desc = "Conditional breakpoint" },
		{ mode = "n", keys = "<leader>dc", desc = "Start / Continue" },
		{ mode = "n", keys = "<leader>do", desc = "Step over" },
		{ mode = "n", keys = "<leader>di", desc = "Step into" },
		{ mode = "n", keys = "<leader>dO", desc = "Step out" },
		{ mode = "n", keys = "<leader>dt", desc = "Stop debugging" },
		{ mode = "n", keys = "<leader>dr", desc = "Open REPL" },
		{ mode = "n", keys = "<leader>dl", desc = "Run last" },
		{ mode = "n", keys = "<leader>du", desc = "Toggle DAP UI" },

		--------------------------------------------------------
		-- Plugins
		--------------------------------------------------------
		{ mode = "n", keys = "<leader>p", desc = "+Plugins" },
		{ mode = "n", keys = "<leader>pc", desc = "Clean plugins" },
		{ mode = "n", keys = "<leader>pu", desc = "Update plugins" },

		--------------------------------------------------------
		-- Notifications
		--------------------------------------------------------
		{ mode = "n", keys = "<leader>n", desc = "+Notifications" },
		{ mode = "n", keys = "<leader>nn", desc = "Dismiss all notifications" },
		{ mode = "n", keys = "<leader>nh", desc = "Dismiss all notifications" },
		{ mode = "n", keys = "<leader>nl", desc = "Notification history" },

		--------------------------------------------------------
		-- Misc
		--------------------------------------------------------
		{ mode = "n", keys = "<leader>cc", desc = "Find config files" },
		{ mode = "n", keys = "<leader>-", desc = "File explorer (Oil)" },
		{ mode = "n", keys = "<Esc>", desc = "Clear search highlight" },
		{ mode = "x", keys = "<leader>p", desc = "Paste without yank" },
		{ mode = "n", keys = "<leader>Dv", desc = "Delete to void" },
		{ mode = "v", keys = "<leader>Dv", desc = "Delete selection to void" },
		{ mode = "t", keys = "<Esc><Esc>", desc = "Exit terminal mode" },

		--------------------------------------------------------
		-- Navigation
		--------------------------------------------------------
		{ mode = "n", keys = "n", desc = "Next search (centered)" },
		{ mode = "n", keys = "N", desc = "Prev search (centered)" },
		{ mode = "n", keys = "<C-d>", desc = "Scroll down (centered)" },
		{ mode = "n", keys = "<C-u>", desc = "Scroll up (centered)" },
		{ mode = "n", keys = "<C-h>", desc = "Move left window" },
		{ mode = "n", keys = "<C-j>", desc = "Move down window" },
		{ mode = "n", keys = "<C-k>", desc = "Move up window" },
		{ mode = "n", keys = "<C-l>", desc = "Move right window" },
		{ mode = "n", keys = "j", desc = "Move down (to first non-blank)" },
		{ mode = "v", keys = "j", desc = "Move down (to first non-blank)" },
		{ mode = "n", keys = "k", desc = "Move up (to first non-blank)" },
		{ mode = "v", keys = "k", desc = "Move up (to first non-blank)" },

		--------------------------------------------------------
		-- Window navigation
		--------------------------------------------------------
		{ mode = "n", keys = "<C-w>h", desc = "Left window" },
		{ mode = "n", keys = "<C-w>j", desc = "Down window" },
		{ mode = "n", keys = "<C-w>k", desc = "Up window" },
		{ mode = "n", keys = "<C-w>l", desc = "Right window" },

		--------------------------------------------------------
		-- Insert mode undo breakpoints
		--------------------------------------------------------
		{ mode = "i", keys = ",", desc = "Undo break on comma" },
		{ mode = "i", keys = ".", desc = "Undo break on period" },
		{ mode = "i", keys = "!", desc = "Undo break on exclamation" },
		{ mode = "i", keys = "?", desc = "Undo break on question mark" },

		--------------------------------------------------------
		-- Dotnet
		--------------------------------------------------------
		{ mode = "n", keys = "<leader>D", desc = "+Dotnet" },
		{ mode = "n", keys = "<leader>Dr", desc = "Dotnet run" },
		{ mode = "n", keys = "<leader>Db", desc = "Dotnet build" },
		{ mode = "n", keys = "<leader>Dt", desc = "Run .NET tests" },
		{ mode = "n", keys = "<leader>Dw", desc = "Watch .NET tests" },
		{ mode = "n", keys = "<leader>Dn", desc = "Add NuGet package" },

		--------------------------------------------------------
		-- Trouble
		--------------------------------------------------------
		{ mode = "n", keys = "<leader>x", desc = "+Trouble" },
		{ mode = "n", keys = "<leader>xx", desc = "Diagnostics" },
		{ mode = "n", keys = "<leader>xX", desc = "Buffer diagnostics" },
		{ mode = "n", keys = "<leader>xl", desc = "Location list" },
		{ mode = "n", keys = "<leader>xq", desc = "Quickfix list" },

		--------------------------------------------------------
		-- Aerial
		--------------------------------------------------------
		{ mode = "n", keys = "<leader>o", desc = "Code outline (Aerial)" },

		--------------------------------------------------------
		-- Neotest
		--------------------------------------------------------
		{ mode = "n", keys = "<leader>t", desc = "+Tests" },
		{ mode = "n", keys = "<leader>tr", desc = "Run nearest test" },
		{ mode = "n", keys = "<leader>tf", desc = "Run file tests" },
		{ mode = "n", keys = "<leader>ts", desc = "Test summary" },
		{ mode = "n", keys = "<leader>to", desc = "Test output" },

		--------------------------------------------------------
		-- Buffer creation
		--------------------------------------------------------
		{ mode = "n", keys = "<leader>bc", desc = "Create empty buffer" },
	},

	window = {
		delay = 400,
		config = {
			border = "rounded",
			width = "auto",
		},
	},
})
