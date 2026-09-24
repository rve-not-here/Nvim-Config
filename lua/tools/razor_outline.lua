-- Razor outline in Snacks (ported display layer; collection + positions
-- come from ramboe's treesitter collector, no LSP needed since Roslyn
-- returns zero documentSymbols for razor).
local M = {}

function M.pick()
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.bo[bufnr].filetype ~= "razor" then
    vim.notify("Razor outline: not a razor buffer", vim.log.levels.WARN)
    return
  end
  local ok_collect, collect = pcall(require, "fzf-lua-pickers-razor-outline.collect_outline")
  if not ok_collect then
    vim.notify("Razor outline collector missing", vim.log.levels.ERROR)
    return
  end
  local ok_items, entries = pcall(collect.collect_outline_items, bufnr)
  if not ok_items or not entries or #entries == 0 then
    vim.notify("No outline items", vim.log.levels.INFO)
    return
  end
  local file = vim.api.nvim_buf_get_name(bufnr)
  local items = {}
  for _, e in ipairs(entries) do
    local line, col, rest = e:match("^(%d+):(%d+)%s+(.*)$")
    if line then
      items[#items + 1] = {
        text = rest,
        file = file,
        pos = { tonumber(line), tonumber(col) },
      }
    end
  end
  Snacks.picker({
    title = "Razor Outline",
    finder = function()
      return items
    end,
    format = "text",
    preview = "preview",
    confirm = function(picker, item)
      picker:close()
      if item and item.pos then
        vim.api.nvim_win_set_cursor(0, { item.pos[1], math.max(0, (item.pos[2] or 1) - 1) })
      end
    end,
  })
end

return M
