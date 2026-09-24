-- Dynamic palette: reads the current Omarchy theme's colors.toml
-- Falls back to Solarized Dark if unavailable.

local M = {}

------------------------------------------------------------
-- helpers
------------------------------------------------------------
local function read_colors_toml()
  local path = vim.fn.expand("~/.local/state/omarchy/current/theme/colors.toml")
  local f = io.open(path, "r")
  if not f then
    return nil
  end
  local colors = {}
  for line in f:lines() do
    local key, val = line:match("^%s*([%w_]+)%s*=%s*\"(#[0-9a-fA-F]+)\"")
    if key and val then
      colors[key] = val:lower()
    end
  end
  f:close()
  return colors
end

local function hex_to_rgb(hex)
  hex = hex:gsub("#", "")
  return {
    r = tonumber(hex:sub(1, 2), 16),
    g = tonumber(hex:sub(3, 4), 16),
    b = tonumber(hex:sub(5, 6), 16),
  }
end

local function rgb_to_hex(r, g, b)
  return string.format("#%02x%02x%02x", r, g, b)
end

local function mix(c1, c2, t)
  local a, b = hex_to_rgb(c1), hex_to_rgb(c2)
  return rgb_to_hex(
    math.floor(a.r + (b.r - a.r) * t + 0.5),
    math.floor(a.g + (b.g - a.g) * t + 0.5),
    math.floor(a.b + (b.b - a.b) * t + 0.5)
  )
end

------------------------------------------------------------
-- fallback: Solarized Dark
------------------------------------------------------------
local fallback = {
  background = "#000000",
  dark_background = "#0a0a0a",
  darker_background = "#050505",
  lighter_background = "#141414",
  foreground = "#839496",
  dark_foreground = "#586e75",
  light_foreground = "#93a1a1",
  bright_foreground = "#eee8d5",
  muted = "#1f1f1f",
  red = "#dc322f",
  yellow = "#b58900",
  orange = "#cb4b16",
  green = "#859900",
  cyan = "#2aa198",
  blue = "#268bd2",
  magenta = "#d33682",
  brown = "#073642",
  accent = "#268bd2",
  selection = "#1c1c1c",
}

------------------------------------------------------------
-- build palette from colors.toml (merge with fallback for missing keys)
------------------------------------------------------------
local loaded = read_colors_toml()
local c = {}
for k, v in pairs(fallback) do
  c[k] = v
end
if loaded then
  for k, v in pairs(loaded) do
    c[k] = v
  end
end

-- minimal themes (e.g. Last Horizon) omit orange/brown: derive them so
-- PreProc/Include etc. don't fall back to bright Solarized values
if not loaded or not loaded.orange then
  c.orange = mix(c.red, c.yellow, 0.5)
end
if not loaded or not loaded.brown then
  c.brown = mix(c.red, c.background, 0.4)
end

-- some themes set lighter_background == background (e.g. Last Horizon):
-- lift it so floats/popups (bg2) stay distinguishable from Normal (bg0)
if
  loaded
  and loaded.lighter_background
  and loaded.background
  and loaded.lighter_background:lower() == loaded.background:lower()
then
  c.lighter_background = mix(c.background, c.foreground, 0.06)
end

-- derive purple = magenta (alias used by statusline)
if not c.purple then
  c.purple = c.magenta
end
if not c.bright_purple then
  c.bright_purple = c.bright_magenta or c.magenta
end

-- backgrounds
M.bg0 = c.background
M.bg1 = c.dark_background
M.bg2 = c.lighter_background
M.bg3 = mix(c.dark_background, c.lighter_background, 0.5)

-- foregrounds (7-shade scale)
M.fg0 = c.bright_foreground
M.fg1 = c.light_foreground
M.fg2 = mix(c.foreground, c.light_foreground, 0.5)
M.fg3 = c.foreground
M.fg4 = mix(c.foreground, c.dark_foreground, 0.5)
M.fg5 = c.dark_foreground
M.fg6 = mix(c.dark_foreground, c.background, 0.5)

-- accents
M.red = c.red
M.orange = c.orange
M.yellow = c.yellow
M.green = c.green
M.cyan = c.cyan
M.blue = c.blue
M.violet = c.purple
M.magenta = c.magenta

-- UI colors (derived from theme)
M.bg_status = mix(c.background, c.dark_background, 0.5)
M.bg_visual = mix(c.background, c.lighter_background, 0.7)
M.bg_search = mix(c.background, c.yellow, 0.08)
M.fg_dim = c.muted

-- statusline sub-table
M.statusline = {
  fg = M.fg3,
  bg = M.bg_status,
  dark = M.bg1,
  surface = M.bg2,
  border = M.bg3,
  red = M.red,
  green = M.green,
  yellow = M.yellow,
  blue = M.blue,
  purple = M.violet,
  cyan = M.cyan,
  -- readable dim metadata (~4.4:1; raw fg5 is ~2.4:1)
  gray = mix(M.fg5, M.fg1, 0.3),
}

-- Active omarchy theme name (e.g. "last-horizon"), used for per-theme tweaks.
local function read_theme_name()
  local f = io.open(vim.fn.expand("~/.local/state/omarchy/current/theme.name"), "r")
  if not f then
    return nil
  end
  local name = f:read("*l")
  f:close()
  if name then
    name = name:lower():gsub("%s+", "")
  end
  return name
end
M.theme_name = read_theme_name()

-- exported so colorscheme.lua can build theme-aware tints
M.mix = mix

-- Re-read colors.toml and rebuild every field by clearing the require cache.
-- Lets callers pick up a live `omarchy theme set` without a restart.
function M.reload()
  package.loaded["ui.palette"] = nil
  return require("ui.palette")
end

return M
