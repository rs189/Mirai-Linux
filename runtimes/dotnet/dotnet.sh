#!/bin/bash
set -e

sudo dnf install -y dotnet-runtime-9.0 aspnetcore-runtime-9.0 || true

echo -e "\e[1;32m[.NET] setup complete.\e[0m"