#!/bin/bash

python -m pip install konsave || true

sudo cp -r ./kde/usr/share/wallpapers/* /usr/share/wallpapers/

# Autologin
SDDM_CONF="/etc/sddm.conf.d/kde_settings.conf"
SOURCE_CONF="$(dirname "$0")/etc/sddm.conf.d/kde_settings.conf"
AUTLOGIN_SECTION="[Autologin]\nRelogin=false\nSession=\nUser="

if [ ! -f "$SDDM_CONF" ]; then
    sudo cp "$SOURCE_CONF" "$SDDM_CONF"
else
    # Remove commented [Autologin] section and ensure correct section is present
    if ! grep -q '^\[Autologin\]' "$SDDM_CONF"; then
        # No [Autologin] section, so add it at the top
        sudo sed -i "1i$AUTLOGIN_SECTION\n" "$SDDM_CONF"
    else
        # [Autologin] section exists, replace it and its contents
        sudo awk -v repl="$AUTLOGIN_SECTION" '
            BEGIN{printed=0}
            /^\[Autologin\]/{print repl; printed=1; flag=1; next}
            /^\[/{flag=0}
            flag && !/^\[Autologin\]/{next}
            {if(!flag || printed) print $0}
        ' "$SDDM_CONF" > /tmp/kde_settings.conf && sudo mv /tmp/kde_settings.conf "$SDDM_CONF"
    fi
fi

echo -e "\e[1;32m[KDE] Setup complete.\e[0m"