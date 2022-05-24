#!/bin/bash
echo "Resetting for git pull"
git reset --hard
git pull
chmod +x ./exec.sh
./exec.sh