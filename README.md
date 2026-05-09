# dotfiles

My current Arch Linux desktop setup, organized by category instead of
mirroring `$HOME` directly.

Emacs config lives in its own repo: <https://github.com/panjianjiang/emacs.d>.

## Layout

- `arch/`
  Arch package manifests exported from the current machine.
- `config/`
  XDG config files for the Wayland desktop and related tools.
- `git/`
  Git client configuration.
- `shell/`
  Shell startup files and shared environment helper.

## Mapped Sources

- `config/niri/` from `~/.config/niri/`
- `config/foot/` from `~/.config/foot/`
- `config/waybar/` from `~/.config/waybar/`
- `config/fuzzel/` from `~/.config/fuzzel/`
- `config/kanshi/` from `~/.config/kanshi/`
- `config/swayidle/` from `~/.config/swayidle/`
- `config/systemd/user/` from `~/.config/systemd/user/`
- `config/environment.d/` from `~/.config/environment.d/`
- `config/uwsm/` from `~/.config/uwsm/`
- `config/nvim/` from `~/.config/nvim/`
- `shell/` from shell dotfiles under `$HOME`
- `git/.gitconfig` from `~/.gitconfig`

## Included Highlights

- `niri` compositor config
- `foot` terminal config
- `waybar`, `fuzzel`, `kanshi`, `swayidle`, and UWSM/session-related config
- user `systemd` units for the Wayland session
- Neovim config (`vim.pack` + `nvim-treesitter` main + LSPs)
- Arch package manifests for native and foreign packages

## Intentionally Excluded

- secrets, tokens, SSH material, and browser profiles

## Restore Sketch

This repository is organized for readability, not for `stow` or bare-home use.
To restore configs, copy the relevant files back to their original locations.

Examples:

```sh
cp config/niri/config.kdl ~/.config/niri/
cp shell/.bashrc ~/
cp config/nvim/init.lua ~/.config/nvim/
```

## Package Lists

- `arch/packages-explicit-native.txt`
- `arch/packages-explicit-foreign.txt`

They were generated from the current machine with:

```sh
pacman -Qqen | sort
pacman -Qqem | sort
```
