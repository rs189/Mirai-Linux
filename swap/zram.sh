#!/bin/bash
set -e

sudo mkdir -p /etc/systemd/zram-generator.conf.d
sudo cp ./swap/etc/systemd/zram-generator.conf /etc/systemd/zram-generator.conf 2>/dev/null || true

# Prevent systemd generator from racing
sudo systemctl daemon-reload 2>/dev/null || true
sudo systemctl unmask systemd-zram-setup@zram0.service 2>/dev/null || true
sudo systemctl enable --now systemd-zram-setup@zram0.service 2>/dev/null || true

# Compute desired zram size: min(ram/2, 8GiB)
MEM_KB=$(awk '/MemTotal/ {print $2}' /proc/meminfo 2>/dev/null || echo 0)
if [ -z "$MEM_KB" ] || [ "$MEM_KB" -le 0 ]; then
	MEM_KB=0
fi
HALF_BYTES=$((MEM_KB * 1024 / 2))
MAX_BYTES=$((8 * 1024 * 1024 * 1024))
if [ "$HALF_BYTES" -gt "$MAX_BYTES" ]; then
	SIZE_BYTES=$MAX_BYTES
else
	SIZE_BYTES=$HALF_BYTES
fi
echo "Desired zram size bytes: $SIZE_BYTES"

# Load zram module with one device
echo "Loading zram kernel module"
sudo modprobe -r zram 2>/dev/null || true
sudo modprobe zram num_devices=1 2>/dev/null || sudo modprobe zram 2>/dev/null || true

# Try to set disksize
if [ -e /sys/block/zram0 ]; then
	sleep 0.1
	if echo "$SIZE_BYTES" | sudo tee /sys/block/zram0/disksize >/dev/null 2>/dev/null; then
		:
	else
		echo "Writing disksize failed; continuing without resizing zram."
	fi
else
	echo "Skipping zram disksize step because /sys/block/zram0 is missing."
fi

# Create swap and enable it
if [ -e /sys/block/zram0 ]; then
	echo "Creating and enabling swap on /dev/zram0"
	sudo mkswap -f /dev/zram0 2>/dev/null || true
	sleep 0.1
	if sudo swapon -p 100 /dev/zram0 2>/dev/null; then
		echo "/dev/zram0 enabled"
	else
		echo "swapon failed; continuing without zram swap enabled."
	fi
else
	echo "Skipping zram swapon step because /sys/block/zram0 is missing."
fi

echo -e "\e[1;32m[swap] zram setup complete.\e[0m"