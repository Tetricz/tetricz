#!/bin/bash
echo "Checking for updates"
sudo apt-get update
echo "Applying updates....."
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
