#!/bin/bash
set -e

# Enable snapper setup for /home (Experimental)
ENABLE_HOME_SNAPSHOT=false

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

if sudo btrfs subvolume show /.snapshots &>/dev/null; then
    SNAPSHOTS_EXISTS="yes"
else
    SNAPSHOTS_EXISTS="no"
fi

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
    # .snapshots doesn't exist as a subvolume, ensure it's a proper btrfs subvolume
    if sudo btrfs subvolume show /.snapshots &>/dev/null; then
        : # Already a subvolume
    elif [[ -d /.snapshots ]]; then
        # If backup already exists, append a timestamp
        if [[ -e /.snapshots.old ]]; then
            timestamp=$(date +%s)
            sudo mv /.snapshots "/.snapshots.old.$timestamp"
        else
            sudo mv /.snapshots /.snapshots.old
        fi
        sudo btrfs subvolume create /.snapshots
    else
        sudo btrfs subvolume create /.snapshots
    fi
    
    # Add .snapshots to fstab
    if ! grep -q "/.snapshots" /etc/fstab; then
        echo "UUID=$BTRFS_UUID /.snapshots btrfs subvol=@/.snapshots,defaults 0 0" | sudo tee -a /etc/fstab
    fi
    
    # Reload systemd and mount .snapshots
    sudo systemctl daemon-reload
    sudo mount /.snapshots 2>/dev/null || true
    
    # Manually create snapper config
    sudo mkdir -p /etc/snapper/configs
    sudo cp /usr/share/snapper/config-templates/default /etc/snapper/configs/root
    sudo sed -i 's/SNAPPER_CONFIGS=""/SNAPPER_CONFIGS="root"/' /etc/sysconfig/snapper
    sudo systemctl restart snapperd
fi

# Set access controls
sudo snapper -c root set-config ALLOW_USERS=$USER SYNC_ACL=yes

# Copy config files
sudo cp btrfs/etc/snapper/configs/root /etc/snapper/configs/

sudo cp btrfs/etc/dnf/plugins/snapper.conf /etc/dnf/plugins/

sudo mkdir -p /etc/dnf/libdnf5-plugins/actions.d/
sudo cp btrfs/etc/dnf/libdnf5-plugins/actions.d/snapper.actions /etc/dnf/libdnf5-plugins/actions.d/

# Restart snapper daemon
sudo systemctl restart snapperd

# Enable timeline and cleanup timers
sudo systemctl enable --now snapper-timeline.timer
sudo systemctl enable --now snapper-cleanup.timer

# Copy btrfs-assistant desktop entry
sudo cp btrfs/usr/share/applications/btrfs-assistant.desktop /usr/share/applications

# Create post install snapshot
sudo snapper -c root create --description "Post install Mirai Linux snapshot"

# Snapper for /home
if [ "$ENABLE_HOME_SNAPSHOT" = "true" ]; then
    # ensure /home/.snapshots is a btrfs subvolume
    if sudo btrfs subvolume show /home/.snapshots &>/dev/null; then
        :
    elif [[ -d /home/.snapshots ]]; then
        if [[ -e /home/.snapshots.old ]]; then
            timestamp=$(date +%s)
            sudo mv /home/.snapshots "/home/.snapshots.old.$timestamp"
        else
            sudo mv /home/.snapshots /home/.snapshots.old
        fi
        sudo btrfs subvolume create /home/.snapshots
    else
        sudo btrfs subvolume create /home/.snapshots
    fi

    # Manually create snapper config for home
    sudo mkdir -p /etc/snapper/configs
    sudo cp /usr/share/snapper/config-templates/default /etc/snapper/configs/home

    # Copy config files
    sudo cp btrfs/etc/snapper/configs/home /etc/snapper/configs/home

    # Update sysconfig to include home config
    sudo sed -i 's/SNAPPER_CONFIGS="\(.*\)"/SNAPPER_CONFIGS="\1 home"/' /etc/sysconfig/snapper

    # Restart snapperd and take initial home snapshot
    sudo systemctl restart snapperd
    sudo snapper -c home create --description "Post install Mirai Linux home snapshot"
fi

sh ./btrfs/grub-btrfs.sh

echo -e "\e[1;32m[btrfs] Setup complete.\e[0m"
echo -e "\e[1;31mA system reboot is required to complete the btrfs setup.\e[0m"
