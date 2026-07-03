local ok, telescope = pcall(require, "telescope")
if not ok then return end

telescope.setup({
  defaults = {
    path_display = { "smart" },
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
      },
    },
    mappings = {
      i = {
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous",
        ["<C-q>"] = "send_selected_to_qflist",
      },
    },
    file_ignore_patterns = {
      "node_modules",
      ".git/",
      "bin/",
      "obj/",
      "%.mp4",
      "%.mkv",
      "%.avi",
      "%.mov",
      "%.webm",
      "%.flv",
      "%.mp3",
      "%.wav",
      "%.flac",
      "%.ogg",
      "%.aac",
      "%.wma",
      "%.jpg",
      "%.jpeg",
      "%.png",
      "%.gif",
      "%.webp",
      "%.bmp",
      "%.svg",
      "%.ico",
      "%.pdf",
      "%.zip",
      "%.tar",
      "%.gz",
      "%.rar",
      "%.7z",
      "%.iso",
      "Videos/",
      "Music/",
      "Pictures/",
      "Downloads/",
    },
  },
  pickers = {
    find_files = {
      hidden = true,
    },
    live_grep = {
      additional_args = { "--hidden" },
    },
    buffers = {
      sort_lastused = true,
    },
  },
})

pcall(telescope.load_extension, "fzf")
pcall(telescope.load_extension, "ui-select")
