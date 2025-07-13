#!/bin/bash
set -e

SDKMAN_DIR="$HOME/.sdkman"
TMP_INSTALL_SCRIPT="$(mktemp)"

curl -s "https://get.sdkman.io" -o "$TMP_INSTALL_SCRIPT"

bash -c "
  bash $TMP_INSTALL_SCRIPT
  source \"$SDKMAN_DIR/bin/sdkman-init.sh\"
  export SDKMAN_AUTO_ANSWER=true

  yes | sdk install java 8.0.302-tem --yes
  yes | sdk install java 11.0.20-tem --yes
  yes | sdk install java 17.0.8-tem --yes
  yes | sdk install java 20.0.2-tem --yes
  yes | sdk install java 23.0.2-tem --yes

  sdk default java 23.0.2-tem
"

rm -f "$TMP_INSTALL_SCRIPT"

if ! grep -Fxq "source \"$SDKMAN_DIR/bin/sdkman-init.sh\"" "$HOME/.bashrc"; then
  echo "source \"$SDKMAN_DIR/bin/sdkman-init.sh\"" >> "$HOME/.bashrc"
fi

echo -e "\e[1;32m[Java] setup complete.\e[0m"