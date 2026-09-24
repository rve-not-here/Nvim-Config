local M = {}

-- creates a slug for the currently selected text and puts it into the clipboard
function M.slugify_visual_selection()
  local selection = vim.fn.getregion(
    vim.fn.getpos("v"),
    vim.fn.getpos("."),
    { type = vim.fn.mode() }
  )

  local slug = table.concat(selection, " ")
      :lower()
      :gsub("ä", "ae")
      :gsub("ö", "oe")
      :gsub("ü", "ue")
      :gsub("ß", "ss")
      :gsub("[^%w%s_-]", "")
      :gsub("[%s_]+", "-")
      :gsub("-+", "-")
      :gsub("^-", "")
      :gsub("-$", "")

  vim.fn.setreg("+", slug)
  vim.notify("Copied slug: " .. slug)
end

-- turns - [ ] into - [X]
function M.toggle_markdown_checkbox()
  local line = vim.api.nvim_get_current_line()
  local updated

  if line:find("%[ %]") then
    updated = line:gsub("%[ %]", "[x]", 1)
  elseif line:find("%[[xX]%]") then
    updated = line:gsub("%[[xX]%]", "[ ]", 1)
  else
    -- Normal Enter behavior: next line, first non-blank character.
    vim.cmd("normal! +")
    return
  end

  vim.api.nvim_set_current_line(updated)
end

M.augroup = vim.api.nvim_create_augroup(
  "markdown_checkbox_toggle",
  { clear = true }
)

return M
