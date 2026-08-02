# New Mac setup

Bringing a fresh Mac up to match the current machine.
The system config is declarative: `config/nix/flake.nix` describes every package, cask, and Mac App Store app, and `nix-darwin` applies it.

Budget an hour or so.
Most of it is unattended downloading.

## Order matters

Two steps are easy to get wrong and both cost a full retry:

1. **Install upstream Nix, not Determinate Nix.** See [Step 2](#2-install-nix).
2. **Sign into the Mac App Store before rebuilding.** `mas` cannot log in for you, and the App Store apps are silently skipped otherwise.

## 1. Xcode Command Line Tools

```bash
xcode-select --install
```

This provides `git`, which the rest of the setup needs.

## 2. Install Nix

Use the **official NixOS installer**:

```bash
sh <(curl -L https://nixos.org/nix/install)
```

Do *not* use the Determinate Systems installer (`install.determinate.systems`).
It is widely recommended, and it does handle the macOS APFS volume nicely, but current versions install **Determinate Nix**, a different distribution that ships its own daemon and manages `/etc/nix/nix.custom.conf` itself.
`nix-darwin` also wants to own the daemon and `nix.conf`, so activation aborts with:

```
error: Determinate detected, aborting activation
```

The workaround is setting `nix.enable = false` in the flake, but that would stop `nix-darwin` managing Nix on the existing machine too.
Upstream Nix avoids the whole problem and matches what the current machine runs.

Open a new shell afterwards so `nix` lands on `PATH`.

### If the install fails to mount the Nix Store volume

Symptom, seen on a fresh machine:

```
Failed to execute command `"/usr/sbin/diskutil" "mount" "Nix Store"`
stderr: Volume on disk3s7 failed to mount
```

Accept the offered revert, then reboot.
The `/nix` mountpoint comes from `/etc/synthetic.conf` and only materialises after a restart.
Confirm nothing stale survived before retrying:

```bash
diskutil apfs list | grep -i nix
cat /etc/synthetic.conf 2>/dev/null
```

Both should be empty.
Delete any leftover volume with `sudo diskutil apfs deleteVolume <diskXsY>`.

## 3. Sign into the Mac App Store

Open App Store.app and sign in.
The flake installs DaVinci Resolve, Keystroke Pro, and Tailscale through `mas`, and all three need an active session.

## 4. Clone the dotfiles

The repo is public, so plain HTTPS works with no credentials:

```bash
git clone https://github.com/RichardBray/dotfiles.git ~/dotfiles
```

Use HTTPS rather than the SSH remote here.
The new machine has no SSH key yet, and `gh` does not exist until the rebuild finishes.

## 5. First rebuild

`darwin-rebuild` does not exist yet — it is installed *by* a successful switch.
Bootstrap through `nix run` instead:

```bash
sudo nix run nix-darwin --extra-experimental-features "nix-command flakes" -- \
  switch --flake ~/dotfiles/config/nix#my-mac
```

The `--extra-experimental-features` flag is only needed on this first run.
The upstream installer does not enable flakes by default, and `nix-darwin` sets them permanently once it has activated.

This step installs Homebrew (via `nix-homebrew`), every formula and cask, and the App Store apps.
It is slow and noisy.
It is also where failures cluster — see [Troubleshooting](#troubleshooting).

Once it completes, open a new shell.
`darwin-rebuild` is now on `PATH` via `/run/current-system/sw/bin`, so later rebuilds are just:

```bash
darwin-rebuild switch --flake ~/dotfiles/config/nix#my-mac
```

## 6. Symlink the configs

```bash
cd ~/dotfiles && ./sync.sh
```

## 7. Manual leftovers

Nix does not cover these:

- SSH and GPG keys.
- `gh auth login`, then switch the remote back to SSH: `git remote set-url origin git@github.com:RichardBray/dotfiles.git`
- Accessibility and Input Monitoring permissions for Karabiner Elements and kanata.
- App logins — Slack, Spotify, Arc, Tailscale, and so on.
- macOS settings beyond the few `system.defaults` lines in the flake.

## Troubleshooting

### `no available formula with the name 'sketchybar'`

`sketchybar` and `aerospace` are not in `homebrew-core` or `homebrew-cask`.
They come from `felixkratz/formulae` and `nikitabobko/tap`.
A bare name only resolves once those taps are active, which is not guaranteed during a first `brew bundle`, so the flake lists them fully qualified as `felixkratz/formulae/sketchybar` and `nikitabobko/tap/aerospace`.

If it still fails, tap manually and re-run:

```bash
brew tap felixkratz/formulae && brew tap nikitabobko/tap
```

### `undefined method 'to_sym' for nil` during `brew bundle`

Version skew.
`nix-homebrew` pins a specific Homebrew build, and an old pin cannot parse the current cask API JSON.
The traceback names the pinned version, for example `/nix/store/...brew-5.1.1-patched/...`.

Update the input and commit the lock:

```bash
cd ~/dotfiles/config/nix
nix flake update nix-homebrew
```

### `darwin-rebuild: command not found`

Activation never completed.
Keep using the `sudo nix run nix-darwin -- switch ...` form from Step 5 until one switch finishes end to end.

### Checking a flake edit before rebuilding

Catches syntax and option errors in seconds, without touching the system:

```bash
cd ~/dotfiles/config/nix
nix eval --raw .#darwinConfigurations.my-mac.system.outPath
```

## Keeping the flake honest

`onActivation.cleanup = "zap"` means Homebrew uninstalls anything not listed in the flake.
Packages installed ad hoc with `brew install` disappear on the next rebuild, and never reach a new machine.

Check for drift periodically and add what matters to `config/nix/flake.nix`:

```bash
brew leaves
brew list --cask
mas list
```
