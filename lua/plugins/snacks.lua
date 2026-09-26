local ok, snacks = pcall(require, "snacks")
if not ok then
  return
end

local banned_patterns = {
  "No information available",
  "source generator run result",
  "Razor source generator is not referenced",
}

local last_msg, last_time = nil, 0

snacks.setup({
  notifier = {
    enabled = true,
    timeout = 5000,
    top_down = false,
    width = { min = 50, max = 80 },
    height = { min = 1, max = 20 },
    style = "minimal", -- "compact" | "fancy" | "minimal"
    icons = {
      error = "",
      warn = "",
      info = "",
      debug = "",
      trace = "󰌆",
    },
    filter = function(notif)
      for _, pattern in ipairs(banned_patterns) do
        if (notif.msg and notif.msg:match(pattern)) or (notif.title and notif.title:match(pattern)) then
          return false
        end
      end
      -- dedup: drop if same msg fired <1s after the last one
      local now = vim.uv.now()
      if notif.msg == last_msg and (now - last_time) < 1000 then
        return false
      end
      last_msg, last_time = notif.msg, now
      return true
    end,
  },
  bigfile = {
    enabled = true,
    size = 1024 * 1024, -- 1MB, tighter than default 1.5MB, for Roslyn-generated .g.cs files
    setup = function(ctx)
      if vim.fn.exists(":NoMatchParen") ~= 0 then
        vim.cmd("NoMatchParen")
      end
      vim.b.completion = false
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(ctx.buf) then
          vim.bo[ctx.buf].syntax = ctx.ft
        end
      end)
    end,
  },
  quickfile = { enabled = true },
  profiler = { enabled = true }, -- :lua Snacks.profiler.pick() / startup analysis
  statuscolumn = { enabled = true },
  input = { enabled = true },
  words = { enabled = true },
  indent = { -- ibl style
    enabled = true,
    scope = { enabled = false }, -- highlight scope / sakit sa mata
    animate = { enabled = false },
  },
  scroll = { enabled = false },
  dashboard = {
    enabled = true,
    sections = {
      { section = "header" },
      { section = "keys", gap = 1, padding = 1 },
      { section = "mystartup", padding = { 0, 2 } },
      { section = "myupdates" },
    },
    keys = {
      { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.picker.files()" },
      { icon = " ", key = "g", desc = "Live Grep", action = ":lua Snacks.picker.grep()" },
      { icon = " ", key = "r", desc = "Recent", action = ":lua Snacks.picker.recent()" },
      {
        icon = " ",
        key = "c",
        desc = "Config",
        action = ":lua Snacks.picker.files({ cwd = vim.fn.stdpath('config') })",
      },
      { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
      { icon = " ", key = "q", desc = "Quit", action = ":qa" },
    },
  },
  picker = {
    enabled = true,
    ui_select = true,
    -- list on top, preview below, split evenly (sources with their
    -- own layout, like select/vscode, are unaffected)
    layout = {
      layout = {
        backdrop = false,
        width = 0.65,
        min_width = 80,
        height = 0.8,
        min_height = 30,
        box = "vertical",
        border = true,
        title = "{title} {live} {flags}",
        title_pos = "center",
        { win = "preview", title = "{preview}", height = 0.5, border = "hpad" },
        { win = "input", height = 1, border = "top_bottom" },
        { win = "list", border = "none" },
      },
    },
    -- preview like telescope: no number column (was inheriting global
    -- number/numberwidth=5, causing the mismatched band + wide gap)
    win = {
      preview = {
        wo = {
          number = false,
          relativenumber = false,
          signcolumn = "no",
        },
      },
    },
    sources = {
      files = {
        -- filename only (no dimmed parent path taking up space, like telescope)
        formatters = { file = { filename_only = true } },
        -- hide binary / media / archive files from <leader>ff
        -- fd / rg glob syntax: "*.ext"
        exclude = {
          -- images
          "*.png",
          "*.jpg",
          "*.jpeg",
          "*.gif",
          "*.bmp",
          "*.ico",
          "*.webp",
          "*.svg",
          "*.tiff",
          "*.tif",
          "*.psd",
          "*.raw",
          "*.heic",
          "*.heif",
          "*.avif",
          "*.icns",
          -- audio
          "*.mp3",
          "*.wav",
          "*.flac",
          "*.ogg",
          "*.m4a",
          "*.aac",
          "*.opus",
          "*.wma",
          "*.aiff",
          -- video
          "*.mp4",
          "*.mkv",
          "*.avi",
          "*.mov",
          "*.webm",
          "*.flv",
          "*.wmv",
          "*.m4v",
          "*.mpg",
          "*.mpeg",
          -- archives / disk images
          "*.zip",
          "*.tar",
          "*.gz",
          "*.tgz",
          "*.bz2",
          "*.xz",
          "*.rar",
          "*.7z",
          "*.cab",
          "*.iso",
          "*.dmg",
          -- binaries / executables / compiled
          "*.exe",
          "*.dll",
          "*.so",
          "*.dylib",
          "*.o",
          "*.a",
          "*.out",
          "*.bin",
          "*.dat",
          "*.class",
          "*.pyc",
          "*.pyd",
          "*.pyo",
          -- fonts
          "*.ttf",
          "*.otf",
          "*.woff",
          "*.woff2",
          "*.eot",
          "*.fon",
          -- binary docs (remove if you want these in results)
          "*.pdf",
          "*.doc",
          "*.docx",
          "*.xls",
          "*.xlsx",
          "*.ppt",
          "*.pptx",
        },
      },
      grep = {
        -- same excludes for live grep / grep_word so binary names don't pollute results
        exclude = {
          "*.png",
          "*.jpg",
          "*.jpeg",
          "*.gif",
          "*.bmp",
          "*.ico",
          "*.webp",
          "*.svg",
          "*.tiff",
          "*.tif",
          "*.psd",
          "*.raw",
          "*.heic",
          "*.heif",
          "*.avif",
          "*.icns",
          "*.mp3",
          "*.wav",
          "*.flac",
          "*.ogg",
          "*.m4a",
          "*.aac",
          "*.opus",
          "*.wma",
          "*.aiff",
          "*.mp4",
          "*.mkv",
          "*.avi",
          "*.mov",
          "*.webm",
          "*.flv",
          "*.wmv",
          "*.m4v",
          "*.mpg",
          "*.mpeg",
          "*.zip",
          "*.tar",
          "*.gz",
          "*.tgz",
          "*.bz2",
          "*.xz",
          "*.rar",
          "*.7z",
          "*.cab",
          "*.iso",
          "*.dmg",
          "*.exe",
          "*.dll",
          "*.so",
          "*.dylib",
          "*.o",
          "*.a",
          "*.out",
          "*.bin",
          "*.dat",
          "*.class",
          "*.pyc",
          "*.pyd",
          "*.pyo",
          "*.ttf",
          "*.otf",
          "*.woff",
          "*.woff2",
          "*.eot",
          "*.fon",
          "*.pdf",
          "*.doc",
          "*.docx",
          "*.xls",
          "*.xlsx",
          "*.ppt",
          "*.pptx",
        },
      },
    },
  },
})

-- custom startup readout (built-in section needs lazy.nvim, which we
-- don't use): ms since init.lua started, rendered at dashboard open
require("snacks.dashboard").sections.mystartup = function()
  local ms = 0
  if vim.g.start_hrtime then
    ms = math.floor((vim.uv.hrtime() - vim.g.start_hrtime) / 1e6 * 100 + 0.5) / 100
  end
  return {
    align = "center",
    text = {
      { "⚡Neovim loaded in ", hl = "footer" },
      { ms .. "ms", hl = "special" },
    },
  }
end

-- plugin update readout backed by tools/pack_status.lua cache
require("snacks.dashboard").sections.myupdates = function()
  local ok, mod = pcall(require, "tools.pack_status")
  local data = ok and mod.read() or nil
  if not data then
    return { align = "center", text = { { "⟳ checking plugin updates…", hl = "footer" } } }
  end
  if data.count == 0 then
    return {
      align = "center",
      text = { { "✓ " .. data.total .. " plugins up to date", hl = "footer" } },
    }
  end
  return {
    align = "center",
    text = {
      { "↓ " .. data.count .. " plugin update(s): ", hl = "footer" },
      { table.concat(data.names, ", "):sub(1, 60), hl = "special" },
    },
  }
end

-- Keymaps
vim.keymap.set("n", "<leader>nh", function()
  require("snacks").notifier.hide()
end, { desc = "Dismiss all notifications" })
vim.keymap.set("n", "<leader>nl", function()
  require("snacks").notifier.show_history()
end, { desc = "Notification history" })
