#!/bin/bash

# Update package manager and upgrade installed packages
sudo apt-get update
sudo apt-get upgrade -y

# Install packages needed for Kubernetes apt repository
sudo apt-get install -y apt-transport-https ca-certificates curl

# Download GoogleCloud public signing key
sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

# Add Kubernetes apt repository
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update package manager and install Kubernetes
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# Enable and start Docker service
#systemctl enable docker
#systemctl start docker

# Initialize Kubernetes cluster
#kubeadm init

# Set up kubeconfig
#mkdir -p $HOME/.kube
#cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
#chown $(id -u):$(id -g) $HOME/.kube/config
#
## Install Traefik
#kubectl apply -f https://raw.githubusercontent.com/containous/traefik/v1.7/examples/k8s/traefik-deployment.yaml
#
## Create Traefik service
#kubectl apply -f https://raw.githubusercontent.com/containous/traefik/v1.7/examples/k8s/ui.yaml
