#!/usr/bin/env bash
# Deploy dots-hyprland rice config on first login.
# Re-runs automatically if this script is modified (chezmoi run_once_ semantics).
set -euo pipefail

DOTS_REPO="https://github.com/end-4/dots-hyprland"
DOTS_DIR="${HOME}/.cache/dots-hyprland-install"

echo "[rice] Cloning dots-hyprland..."
git clone --depth=1 "$DOTS_REPO" "$DOTS_DIR"

# Deploy config directories (sync)
CONFIG_DIRS=(
    quickshell
    hypr
    kitty
    foot
    fuzzel
    matugen
    Kvantum
    fontconfig
    mpv
    wlogout
    xdg-desktop-portal
    qt5ct
    qt6ct
    kde-material-you-colors
    fish
)

for dir in "${CONFIG_DIRS[@]}"; do
    src="${DOTS_DIR}/dots/.config/${dir}"
    [ -d "$src" ] || continue
    echo "[rice] Deploying ~/.config/${dir}"
    mkdir -p "${HOME}/.config/${dir}"
    rsync -a --delete "${src}/" "${HOME}/.config/${dir}/"
done

# Deploy single-file configs
for f in darklyrc dolphinrc kdeglobals konsolerc starship.toml; do
    src="${DOTS_DIR}/dots/.config/${f}"
    [ -f "$src" ] || continue
    echo "[rice] Deploying ~/.config/${f}"
    cp "$src" "${HOME}/.config/${f}"
done

# Fedora-specific autostart overrides (only written once; user can customize freely)
mkdir -p "${HOME}/.config/hypr/custom"
if [ ! -f "${HOME}/.config/hypr/custom/execs.conf" ]; then
    echo "[rice] Deploying Fedora exec overrides..."
    cp "${DOTS_DIR}/dots-extra/fedora/hypr/hyprland/execs.conf" \
       "${HOME}/.config/hypr/custom/execs.conf"
fi

# Disable AI chat
SETTINGS="${HOME}/.config/quickshell/ii/settings.qml"
if [ -f "$SETTINGS" ]; then
    echo "[rice] Disabling AI chat..."
    sed -i 's/\(policies\.ai:\s*\)[0-9]*/\10/' "$SETTINGS"
fi

# Icons
echo "[rice] Deploying icons..."
mkdir -p "${HOME}/.local/share/icons"
rsync -a "${DOTS_DIR}/dots/.local/share/icons/" "${HOME}/.local/share/icons/"

# Konsole profiles
if [ -d "${DOTS_DIR}/dots/.local/share/konsole" ]; then
    mkdir -p "${HOME}/.local/share/konsole"
    rsync -a "${DOTS_DIR}/dots/.local/share/konsole/" "${HOME}/.local/share/konsole/"
fi

echo "[rice] Cleaning up..."
rm -rf "$DOTS_DIR"

echo "[rice] Done. Log out and select Hyprland at the login screen."
