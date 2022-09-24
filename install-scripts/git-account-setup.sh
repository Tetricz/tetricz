#!/bin/bash
echo "Making sure git is installed"
sudo apt-get update
sudo apt-get install git
echo "Setting global config..."
git config --global user.name "Tetricz"
git config --global user.email "DavidLeeDaniels@protonmail.com"
# print git global config
git config --global --list
echo "Done..."