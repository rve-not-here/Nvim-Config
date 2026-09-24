local ok, img_clip = pcall(require, "img-clip")
if not ok then
  return
end

img_clip.setup({
  default = {
    dir_path = "assets",
    relative_to_current_file = true,
    -- Ask for an image name when pasting.
    prompt_for_file_name = true,
    -- Insert relative paths, not absolute filesystem paths.
    use_absolute_path = false,
  },
})

vim.keymap.set("n", "<leader>ip", "<cmd>PasteImage<cr>", { desc = "Paste clipboard image" })
