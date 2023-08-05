#!/bin/bash
echo "Resetting for git pull"
git reset --hard
git pull
echo "Making all scripts execuatable"
chmod -R +x ./*