# nvim

My editor. Neovim 0.12+, stock `vim.pack`, no plugin manager to babysit.

## Install

```sh
git clone git@github.com:rve-not-here/nvim.git ~/.config/nvim
nvim --headless "+qa"
```

Two native builds, once:

```sh
nvim --headless -c "lua require('blink.cmp').build():pwait()" -c "qa!"
make -C ~/.local/share/nvim/site/pack/core/opt/LuaSnip install_jsregexp
```
