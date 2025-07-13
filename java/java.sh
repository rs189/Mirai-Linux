#!/bin/bash
set -e

curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"

sdk install java 8.0.302-tem # Java 8
sdk install java 11.0.20-tem # Java 11
sdk install java 17.0.8-tem # Java 17
sdk install java 20.0.2-tem # Java 20 
sdk install java 23.0.2-tem # Java 23

sdk default java 23.0.2-tem

echo -e "\e[1;32m[Java] setup complete.\e[0m"