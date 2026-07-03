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

		--------------------------------------------------------
		-- DAP (Debugger)
		--------------------------------------------------------
		{ mode = "n", keys = "<leader>d", desc = "+Debug" },
		{ mode = "n", keys = "<leader>db", desc = "Toggle breakpoint" },
		{ mode = "n", keys = "<leader>dB", desc = "Conditional breakpoint" },
		{ mode = "n", keys = "<leader>dc", desc = "Continue" },
		{ mode = "n", keys = "<leader>do", desc = "Step over" },
		{ mode = "n", keys = "<leader>di", desc = "Step into" },
		{ mode = "n", keys = "<leader>dO", desc = "Step out" },
		{ mode = "n", keys = "<leader>dt", desc = "Terminate" },
		{ mode = "n", keys = "<leader>dr", desc = "Open REPL" },
		{ mode = "n", keys = "<leader>dl", desc = "Run last" },
		{ mode = "n", keys = "<leader>du", desc = "Toggle DAP UI" },
		{ mode = "n", keys = "<leader>dT", desc = "Diff tool" },

		--------------------------------------------------------
		-- Plugins
		--------------------------------------------------------
		{ mode = "n", keys = "<leader>pc", desc = "Clean plugins" },
		{ mode = "n", keys = "<leader>pu", desc = "Update plugins" },

		--------------------------------------------------------

		--------------------------------------------------------
		{ mode = "n", keys = "<leader>u", desc = "Undo tree" },
		{ mode = "n", keys = "<leader>cc", desc = "Find config files" },
		{ mode = "n", keys = "<leader>nn", desc = "Dismiss notifications" },
		{ mode = "n", keys = "<leader>-", desc = "File explorer" },

		--------------------------------------------------------
		-- Window navigation
		--------------------------------------------------------
		{ mode = "n", keys = "<C-w>h", desc = "Left window" },
		{ mode = "n", keys = "<C-w>j", desc = "Down window" },
		{ mode = "n", keys = "<C-w>k", desc = "Up window" },
		{ mode = "n", keys = "<C-w>l", desc = "Right window" },

		--------------------------------------------------------
		-- Dotnet
		--------------------------------------------------------
		{ mode = "n", keys = "<leader>D", desc = "+Dotnet" },
		{ mode = "n", keys = "<leader>Dr", desc = "Dotnet run" },
		{ mode = "n", keys = "<leader>Db", desc = "Dotnet build" },
	},

	window = {
		delay = 800,
		config = {
			border = "rounded",
			width = "auto",
		},
	},
})
