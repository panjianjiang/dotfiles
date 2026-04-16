# dotfiles

My current Arch Linux desktop and editor setup, organized by category instead
of mirroring `$HOME` directly.

## Layout

- `arch/`
  Arch package manifests exported from the current machine.
- `config/`
  XDG config files for the Wayland desktop and related tools.
- `emacs/`
  Main Emacs config plus local Lisp modules.
- `git/`
  Git client configuration.
- `pharo/`
  Current Pharo image snapshot and companion files.
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
- `emacs/` from `~/.emacs.d/`
- `shell/` from shell dotfiles under `$HOME`
- `git/.gitconfig` from `~/.gitconfig`
- `pharo/` from `~/Pharo/`

## Included Highlights

- `niri` compositor config
- `foot` terminal config
- `waybar`, `fuzzel`, `kanshi`, `swayidle`, and UWSM/session-related config
- user `systemd` units for the Wayland session
- Emacs config including the live Pharo Smalltalk integration
- Neovim config
- Arch package manifests for native and foreign packages
- current Pharo image, `.changes`, and `.sources`

## Intentionally Excluded

- secrets, tokens, SSH material, and browser profiles
- `~/.config/pharo/org.pharo.global-identifiers.ston`
- `~/Pharo/pharo-local/` caches and play history
- Emacs history, backups, `recentf`, `tramp`, and machine-local `init-local.el`

## Notes

- The Pharo image is a live binary snapshot. It is included on purpose, but it
  may contain state that is more machine-specific than ordinary dotfiles.
- The Emacs config expects optional machine-local overrides in
  `emacs/init-local.el`, but that file is intentionally not committed here.

## Restore Sketch

This repository is organized for readability, not for `stow` or bare-home use.
To restore configs, copy the relevant files back to their original locations.

Examples:

```sh
cp config/niri/config.kdl ~/.config/niri/
cp shell/.bashrc ~/
cp emacs/init.el ~/.emacs.d/
cp -r emacs/lisp ~/.emacs.d/
cp pharo/Pharo.image ~/Pharo/
```

## Package Lists

- `arch/packages-explicit-native.txt`
- `arch/packages-explicit-foreign.txt`

They were generated from the current machine with:

```sh
pacman -Qqen | sort
pacman -Qqem | sort
```
