local ok, blink = pcall(require, "blink.cmp")
if not ok then
  return
end

blink.setup({
  snippets = { preset = "luasnip" },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
    per_filetype = {
      cs = { "lsp", "snippets", "buffer", "path" },
    },
  },
  fuzzy = {
    implementation = "prefer_rust",
  },
  completion = {
    accept = {
      auto_brackets = { enabled = true },
    },
    trigger = {
      show_on_keyword = true,
      show_on_trigger_character = true,
    },
    list = {
      selection = { preselect = true, auto_insert = true },
    },
    documentation = {
      auto_show = true,
      window = { border = "single" },
    },
    menu = {
      border = "single",
    },
  },
  signature = { enabled = true },
  keymap = {
    preset = "default",
    ["<CR>"] = { "accept", "fallback" },
    ["<C-Space>"] = { "show", "show_documentation", "hide_documentation", "fallback" },
    ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
    ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
  },
  appearance = {
    nerd_font_variant = "normal",
  },
})
