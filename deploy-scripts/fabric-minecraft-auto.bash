#!/bin/bash
timevar=$(date +%Y-%b-%d)
echo "Time Variable set to ${timevar}"
echo "Downloading repository"
git clone -4 https://github.com/Tetricz/docker-minecraft.git
echo "Entering repository"
cd docker-minecraft
git checkout fabric-1.19-auto
echo "Enable multi-architecture support"
docker run --privileged --rm docker/binfmt:a7996909642ee92942dcd6cff44b9b95f08dad64
echo "Starting build process"
docker buildx build --platform linux/amd64 -f "Dockerfile" -t tetricz/minecraft:amd64$timevar --no-cache .
echo "Pushing images to DockerHub"
docker push tetricz/minecraft:amd64$timevar
docker manifest create tetricz/minecraft:fabric-auto tetricz/minecraft:amd64$timevar --amend
docker manifest create tetricz/minecraft:fabric-auto-1.19 tetricz/minecraft:amd64$timevar --amend
docker manifest push --purge tetricz/minecraft:fabric-auto
docker manifest push --purge tetricz/minecraft:fabric-auto-1.19
echo "Cleaning up files"
docker buildx prune -fa
cd ..
rm -vfr docker-minecraft