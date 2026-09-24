local ok, wk = pcall(require, "which-key")
if not ok then
  return
end

wk.setup({
  preset = "helix", -- "classic" | "modern" | "helix"
  delay = 300,
  icons = {
    mappings = true, -- uses nvim-web-devicons, which you already have
    rules = {},
  },
  win = {
    border = "rounded",
  },
})

wk.add({
  { "<leader>s", group = "Split" },
  { "<leader>b", group = "Buffer" },
  { "<leader>d", group = "Debug (DAP)" },
  { "<leader>D", group = "Dotnet" },
  { "<leader>h", group = "Hunk" },
  { "<leader>x", group = "Trouble" },
  { "<leader>n", group = "Notifications" },
  { "<leader>o", group = "Outline" },
  { "<leader>p", group = "Packages" },
  { "<leader>g", group = "Git" },
  { "<leader>f", group = "Find (Snacks)" },
  { "<leader>c", group = "Code" },
  { "<leader>t", group = "Test" },
})
