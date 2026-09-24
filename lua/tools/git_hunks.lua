-- Current-buffer git hunks in Snacks (replaces the old fzf git_hunks picker).
-- Parses `git diff -U0` hunk headers; confirm jumps to the hunk.
local M = {}

function M.pick()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("Git hunks: no file", vim.log.levels.WARN)
    return
  end
  local res = vim.system(
    { "git", "--no-pager", "diff", "--no-color", "--no-ext-diff", "-U0", "HEAD", "--", file },
    { text = true, cwd = vim.fs.dirname(file) }
  ):wait()
  if res.code ~= 0 then
    vim.notify("Git hunks: not a repo or git error", vim.log.levels.WARN)
    return
  end
  local items = {}
  for line in (res.stdout or ""):gmatch("[^\n]+") do
    local start, ctx = line:match("^@@ %-%d+,?%d* %+(%d+),?%d* @@%s?(.*)$")
    if start then
      items[#items + 1] = {
        text = ("@@ +%s @@ %s"):format(start, ctx ~= "" and ctx or "(hunk)"),
        file = file,
        pos = { tonumber(start), 1 },
      }
    end
  end
  if #items == 0 then
    vim.notify("Git hunks: clean", vim.log.levels.INFO)
    return
  end
  Snacks.picker({
    title = "Git Hunks",
    finder = function()
      return items
    end,
    format = "text",
    preview = "preview",
    confirm = function(picker, item)
      picker:close()
      if item and item.pos then
        vim.api.nvim_win_set_cursor(0, { item.pos[1], 0 })
      end
    end,
  })
end

return M
