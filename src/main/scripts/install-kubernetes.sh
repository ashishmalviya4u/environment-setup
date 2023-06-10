#!/bin/bash

# Disable swap
sudo swapoff -a
sudo sed -i '/swap/d' /etc/fstab

# Install Docker
sudo apt update
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker

# Add Kubernetes apt repository key
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# Add Kubernetes apt repository
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update the package index
sudo apt update

# Install Kubernetes components
sudo apt install -y kubelet kubeadm kubectl