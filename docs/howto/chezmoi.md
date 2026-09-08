# Chezmoi (Config File Management)

## Contents

- [Documentation](#documentation)
- [How To Use It](#how-to-use-it)
- [Fresh Machine Deployment](#fresh-machine-deployment)

---

## Documentation

[chezmoi docs](https://www.chezmoi.io/)

## How To Use It

Edit a live file, then sync it back into the source and push:

```bash
chezmoi re-add ~/.config/<app>
chezmoi git -- add -A
chezmoi git -- commit -m "feat(<app>): update config"
chezmoi git -- push
```

The `--` is required: without it chezmoi's own flag parser swallows git flags like `-A`.

Alternatively, edit the source repo directly and apply to the live files:

```bash
# edit ~/.local/share/chezmoi/private_dot_config/<app>/...
chezmoi apply
```

Inspect state:

```bash
chezmoi status   # what differs between source and live
chezmoi diff     # preview the changes
chezmoi verify   # confirm live matches source
```

**Gotcha:** do not `chezmoi add` files that tools rewrite themselves (e.g. plugin lockfiles). Chezmoi would flag them as changed on every apply and can clobber local state.

## Fresh Machine Deployment

Nix installs `chezmoi` as part of the shell. On a new machine, one-time setup:

```bash
chezmoi init git@github.com:<user>/<repo>.git --apply
```

Then pull and apply updates:

```bash
chezmoi update
```
