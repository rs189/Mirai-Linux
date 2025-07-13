#!/bin/bash
set -e

# Remove old btrfs maintenance and install required packages
sudo dnf remove -y btrfsmaintenance || true
sudo dnf install -y btrfs-assistant dnf-plugin-snapper || true
sudo dnf install -y libdnf5-plugin-actions || true

# Clean up any existing snapper configuration completely
sudo systemctl stop snapperd || true
sudo rm -rf /etc/snapper/configs/*
sudo sed -i 's/SNAPPER_CONFIGS=".*"/SNAPPER_CONFIGS=""/' /etc/sysconfig/snapper

# Get the btrfs filesystem UUID
BTRFS_UUID=$(sudo blkid -s UUID -o value /dev/$(findmnt -n -o SOURCE / | cut -d'[' -f1 | sed 's|/dev/||'))

SNAPSHOTS_EXISTS=$(sudo btrfs subvolume list / | grep -q '.snapshots' && echo "yes" || echo "no")

if [ "$SNAPSHOTS_EXISTS" = "yes" ]; then
    if ! grep -q "/.snapshots" /etc/fstab; then
        echo "UUID=$BTRFS_UUID /.snapshots btrfs subvol=@/.snapshots,defaults 0 0" | sudo tee -a /etc/fstab
    fi

    # Reload systemd and mount .snapshots
    sudo systemctl daemon-reload
    sudo mount /.snapshots 2>/dev/null || true
    
    # Manually create snapper config
    sudo mkdir -p /etc/snapper/configs
    sudo cp /usr/share/snapper/config-templates/default /etc/snapper/configs/root
    
    # Update sysconfig to include root config
    sudo sed -i 's/SNAPPER_CONFIGS=""/SNAPPER_CONFIGS="root"/' /etc/sysconfig/snapper
    
    # Restart snapperd to pick up the new config
    sudo systemctl restart snapperd
    
else
    # .snapshots doesn't exist, let snapper create it
    sudo btrfs subvolume create /.snapshots
    
    # Add .snapshots to fstab
    if ! grep -q "/.snapshots" /etc/fstab; then
        echo "UUID=$BTRFS_UUID /.snapshots btrfs subvol=@/.snapshots,defaults 0 0" | sudo tee -a /etc/fstab
    fi
    
    # Reload systemd and mount .snapshots
    sudo systemctl daemon-reload
    sudo mount /.snapshots 2>/dev/null || true
    
    # Create snapper config
    sudo snapper create-config /
    sudo cp /usr/share/snapper/config-templates/default /etc/snapper/configs/root
fi

# Set access controls
sudo snapper -c root set-config ALLOW_USERS=$USER SYNC_ACL=yes

# Copy config files
sudo cp etc/snapper/configs/root /etc/snapper/configs/
sudo cp etc/dnf/plugins/snapper.conf /etc/dnf/plugins/

sudo mkdir -p /etc/dnf/libdnf5-plugins/actions.d/
sudo cp etc/dnf/libdnf5-plugins/actions.d/snapper.actions /etc/dnf/libdnf5-plugins/actions.d/

# Restart snapper daemon
sudo systemctl restart snapperd

# Enable timeline and cleanup timers
sudo systemctl enable --now snapper-timeline.timer
sudo systemctl enable --now snapper-cleanup.timer

# Copy btrfs-assistant desktop entry
sudo cp usr/share/applications/btrfs-assistant.desktop /usr/share/applications

# Create post install snapshot
sudo snapper -c root create --description "Post install mirai linux snapshot"


echo -e "\e[1;31mA system reboot is required to complete the btrfs setup.\e[0m"