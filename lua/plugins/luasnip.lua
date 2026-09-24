local ok, ls = pcall(require, "luasnip")
if not ok then
  return
end

-- load friendly-snippets (VSCode format) on first insert: the collection
-- scan is the slowest chunk of startup and snippets are insert-only anyway
vim.api.nvim_create_autocmd("InsertEnter", {
  group = vim.api.nvim_create_augroup("luasnip_friendly", { clear = true }),
  once = true,
  callback = function()
    pcall(function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end)
  end,
})

-- some shorthands...
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

--[[ csharp snippets ]]

-- summary
ls.add_snippets("cs", {
  s(
    "/// summary",
    fmt(
      [[
///<summary>
/// {}
///</summary>
    ]],
      { i(1) }
    )
  ),
})

--[[ lua snippets ]]

ls.add_snippets("lua", {
  s("hello", {
    t('print("hello World")'),
  }),
})

--[[ knowledge management snippets ]]

ls.add_snippets("markdown", {
  s(
    "troubleshooting",
    fmt(
      [[
---
type: troubleshooting
tags:
  - {}
---

# {}

## Stack Trace

```
{}
```

## Symptoms

## Fix

## Further Read
    ]],
      {
        i(1, "<tag>"),
        i(3, "<title (error message)>"),
        i(2, "<stack trace>"),
      }
    )
  ),
})

ls.add_snippets("markdown", {
  s(
    "recipe",
    fmt(
      [[
---
type: recipe
tags:
  - {}
---

# {}

## How it works

{}

## Example

```
{}
```

    ]],
      {
        i(1, "<tag>"),
        i(2, "<title>"),
        i(3, "<mental model, invariants, key mechanism>"),
        i(4, "<minimal working example>"),
      }
    )
  ),
})

ls.add_snippets("markdown", {
  s(
    "concept",
    fmt(
      [[
---
type: concept
tags:
  - {}
---

# {}

## Definition
{}

## Why it Matters
{}

## How it works
{}

## Example
<minimal working example>

## Anti-patterns

## Further Read
    ]],
      {
        i(1, "<tag>"),
        i(2, "<title>"),
        i(3, "<1–3 sentences, jargon-free if possible>"),
        i(4, "<the problem it solves / motivation>"),
        i(5, "<mental model, invariants, key mechanism>"),
      }
    )
  ),
})

ls.add_snippets("markdown", {
  s(
    "runbook",
    fmt(
      [[
---
type: runbook
tags:
  - {}
---

# {}

## Goal

## Steps

## Verification

## Further Read
    ]],
      {
        i(1, "<tag>"),
        i(2, "<title>"),
      }
    )
  ),
})
