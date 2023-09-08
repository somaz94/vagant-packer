#!/bin/bash
set -e # Exit script immediately on first error

# Update and upgrade the system packages
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo apt-get upgrade -y

# Install necessary utilities
sudo apt-get install -y curl apt-transport-https ca-certificates software-properties-common nfs-common

# Set up kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Cleanup to reduce image size
sudo apt-get clean
