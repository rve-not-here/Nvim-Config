-- NOTE: no require/setup here on purpose (startup saving): diffview runs
-- on defaults and its :Diffview* commands exist via rtp without loading it.
-- Keymaps below are plain :cmd strings, so the plugin loads on first use.

-- Keymaps
vim.keymap.set("n", "<leader>gv", "<cmd>DiffviewOpen<cr>", { desc = "Diffview open" })
vim.keymap.set("n", "<leader>gV", "<cmd>DiffviewClose<cr>", { desc = "Diffview close" })
vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory<cr>", { desc = "Repo history" })
vim.keymap.set("n", "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", { desc = "File history" })
