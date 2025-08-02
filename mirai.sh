#!/bin/bash

ENABLE_BTRFS=false
ENABLE_SWAP=false
ENABLE_NVIDIA=false
ENABLE_KDE=true

for arg in "$@"; do
    case "$arg" in
        --btrfs)
            ENABLE_BTRFS=true
            ;;
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

sh ./kde/x11.sh || true

sh ./systemd/systemd.sh

if [ "$ENABLE_BTRFS" = true ]; then
    sh ./btrfs/btrfs.sh
fi

if [ "$ENABLE_SWAP" = true ]; then
    sh ./swap/swap.sh
else
    sh ./swap/earlyoom.sh
fi

if [ "$ENABLE_NVIDIA" = true ]; then
    sh ./drivers/nvidia/nvidia.sh
fi

if [ "$ENABLE_KDE" = true ]; then
    sh ./kde/kde.sh
fi

sh ./fixes/steamvr.sh

echo -e "\e[1;32mMirai Linux setup complete.\e[0m"
echo -e "\e[1;31mA system reboot is required to complete the setup.\e[0m"