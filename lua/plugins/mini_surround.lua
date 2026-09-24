local ok, surround = pcall(require, "mini.surround")
if not ok then return end

surround.setup({
  mappings = {
    add = 'sa',

    delete = 'sd',
    replace = 'sr',

    find = '',
    find_left = '',
    highlight = '',
    update_n_lines = '',
  },

  search_method = 'cover_or_next',
})
