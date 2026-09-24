-- Extra LSP servers, ported from NvChad configs/lspconfig.lua (2026-08).
-- Configs resolve via neovim/nvim-lspconfig (vim.pack). Each server is only
-- enabled when its binary exists, so :checkhealth stays warning-free and
-- installing a server later Just Works on next restart.
local function exe(bin)
  return vim.fn.executable(bin) == 1
end

local servers = {
  -- { config name, binary on $PATH }
  { "html", "vscode-html-language-server" },
  { "cssls", "vscode-css-language-server" },
  { "yamlls", "yaml-language-server" },
  { "dockerls", "docker-langserver" },
  { "ansiblels", "ansible-language-server" },
  { "basedpyright", "basedpyright" },
  { "marksman", "marksman" },
  -- web + php (2026-09)
  { "intelephense", "intelephense" },
  { "emmet_language_server", "emmet-language-server" },
}

for _, s in ipairs(servers) do
  if exe(s[2]) then
    pcall(vim.lsp.enable, s[1])
  end
end

-- TypeScript: `tsc` is the official server (TS 7+ native `--lsp`);
-- fall back to typescript-language-server when tsc isn't installed.
if exe("tsc") then
  pcall(function()
    vim.lsp.config("tsc", {
      filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json" },
    })
    vim.lsp.enable("tsc")
  end)
elseif exe("typescript-language-server") then
  pcall(vim.lsp.enable, "ts_ls")
end

-- NOTE: bicep needs the Bicep.LangServer.dll (previously via mason).
-- Install one day: dotnet tool + lspconfig bicep.lua, then add here.
