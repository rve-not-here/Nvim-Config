return function()
  local ok, blink = pcall(require, "blink.cmp")
  if not ok then
    vim.notify("blink.cmp not found", vim.log.levels.ERROR)
    return
  end

  blink.setup({
    snippets = {
      preset = "luasnip",
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      per_filetype = {
        cs = { "lsp", "snippets", "buffer", "path" },
      },
      providers = {
        lsp = {
          transform_items = function(_, items)
            for _, item in ipairs(items) do
              local text = item.textEdit and item.textEdit.newText or item.insertText
              if text
                and not text:match("%(")
                and (item.kind == vim.lsp.protocol.CompletionItemKind.Method
                  or item.kind == vim.lsp.protocol.CompletionItemKind.Function)
              then
                if item.textEdit then
                  item.textEdit.newText = text .. "()"
                end
              end
            end
            return items
          end,
        },
      },
    },
    fuzzy = {
      implementation = "lua",
    },
    completion = {
      accept = {
        auto_brackets = {
          enabled = true,
        },
      },
      trigger = {
        show_on_keyword = true,
        show_on_trigger_character = true,
      },
      list = {
        selection = {
          preselect = true,
          auto_insert = true,
        },
      },
      documentation = {
        auto_show = true,
        window = {
          border = "single",
          winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder",
        },
      },
      menu = {
        border = "single",
        winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection",
        -- Removed: format field is not valid in this version
      },
    },
    signature = {
      enabled = true,
      window = {
        border = "single",
        winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder",
      },
    },
    keymap = {
      preset = "default",
      ["<CR>"] = { "accept", "fallback" },
      ["<C-Space>"] = { "show", "show_documentation", "hide_documentation", "fallback" },
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
    },
    appearance = {
      nerd_font_variant = "normal",
      kind_icons = {
        Text = "󰉿",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "",
        Field = "󰜢",
        Variable = "󰀫",
        Class = "󰠱",
        Interface = "",
        Module = "",
        Property = "󰜢",
        Unit = "󰑭",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "󰈇",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "󰙅",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "󰉺",
      },
    },
  })
end
