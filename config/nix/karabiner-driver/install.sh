#!/usr/bin/env bash
# Install the Karabiner VirtualHIDDevice driver that kanata talks to, pinned to a
# version that matches the kanata in flake.lock.
#
# WHY THIS IS NOT A HOMEBREW CASK:
#   The karabiner-elements cask bundles this driver, but its uninstall stanza runs
#   `delete: /Library/Application Support/org.pqrs` and forgets the DriverKit pkg
#   receipt. With `onActivation.cleanup` set to uninstall/zap, dropping the cask
#   from flake.nix would delete the driver out from under kanata. The cask is also
#   unversioned, so `upgrade = true` could bump the driver past what kanata speaks.
#
# VERSION PAIRING (from kanata docs/setup-macos.md):
#   kanata >= v1.13.0  ->  driver v8.0.0   (client protocol 7)
#   kanata <  v1.13.0  ->  driver v6.x     (client protocol 5)
#   Mismatched halves fail with "connect_failed asio.system:61" (ECONNREFUSED)
#   while kanata otherwise looks healthy. Upgrade both together or neither.
#
# flake.lock currently pins kanata 1.11.0, hence the v6 line below.

set -euo pipefail

DRIVER_VERSION="6.14.0"
KANATA_MAX_VERSION="1.13.0" # driver must move to v8.x at or past this kanata version

PKG_URL="https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/releases/download/v${DRIVER_VERSION}/Karabiner-DriverKit-VirtualHIDDevice-${DRIVER_VERSION}.pkg"
DRIVER_ROOT="/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice"
MANAGER="/Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager"
PLIST_LABEL="org.pqrs.Karabiner-VirtualHIDDevice-Daemon"
PLIST_SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/${PLIST_LABEL}.plist"

echo "==> Checking kanata version pairing"
if command -v kanata >/dev/null 2>&1; then
    kanata_version="$(kanata --version | awk '{print $2}')"
    lowest="$(printf '%s\n%s\n' "$kanata_version" "$KANATA_MAX_VERSION" | sort -V | head -1)"
    if [ "$kanata_version" != "$lowest" ] || [ "$kanata_version" = "$KANATA_MAX_VERSION" ]; then
        echo "!!  kanata ${kanata_version} is >= ${KANATA_MAX_VERSION}, which needs driver v8.x," >&2
        echo "!!  but this script is pinned to ${DRIVER_VERSION}. Bump DRIVER_VERSION first." >&2
        exit 1
    fi
    echo "    kanata ${kanata_version} pairs with driver ${DRIVER_VERSION}"
else
    echo "    kanata not on PATH yet, continuing"
fi

echo "==> Downloading driver ${DRIVER_VERSION}"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
curl -fsSL -o "$tmp/driver.pkg" "$PKG_URL"

echo "==> Installing pkg (needs sudo)"
sudo installer -pkg "$tmp/driver.pkg" -target /

echo "==> Activating the system extension"
# Prompts for approval under System Settings > General > Login Items & Extensions
# > Driver Extensions on first install.
sudo "$MANAGER" forceActivate

echo "==> Installing the LaunchDaemon"
# Karabiner-Elements' core service normally keeps this daemon alive. Without
# Karabiner-Elements installed, nothing does, and kanata has no virtual keyboard
# to write to. RunAtLoad + KeepAlive covers boot and crashes.
sudo cp "$PLIST_SRC" "/Library/LaunchDaemons/${PLIST_LABEL}.plist"
sudo chown root:wheel "/Library/LaunchDaemons/${PLIST_LABEL}.plist"
sudo chmod 644 "/Library/LaunchDaemons/${PLIST_LABEL}.plist"
sudo launchctl bootout "system/${PLIST_LABEL}" 2>/dev/null || true
sudo launchctl bootstrap system "/Library/LaunchDaemons/${PLIST_LABEL}.plist"

echo "==> Verifying"
sleep 2
systemextensionsctl list | grep -i pqrs || {
    echo "!!  DriverKit extension not listed; approve it in System Settings and re-run." >&2
    exit 1
}
pgrep -lf Karabiner-VirtualHIDDevice-Daemon || {
    echo "!!  Daemon is not running." >&2
    exit 1
}

echo
echo "Done. Run 'keys' and look for 'driver connected: true'."
