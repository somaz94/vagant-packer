#!/bin/bash

# Update the system
sudo yum update -y

# Install basic utilities
sudo yum install -y git vim wget curl

# Install EFS utilities
sudo yum install -y amazon-efs-utils

# Install kubectl
## Download kubectl binary
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.27.4/2023-08-16/bin/linux/amd64/kubectl

## Apply execute permissions and move it to /usr/local/bin
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

## Verify installation
kubectl version --client

echo "All packages installed successfully!"

