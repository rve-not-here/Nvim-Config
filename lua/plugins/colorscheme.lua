local M = {}

-- Applies every highlight from the current theme palette. Wrapped in a function
-- so it can be re-run when `omarchy theme set` swaps the colors.toml live.
local hl = function(group, opts)
	vim.api.nvim_set_hl(0, group, opts)
end

local function apply(p)

-- ── Base editor ──────────────────────────────────────────────────────────────
hl("Normal", { fg = p.fg3, bg = p.bg0 })
hl("NormalNC", { fg = p.fg4, bg = p.bg0 })

hl("LineNr", { fg = p.mix(p.fg5, p.fg1, 0.25), bg = p.bg0 })
hl("CursorLineNr", { fg = p.fg2, bg = p.bg1, bold = true })
hl("CursorColumn", { bg = p.bg1 })
hl("ColorColumn", { bg = p.bg1 })
hl("SignColumn", { fg = p.fg5, bg = p.bg0 })

-- visible warm selection band (text on it stays ~13:1)
hl("Visual", { bg = p.mix(p.bg0, p.blue, 0.22) })
hl("VisualNOS", { bg = p.bg2 })

-- Search: Solarized convention uses bold for matches
hl("Search", { fg = p.bg0, bg = p.yellow, bold = true })
hl("IncSearch", { fg = p.bg0, bg = p.orange, bold = true })
hl("CurSearch", { fg = p.bg0, bg = p.red, bold = true })
hl("Substitute", { fg = p.bg0, bg = p.red, bold = true })

hl("MatchParen", { fg = p.orange, bold = true, underline = true })

hl("Folded", { fg = p.fg4, bg = p.bg1, italic = true })
hl("FoldColumn", { fg = p.fg5, bg = p.bg0 })

hl("WinSeparator", { fg = p.bg3, bg = "none" })
hl("VertSplit", { fg = p.bg3, bg = "none" })

-- Statusline: subtle hierarchy
hl("StatusLine", { fg = p.fg2, bg = p.bg1 })
hl("StatusLineNC", { fg = p.fg5, bg = p.bg0 })
hl("TabLine", { fg = p.fg5, bg = p.bg0 })
hl("TabLineSel", { fg = p.fg1, bg = p.bg2, bold = true })
hl("TabLineFill", { bg = p.bg0 })

-- Popups
hl("Pmenu", { fg = p.fg3, bg = p.bg2 })
hl("PmenuSel", { fg = p.bg0, bg = p.blue, bold = true })
hl("PmenuSbar", { bg = p.bg1 })
hl("PmenuThumb", { bg = p.fg5 })
hl("PmenuExtra", { fg = p.fg4, italic = true })

hl("FloatBorder", { fg = p.mix(p.bg2, p.fg1, 0.25), bg = p.bg2 })
hl("NormalFloat", { fg = p.fg3, bg = p.bg2 })
hl("FloatTitle", { fg = p.blue, bg = p.bg2, bold = true })

-- Whitespace
hl("EndOfBuffer", { fg = p.bg1 })
hl("NonText", { fg = p.bg3 })
hl("SpecialKey", { fg = p.bg3 })
hl("Whitespace", { fg = p.bg2 })

hl("Title", { fg = p.yellow, bold = true })
hl("Directory", { fg = p.blue, bold = true })

hl("QuickFixLine", { bg = p.bg2 })
hl("qfLineNr", { fg = p.fg5 })

-- ── Syntax ────────────────────────────────────────────────────────────────────
-- readable muted tone (~5:1 on bg0; raw fg5 is ~2.4:1, nearly invisible)
hl("Comment", { fg = p.mix(p.fg5, p.fg1, 0.4), italic = true })

-- Literals: Solarized emphasizes constants
hl("Constant", { fg = p.cyan })
hl("String", { fg = p.cyan })
hl("Character", { fg = p.cyan })
hl("Number", { fg = p.magenta })
hl("Boolean", { fg = p.magenta })
hl("Float", { fg = p.magenta })

-- Identifiers
hl("Identifier", { fg = p.blue })
hl("Function", { fg = p.blue })

-- Control flow
hl("Statement", { fg = p.green, bold = true })
hl("Keyword", { fg = p.green, bold = true })
hl("Conditional", { fg = p.green })
hl("Repeat", { fg = p.green })
hl("Label", { fg = p.green })

hl("Operator", { fg = p.green })
hl("Exception", { fg = p.red, bold = true })

-- Preprocessor
hl("PreProc", { fg = p.orange })
hl("Include", { fg = p.orange })
hl("Define", { fg = p.orange })
hl("Macro", { fg = p.orange })

-- Types
hl("Type", { fg = p.yellow })
hl("StorageClass", { fg = p.yellow, bold = true })
hl("Structure", { fg = p.yellow })
hl("Typedef", { fg = p.yellow })

hl("Special", { fg = p.red })
hl("Delimiter", { fg = p.fg4 })
hl("SpecialComment", { fg = p.mix(p.fg5, p.fg1, 0.4), italic = true })
hl("Todo", { fg = p.magenta, bold = true })
hl("Error", { fg = p.red, bold = true, underline = true })
hl("Underlined", { underline = true })

-- ── Treesitter ────────────────────────────────────────────────────────────────
-- Variables
hl("@variable", { fg = p.blue })
hl("@variable.builtin", { fg = p.orange })
hl("@variable.parameter", { fg = p.cyan, italic = true })
hl("@variable.member", { fg = p.blue })

-- Constants
hl("@constant", { fg = p.cyan })
hl("@constant.builtin", { fg = p.orange })
hl("@constant.macro", { fg = p.orange })

-- Strings
hl("@string", { fg = p.cyan })
hl("@string.escape", { fg = p.magenta, bold = true })
hl("@string.special", { fg = p.magenta })
hl("@string.regexp", { fg = p.orange })

-- Numbers/Booleans
hl("@number", { fg = p.magenta })
hl("@number.float", { fg = p.magenta })
hl("@boolean", { fg = p.magenta })

-- Functions
hl("@function", { fg = p.blue })
hl("@function.builtin", { fg = p.blue, italic = true })
hl("@function.call", { fg = p.blue })
hl("@function.method", { fg = p.blue })
hl("@function.method.call", { fg = p.blue })
hl("@constructor", { fg = p.blue, bold = true })

-- Keywords
hl("@keyword", { fg = p.green, bold = true })
hl("@keyword.operator", { fg = p.green })
hl("@keyword.return", { fg = p.green })
hl("@keyword.import", { fg = p.orange })
hl("@keyword.exception", { fg = p.red, bold = true })
hl("@keyword.conditional", { fg = p.green })
hl("@keyword.repeat", { fg = p.green })

-- Types
hl("@type", { fg = p.yellow })
hl("@type.builtin", { fg = p.yellow, italic = true })
hl("@type.qualifier", { fg = p.green })
hl("@type.definition", { fg = p.yellow })

hl("@attribute", { fg = p.violet })
hl("@namespace", { fg = p.blue, italic = true })
hl("@module", { fg = p.blue })
hl("@operator", { fg = p.green })
hl("@punctuation.bracket", { fg = p.fg4 })
hl("@punctuation.delimiter", { fg = p.fg4 })

-- Comments
hl("@comment", { fg = p.mix(p.fg5, p.fg1, 0.4), italic = true })
hl("@comment.todo", { fg = p.magenta, bold = true })
hl("@comment.warning", { fg = p.orange, bold = true })
hl("@comment.error", { fg = p.red, bold = true })
hl("@comment.note", { fg = p.cyan, bold = true })

-- HTML/XML tags
hl("@tag", { fg = p.blue })
hl("@tag.attribute", { fg = p.cyan })
hl("@tag.delimiter", { fg = p.fg5 })

-- ── Diagnostics ───────────────────────────────────────────────────────────────
-- static diagnostic hues: instantly recognizable on ANY system theme,
-- deliberately not synced (literals survive the lucent layer untouched)
hl("DiagnosticError", { fg = "#e06c75" })
hl("DiagnosticWarn", { fg = "#e5c07b" })
hl("DiagnosticInfo", { fg = "#61afef" })
hl("DiagnosticHint", { fg = "#56b6c2" })
hl("DiagnosticOk", { fg = p.green })

hl("DiagnosticUnderlineError", { sp = "#e06c75", undercurl = true })
hl("DiagnosticUnderlineWarn", { sp = "#e5c07b", undercurl = true })
hl("DiagnosticUnderlineInfo", { sp = "#61afef", undercurl = true })
hl("DiagnosticUnderlineHint", { sp = "#56b6c2", undercurl = true })

hl("DiagnosticSignError", { fg = "#e06c75" })
hl("DiagnosticSignWarn", { fg = "#e5c07b" })
hl("DiagnosticSignInfo", { fg = "#61afef" })
hl("DiagnosticSignHint", { fg = "#56b6c2" })

-- native overlay text: bold severity colors, arrow inherits the line
hl("DiagnosticVirtualTextError", { fg = "#e06c75", bold = true })
hl("DiagnosticVirtualTextWarn", { fg = "#e5c07b", bold = true })
hl("DiagnosticVirtualTextInfo", { fg = "#61afef" })
hl("DiagnosticVirtualTextHint", { fg = "#56b6c2" })

-- ── LSP semantic tokens ───────────────────────────────────────────────────────
hl("@lsp.type.namespace", { link = "@namespace" })
hl("@lsp.type.class", { link = "@type" })
hl("@lsp.type.struct", { link = "@type" })
hl("@lsp.type.interface", { fg = p.yellow })
hl("@lsp.type.enum", { fg = p.yellow })
hl("@lsp.type.enumMember", { fg = p.cyan })
hl("@lsp.type.property", { link = "@variable.member" })
hl("@lsp.type.method", { link = "@function.method" })
hl("@lsp.type.function", { link = "@function" })
hl("@lsp.type.parameter", { link = "@variable.parameter" })
hl("@lsp.type.variable", { link = "@variable" })
hl("@lsp.type.keyword", { link = "@keyword" })
hl("@lsp.type.string", { link = "@string" })
hl("@lsp.type.number", { link = "@number" })
hl("@lsp.type.typeParameter", { fg = p.violet, italic = true })
hl("@lsp.mod.deprecated", { strikethrough = true })
hl("@lsp.mod.readonly", { italic = true })
hl("@lsp.mod.static", { italic = true })

-- ── Diff / Git ────────────────────────────────────────────────────────────────
-- theme-aware bands (were hardcoded solarized darks, invisible here)
hl("DiffAdd", { bg = p.mix(p.bg0, p.green, 0.15) })
hl("DiffChange", { bg = p.mix(p.bg0, p.yellow, 0.15) })
hl("DiffDelete", { fg = p.red, bg = p.mix(p.bg0, p.red, 0.15) })
hl("DiffText", { bg = p.mix(p.bg0, p.yellow, 0.3), bold = true })

hl("diffAdded", { fg = p.green })
hl("diffRemoved", { fg = p.red })
hl("diffChanged", { fg = p.yellow })
hl("diffFile", { fg = p.blue, bold = true })
hl("diffNewFile", { fg = p.green, bold = true })
hl("diffOldFile", { fg = p.red, bold = true })

-- gitsigns
hl("GitSignsAdd", { fg = p.green })
hl("GitSignsChange", { fg = p.yellow })
hl("GitSignsDelete", { fg = p.red })
hl("GitSignsAddNr", { fg = p.green })
hl("GitSignsChangeNr", { fg = p.yellow })
hl("GitSignsDeleteNr", { fg = p.red })

-- ── blink.cmp ─────────────────────────────────────────────────────────────────
hl("BlinkCmpMenu", { fg = p.fg3, bg = p.bg2 })
hl("BlinkCmpMenuBorder", { fg = p.bg3, bg = p.bg2 })
hl("BlinkCmpMenuSelection", { fg = p.bg0, bg = p.blue, bold = true })
hl("BlinkCmpLabel", { fg = p.fg3 })
hl("BlinkCmpLabelDetail", { fg = p.fg4, italic = true })
hl("BlinkCmpLabelMatch", { fg = p.magenta, bold = true })
hl("BlinkCmpLabelDeprecated", { fg = p.fg5, strikethrough = true })
hl("BlinkCmpDoc", { fg = p.fg3, bg = p.bg2 })
hl("BlinkCmpDocBorder", { fg = p.bg3, bg = p.bg2 })
hl("BlinkCmpKindText", { fg = p.fg3 })
hl("BlinkCmpKindMethod", { fg = p.blue })
hl("BlinkCmpKindFunction", { fg = p.blue })
hl("BlinkCmpKindConstructor", { fg = p.blue })
hl("BlinkCmpKindField", { fg = p.cyan })
hl("BlinkCmpKindVariable", { fg = p.blue })
hl("BlinkCmpKindClass", { fg = p.yellow })
hl("BlinkCmpKindInterface", { fg = p.yellow })
hl("BlinkCmpKindModule", { fg = p.blue })
hl("BlinkCmpKindProperty", { fg = p.cyan })
hl("BlinkCmpKindEnum", { fg = p.yellow })
hl("BlinkCmpKindEnumMember", { fg = p.cyan })
hl("BlinkCmpKindKeyword", { fg = p.green })
hl("BlinkCmpKindSnippet", { fg = p.magenta })
hl("BlinkCmpKindColor", { fg = p.magenta })
hl("BlinkCmpKindConstant", { fg = p.cyan })
hl("BlinkCmpKindReference", { fg = p.fg2 })

-- ── todo-comments ─────────────────────────────────────────────────────────────
hl("TodoBgTODO", { fg = p.bg0, bg = p.yellow, bold = true })
hl("TodoBgFIX", { fg = p.bg0, bg = p.red, bold = true })
hl("TodoBgHACK", { fg = p.bg0, bg = p.orange, bold = true })
hl("TodoBgWARN", { fg = p.bg0, bg = p.orange, bold = true })
hl("TodoBgPERF", { fg = p.bg0, bg = p.violet, bold = true })
hl("TodoBgNOTE", { fg = p.bg0, bg = p.cyan, bold = true })
hl("TodoFgTODO", { fg = p.yellow })
hl("TodoFgFIX", { fg = p.red })
hl("TodoFgHACK", { fg = p.orange })
hl("TodoFgNOTE", { fg = p.cyan })

-- ── Snacks dashboard (explicit roles so it always follows the system
-- theme; snacks only sets these with default=true, ours win and re-apply
-- on theme switch. Blue/orange roles track the lucent layer automatically.)
hl("SnacksDashboardHeader", { fg = p.blue, bold = true })
hl("SnacksDashboardIcon", { fg = p.cyan })
hl("SnacksDashboardKey", { fg = p.blue, bold = true })
hl("SnacksDashboardDesc", { fg = p.fg3 })
hl("SnacksDashboardFooter", { fg = p.fg5 })
hl("SnacksDashboardSpecial", { fg = p.red })
hl("SnacksDashboardNormal", { fg = p.fg3, bg = p.bg0 })
hl("SnacksDashboardDir", { fg = p.fg5 })
hl("SnacksDashboardFile", { fg = p.fg3 })

-- ── Messages / misc ───────────────────────────────────────────────────────────
hl("ErrorMsg", { fg = p.red, bold = true })
hl("WarningMsg", { fg = p.yellow, bold = true })
hl("ModeMsg", { fg = p.blue, bold = true })
hl("MoreMsg", { fg = p.blue })
hl("Question", { fg = p.cyan, bold = true })

hl("SpellBad", { sp = p.red, undercurl = true })
hl("SpellCap", { sp = p.yellow, undercurl = true })
hl("SpellRare", { sp = p.violet, undercurl = true })
hl("SpellLocal", { sp = p.cyan, undercurl = true })

hl("Conceal", { fg = p.fg5 })
hl("Ignore", { fg = p.bg3 })
hl("MsgSeparator", { fg = p.bg3 })

-- ── Additional UI highlights ──────────────────────────────────────────────────
hl("CursorLine", { bg = p.bg2 })
hl("LspReferenceText", { bg = p.mix(p.bg0, p.blue, 0.15) })
hl("LspReferenceRead", { bg = p.mix(p.bg0, p.blue, 0.15) })
hl("LspReferenceWrite", { bg = p.mix(p.bg0, p.blue, 0.15) })
end

local palette = require("ui.palette")
apply(palette)

-- lucent-orng look (orange-first, like the opencode theme): shifts accent
-- roles to orange while keeping the system theme's base bg/fg.
-- Auto-enables on Last Horizon; force with vim.g.lucent_orng = true/false.
do
  local force = vim.g.lucent_orng
  if force == true or (force ~= false and palette.theme_name == "last-horizon") then
    local q = vim.deepcopy(palette)
    q.orange = "#EC5B2B" -- primary accent / keywords
    q.blue = "#EE7948" -- functions / operators (warm secondary)
    q.magenta = "#fab387" -- numbers / constants (bright orange)
    q.cyan = "#6ba1e6" -- strings (blue)
    q.yellow = "#e5c07b" -- types
    apply(q)
    -- keywords in primary orange, bold (overrides the green defaults above)
    hl("Statement", { fg = "#EC5B2B", bold = true })
    hl("Keyword", { fg = "#EC5B2B", bold = true })
    hl("@keyword", { fg = "#EC5B2B", bold = true })
    hl("@keyword.return", { fg = "#EC5B2B", bold = true })
    hl("@keyword.exception", { fg = "#e06c75", bold = true })
  end
end

-- Re-apply the current theme (re-reading colors.toml) without a restart.
function M.reload()
	apply(require("ui.palette").reload())
	vim.api.nvim_exec_autocmds("ColorScheme", {})
end

return M

