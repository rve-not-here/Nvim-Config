-- ui/statusline.lua
local ok, heirline = pcall(require, "heirline")
if not ok then
  return
end

local conditions = require("heirline.conditions")
local utils = require("heirline.utils")
local p = require("ui.palette").statusline
local ok_d, devicons = pcall(require, "nvim-web-devicons")
local ok_n, navic = pcall(require, "nvim-navic")

------------------------------------------------------------
-- helpers
------------------------------------------------------------
local space = { provider = " " }
local align_right = { provider = "%=" }

local function get_icon(filename)
  if not ok_d then
    return "", nil
  end
  local ext = vim.fn.fnamemodify(filename, ":e")
  return devicons.get_icon_color(filename, ext, { default = true })
end

-- icon+color cached per filename (weak table; cleared on theme reload
-- since this module is re-required by theme_watcher)
local icon_cache = setmetatable({}, { __mode = "v" })
local function cached_icon(filename)
  if filename == "" then
    return "", nil
  end
  local hit = icon_cache[filename]
  if hit then
    return hit[1], hit[2]
  end
  local icon, color = get_icon(filename)
  icon_cache[filename] = { icon, color }
  return icon, color
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
    local icon = cached_icon(vim.fn.fnamemodify(name, ":t"))
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
  provider = " " .. vim.fn.nr2char(0xf00d) .. " ",
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
      bg = "NONE",
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
    -- nr2char codes: literal PUA glyphs don't survive editing, so
    -- FontAwesome codepoints are used (gear/pencil/eye/table/exchange/term)
    local icons = {
      n = vim.fn.nr2char(0xf013),
      i = vim.fn.nr2char(0xf040),
      v = vim.fn.nr2char(0xf06e),
      V = vim.fn.nr2char(0xf06e),
      ["\22"] = vim.fn.nr2char(0xf0ce),
      c = " ",
      r = vim.fn.nr2char(0xf0ec),
      t = vim.fn.nr2char(0xf120),
    }
    local m = vim.fn.mode()
    return " " .. (icons[m] or m:upper()) .. " "
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
      t = p.green,
    }
    return {
      fg = mode_colors[vim.fn.mode()] or p.gray,
      bg = "NONE",
      bold = true,
    }
  end,
}

local recording = {
  -- single reg_recording() call (was in both condition + provider)
  provider = function()
    local reg = vim.fn.reg_recording()
    if reg == "" then
      return ""
    end
    return " ● rec " .. reg .. " "
  end,
  hl = { fg = p.red, bg = "NONE", bold = true },
}

local lsp_status = {
  -- single get_clients() call (was called in both condition + provider)
  provider = function()
    local names = {}
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
      names[#names + 1] = client.name
    end
    if #names == 0 then
      return ""
    end
    return "  " .. table.concat(names, ", ") .. " "
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

-- file components (statusline keeps icon+name; breadcrumbs live in winbar)
local file_icon = {
  provider = function()
    local icon = cached_icon(vim.fn.expand("%:t"))
    return icon .. " "
  end,
  hl = function()
    local _, color = cached_icon(vim.fn.expand("%:t"))
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

-- breadcrumbs for winbar (TS walk throttled; was evaluated every redraw)
local breadcrumbs = {
  condition = function()
    return ok_n and navic.is_available()
  end,
  provider = function()
    return ok_n and navic.get_location() or ""
  end,
  hl = { fg = p.gray },
  update = { "BufEnter", "BufWinEnter", "CursorHold", "InsertLeave" },
}

------------------------------------------------------------
-- statusline: right
------------------------------------------------------------
local file_type = {
  provider = function()
    local ft = vim.bo.filetype
    return ft ~= "" and (" " .. ft .. " ") or ""
  end,
  hl = { fg = p.blue, bg = "NONE", bold = true },
}

local diagnostics = {
  condition = conditions.has_diagnostics,
  provider = function()
    local diag = vim.diagnostic.count(0) or {}
    local severities = {
      { vim.diagnostic.severity.ERROR, "DiagnosticSignError", vim.fn.nr2char(0xf06a) .. " " },
      { vim.diagnostic.severity.WARN, "DiagnosticSignWarn", vim.fn.nr2char(0xf071) .. " " },
      { vim.diagnostic.severity.INFO, "DiagnosticSignInfo", vim.fn.nr2char(0xf05a) .. " " },
      { vim.diagnostic.severity.HINT, "DiagnosticSignHint", vim.fn.nr2char(0xf0eb) .. " " },
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

-- fixed 6-char width so the right side never shifts while scrolling
local scroll_percent = {
  provider = function()
    local curr = vim.fn.line(".")
    local total = vim.fn.line("$")
    if total <= 1 or curr <= 1 then
      return "  Top "
    end
    if curr >= total then
      return "  Bot "
    end
    return string.format(" %3d%%%% ", math.floor(curr / total * 100))
  end,
  hl = { fg = p.gray },
}

-- line width sized to the file (stable per file), column fixed 3 wide
local position = {
  provider = function()
    local w = #tostring(vim.fn.line("$"))
    return string.format("  %" .. w .. "d:%-3d ", vim.fn.line("."), vim.fn.col("."))
  end,
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
    scroll_percent,
    position,
  },
})

-- transparent bars: clear background fills so the terminal background
-- shows through (re-applied on colorscheme change)
local function transparent_statusline()
  vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "TabLine", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "TabLineSel", { bg = "NONE" })
end
transparent_statusline()
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("statusline_transparent", { clear = true }),
  callback = transparent_statusline,
})
