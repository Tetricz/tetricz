#!/bin/bash

mkdir -p /tmp/nvidia
echo "* Cloning nvidia-patch to /tmp"
wget https://raw.githubusercontent.com/keylase/nvidia-patch/master/patch.sh -O /tmp/nvidia/patch.sh
chmod +x /tmp/nvidia/patch.sh
echo "* Running patch..."
/tmp/nvidia/patch.sh

echo "* Done. Cleaning up..."
rm -rf /tmp/nvidia/patch.sh

echo "* Everything done. Enjoy your day :)"