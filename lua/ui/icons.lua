-- ui/icons.lua
local ok, devicons = pcall(require, "nvim-web-devicons")
if not ok then return end

devicons.setup({
  override = {
    cs     = { icon = "",  color = "#4ec9b0", cterm_color = "74", name = "CSharp" },
    csproj = { icon = "󰌛",  color = "#4ec9b0", cterm_color = "74", name = "CSharpProject" },
    sln    = { icon = "󰘐",  color = "#4ec9b0", cterm_color = "74", name = "Solution" },
    xaml   = { icon = "󰙳", color = "#4ec9b0", cterm_color = "74", name = "Xaml" },
  },
  default = true,
})
