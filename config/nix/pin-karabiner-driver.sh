#!/usr/bin/env bash
#
# Pins Karabiner-DriverKit-VirtualHIDDevice to a known-working version.
#
# Why this exists: v8.0.0 of the driver has a regression on macOS Tahoe
# (26.x) that breaks kanata's connection to the driver. kanata's log shows
# a "connect_failed asio.system:2" loop and the keyboard grab either fails
# outright or leaves the keyboard dead (kanata grabs it exclusively but can't
# re-emit keys through the broken driver connection).
#
# v6.14.0 is confirmed working. This is *not* managed by the karabiner-elements
# Homebrew cask (config/nix/flake.nix) - that only controls the Karabiner-Elements
# app itself. The DriverKit VirtualHIDDevice driver is a separate pqrs-org
# product with its own release cadence, installed via a standalone .pkg, and
# Homebrew casks can't be pinned to a specific version anyway.
#
# Usage: ./pin-karabiner-driver.sh
# Safe to re-run - it's a no-op if the pinned version is already installed.

set -euo pipefail

PINNED_VERSION="6.14.0"
PKG_URL="https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/releases/download/v${PINNED_VERSION}/Karabiner-DriverKit-VirtualHIDDevice-${PINNED_VERSION}.pkg"
DRIVER_DIR="/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice"
DAEMON_INFO_PLIST="$DRIVER_DIR/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/Info.plist"

current_version="none"
if [ -f "$DAEMON_INFO_PLIST" ]; then
    current_version=$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "$DAEMON_INFO_PLIST" 2>/dev/null || echo "unknown")
fi

if [ "$current_version" = "$PINNED_VERSION" ]; then
    echo "Karabiner-DriverKit-VirtualHIDDevice already pinned at $PINNED_VERSION - nothing to do."
    exit 0
fi

echo "Current driver version: $current_version"
echo "Pinning to: $PINNED_VERSION"
echo

if [ -d "$DRIVER_DIR" ]; then
    echo "==> Uninstalling existing driver ($current_version)..."
    bash "$DRIVER_DIR/scripts/uninstall/deactivate_driver.sh" || true
    sudo bash "$DRIVER_DIR/scripts/uninstall/remove_files.sh" || true
    sudo killall Karabiner-VirtualHIDDevice-Daemon 2>/dev/null || true
fi

echo "==> Downloading v${PINNED_VERSION}..."
TMP_PKG=$(mktemp -t karabiner-driver).pkg
curl -fsSL -o "$TMP_PKG" "$PKG_URL"

echo "==> Installing v${PINNED_VERSION} (requires admin password)..."
sudo installer -pkg "$TMP_PKG" -target /
rm -f "$TMP_PKG"

echo "==> Activating driver..."
sudo "/Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager" activate

echo
echo "Done. If macOS shows a 'system extension blocked' prompt, approve it in:"
echo "  System Settings > General > Login Items & Extensions > Driver Extensions"
echo "Then reboot for the driver swap to take full effect."
