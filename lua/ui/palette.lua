-- Solarized Dark Palette (optimized for true black background)
local M = {}

-- Backgrounds (smoother progression)
M.bg0 = "#000000" -- true black (Normal bg)
M.bg1 = "#0a0a0a" -- subtle alt bg (floats, cursorline)
M.bg2 = "#141414" -- raised surfaces (pmenu, visual)
M.bg3 = "#1f1f1f" -- highest surface (selection, statusline)

-- Foregrounds (better readability)
M.fg0 = "#fdf6e3" -- brightest (rare use)
M.fg1 = "#eee8d5" -- bright emphasis
M.fg2 = "#93a1a1" -- subtext, cursorlineNr
M.fg3 = "#839496" -- Normal fg
M.fg4 = "#657b83" -- deemphasised
M.fg5 = "#586e75" -- comments, LineNr
M.fg6 = "#073642" -- barely visible

-- Accents (Solarized - slightly adjusted for dark bg)
M.red = "#dc322f" -- errors, delete
M.orange = "#cb4b16" -- warnings, preprocessor
M.yellow = "#b58900" -- types, search
M.green = "#859900" -- strings, success
M.cyan = "#2aa198" -- constants, methods
M.blue = "#268bd2" -- functions, identifiers
M.violet = "#6c71c4" -- special, attributes
M.magenta = "#d33682" -- numbers, booleans

-- Additional UI colors
M.bg_status = "#0f0f0f" -- statusline bg
M.bg_visual = "#1c1c1c" -- visual selection
M.bg_search = "#2a1a00" -- search highlight bg
M.fg_dim = "#4a555b" -- extra dim foreground

-- Statusline-specific aliases
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
	gray = M.fg5,
}

return M
