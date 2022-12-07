#!/bin/bash

helm_version="3.10.2"

curl -LO https://get.helm.sh/helm-v${helm_version}-linux-amd64.tar.gz
curl -LO https://get.helm.sh/helm-v${helm_version}-linux-amd64.tar.gz.sha256sum
sha256sum -c helm-v${helm_version}-linux-amd64.tar.gz.sha256sum

#if checksum is not valid
[ $? -ne 0 ] && {
    echo "Download of helm failed..."
    exit 1
}

tar xvf helm-v${helm_version}-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
rm helm-v${helm_version}-linux-amd64.tar.gz*
