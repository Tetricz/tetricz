#!/bin/bash
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install docker.io
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
echo "Testing docker with hello-world"
docker run hello-world