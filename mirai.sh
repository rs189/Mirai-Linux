#!/bin/bash

ENABLE_NVIDIA=false

for arg in "$@"; do
    case "$arg" in
        --nvidia)
            ENABLE_NVIDIA=true
            ;;
        *)
            echo -e "\e[1;33mWarning: Unknown argument: $arg\e[0m"
            ;;
    esac
done

sh ./dnf/dnf.sh
sh ./flatpak/flatpak.sh

sh ./runtimes/wine/wine.sh
sh ./runtimes/proton/proton.sh
sh ./runtimes/java/java.sh
sh ./runtimes/dotnet/dotnet.sh

sh ./security/firewalld/firewalld.sh
sh ./security/selinux/selinux.sh

sh ./kde/x11/x11.sh || true

sh ./systemd/systemd.sh

sh ./btrfs/btrfs.sh
sh ./swap/swap.sh

if [ "$ENABLE_NVIDIA" = true ]; then
    sh ./drivers/nvidia/nvidia.sh
fi

echo -e "\e[1;32mMirai Linux setup complete.\e[0m"
echo -e "\e[1;31mA system reboot is required to complete the setup.\e[0m"