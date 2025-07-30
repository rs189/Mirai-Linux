#!/bin/bash
set -e

sh ./proton/proton-ge.sh
sh ./proton/proton-ge-rtsp.sh

echo -e "\e[1;32m[Proton] setup complete.\e[0m"