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

# Initialize Kubernetes cluster (run this command only on the master node)
sudo kubeadm init

# Set up the kubeconfig for the current user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Deploy a network plugin (e.g., Calico)
kubectl apply -f https://docs.projectcalico.org/v3.18/manifests/calico.yaml

# Optional: Enable scheduling pods on the master node (not recommended for production)
kubectl taint nodes --all node-role.kubernetes.io/master-

# Print cluster join command (save it for later use when joining worker nodes)
kubeadm token create --print-join-command