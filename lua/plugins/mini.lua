-- lua/plugins/mini-ai.lua
local ok, ai = pcall(require, "mini.ai")
if not ok then
  return
end

ai.setup({
  n_lines = 500,
  custom_textobjects = {
    o = ai.gen_spec.treesitter({
      a = { "@block.outer", "@conditional.outer", "@loop.outer" },
      i = { "@block.inner", "@conditional.inner", "@loop.inner" },
    }),
    f = ai.gen_spec.treesitter({
      a = { "@function.outer" },
      i = { "@function.inner" },
    }),
    c = ai.gen_spec.treesitter({
      a = { "@class.outer" },
      i = { "@class.inner" },
    }),
  },
})
