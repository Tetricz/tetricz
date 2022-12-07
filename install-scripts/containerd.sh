#!/bin/bash

containerd_version="1.6.11"
runc_version="1.1.4"
cni_version="1.1.1"

echo "Installing dependencies..."
sudo apt-get update
sudo apt-get install curl -y

echo "Downloading and installing CRI, containerd..."
# Download and install CRI, containerd
curl -LO "https://github.com/containerd/containerd/releases/download/v${containerd_version}/containerd-${containerd_version}-linux-amd64.tar.gz"
curl -LO https://github.com/containerd/containerd/releases/download/v${containerd_version}/containerd-${containerd_version}-linux-amd64.tar.gz.sha256sum
sha256sum -c containerd-${containerd_version}-linux-amd64.tar.gz.sha256sum

#if checksum is not valid
[ $? -ne 0 ] && {
    echo "Download of containerd failed..."
    exit 1
}

sudo tar -xvf containerd-${containerd_version}-linux-amd64.tar.gz -C /usr/local
rm containerd-${containerd_version}-linux-amd64.tar.gz*
curl -LO https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
sudo mv -v containerd.service /etc/systemd/system/containerd.service
sudo systemctl daemon-reload
sudo systemctl restart containerd

curl -LO https://github.com/opencontainers/runc/releases/download/v${runc_version}/runc.amd64
#if checksum is not valid
[ $? -ne 0 ] && {
    echo "Download of runc failed..."
    exit 1
}
sudo install -m 755 runc.amd64 /usr/local/sbin/runc
rm runc.amd64

curl -LO https://github.com/containernetworking/plugins/releases/download/v${cni_version}/cni-plugins-linux-amd64-v${cni_version}.tgz
curl -LO https://github.com/containernetworking/plugins/releases/download/v${cni_version}/cni-plugins-linux-amd64-v${cni_version}.tgz.sha256
sha256sum -c cni-plugins-linux-amd64-v${cni_version}.tgz.sha256

#if checksum is not valid
[ $? -ne 0 ] && {
    echo "Download of cni-plugins-linux failed..."
    exit 1
}

sudo mkdir -p /opt/cni/bin
sudo tar xvf cni-plugins-linux-amd64-v${cni_version}.tgz -C /opt/cni/bin
rm cni-plugins-linux-amd64-v${cni_version}.tgz*

# Setting up config.toml with default settings
containerd config default | containerd config default | sed 's/SystemdCgroup = .*/SystemdCgroup = true/g' > config.toml
sudo mkdir -p /etc/containerd
sudo mv config.toml /etc/containerd/config.toml

echo "containerd installed successfully..."
