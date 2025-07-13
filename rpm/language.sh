#!/bin/bash
set -e

source "$(dirname "$0")/../common.sh"

sudo dnf remove -y fcitx fcitx-configtool || true
sudo dnf install -y \
    fcitx5 fcitx5-mozc fcitx5-gtk fcitx5-qt fcitx5-configtool fcitx5-autostart fcitx5-anthy

for file in "$HOME/.profile" "$HOME/.xprofile"; do
  add_if_missing 'export GTK_IM_MODULE=fcitx' "$file"
  add_if_missing 'export QT_IM_MODULE=fcitx' "$file"
  add_if_missing 'export XMODIFIERS=@im=fcitx' "$file"
done

mkdir -p "$HOME/.config/environment.d"
cat > "$HOME/.config/environment.d/30-fcitx5.conf" <<EOF
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
EOF

sudo mkdir -p /etc/X11/xinit
echo "run_im fcitx5" | sudo tee /etc/X11/xinit/xinputrc > /dev/null

FCITX5_CONF_DIR="$HOME/.config/fcitx5"
mkdir -p "$FCITX5_CONF_DIR"
cat > "$FCITX5_CONF_DIR/profile" <<EOF
[Groups/0]
Name=Default
Default Layout=us
DefaultIM=mozc

[GroupOrder]
0=Default

[Groups/0/Items/0]
Name=keyboard-us
EOF

kwriteconfig5 --file kcmvirtualkeyboardrc \
  --group VirtualKeyboard --key Backend Fcitx5

source "$HOME/.profile"
fcitx5-remote -r || true

echo -e "\e[1;32m[RPM] Language setup complete.\e[0m"
echo -e "\e[1;31mA system reboot is required to complete the language setup.\e[0m"