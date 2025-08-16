#!/bin/bash
set -e

SWAPFILE=/swapfile
SIZE_GB=16

current_swap=$(swapon --show=NAME --noheadings || true)

if echo "$current_swap" | grep -qv "^$SWAPFILE$" && [ -n "$current_swap" ]; then
  echo "Other swap devices present:"
  echo "$current_swap"
fi

desired_bytes=$((SIZE_GB * 1024 * 1024 * 1024))

if [ -f "$SWAPFILE" ]; then
  actual_bytes=$(stat -c%s "$SWAPFILE")
  if [ "$actual_bytes" -ne "$desired_bytes" ]; then
    echo "Existing $SWAPFILE has size $actual_bytes bytes; resizing to $desired_bytes"
    sudo swapoff "$SWAPFILE" 2>/dev/null || true
    sudo rm -f "$SWAPFILE"
    echo "Creating $SIZE_GB GiB swapfile at $SWAPFILE"
    sudo fallocate -l ${SIZE_GB}G "$SWAPFILE" || sudo dd if=/dev/zero of="$SWAPFILE" bs=1M count=$((SIZE_GB*1024)) status=progress
    sudo chmod 600 "$SWAPFILE"
    sudo mkswap "$SWAPFILE"
    sudo swapon -p 10 "$SWAPFILE"
    if ! grep -qs "^$SWAPFILE" /etc/fstab; then
      echo "$SWAPFILE none swap sw,defaults 0 0" | sudo tee -a /etc/fstab
    fi
  else
    echo "$SWAPFILE already exists with correct size"
    if ! swapon --show=NAME | grep -q "^$SWAPFILE$"; then
      sudo mkswap "$SWAPFILE"
      sudo swapon -p 10 "$SWAPFILE"
    fi
  fi
else
  echo "Creating $SIZE_GB GiB swapfile at $SWAPFILE"
  sudo fallocate -l ${SIZE_GB}G "$SWAPFILE" || sudo dd if=/dev/zero of="$SWAPFILE" bs=1M count=$((SIZE_GB*1024)) status=progress
  sudo chmod 600 "$SWAPFILE"
  sudo mkswap "$SWAPFILE"
  sudo swapon -p 10 "$SWAPFILE"
  if ! grep -qs "^$SWAPFILE" /etc/fstab; then
    echo "$SWAPFILE none swap sw,defaults 0 0" | sudo tee -a /etc/fstab
  fi
fi

echo -e "\e[1;32m[swap] swapfile setup complete.\e[0m"