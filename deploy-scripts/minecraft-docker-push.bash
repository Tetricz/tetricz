#!/bin/bash
timevar=$(date +%Y-%b-%d)
echo "Time Variable set to ${timevar}"
echo "Downloading repository"
git clone -4 https://github.com/Tetricz/docker-minecraft.git
echo "Entering repository"
cd docker-minecraft
echo "Enable multi-architecture support"
docker run --privileged --rm docker/binfmt:a7996909642ee92942dcd6cff44b9b95f08dad64
echo "Starting build process"
docker buildx build --platform linux/amd64 -f "Dockerfile" -t tetricz/minecraft:amd64$timevar --no-cache .
docker buildx build --build-arg OPENJDK_VERSION=16-slim --platform linux/arm64 -f "Dockerfile" -t tetricz/minecraft:arm64$timevar --no-cache .
docker buildx build --build-arg OPENJDK_VERSION=8-slim --platform linux/amd64 -f "Dockerfile" -t tetricz/minecraft:openjdk-8amd64$timevar --no-cache .
docker buildx build --build-arg OPENJDK_VERSION=8-slim --platform linux/arm64 -f "Dockerfile" -t tetricz/minecraft:openjdk-8arm64$timevar --no-cache .
echo "Pushing images to DockerHub"
docker push tetricz/minecraft:amd64$timevar
docker push tetricz/minecraft:arm64$timevar
docker push tetricz/minecraft:openjdk-8amd64$timevar
docker push tetricz/minecraft:openjdk-8arm64$timevar
docker manifest create tetricz/minecraft:latest tetricz/minecraft:amd64$timevar tetricz/minecraft:arm64$timevar --amend
docker manifest create tetricz/minecraft:openjdk-8 tetricz/minecraft:openjdk-8amd64$timevar tetricz/minecraft:openjdk-8arm64$timevar
docker manifest push --purge tetricz/minecraft:openjdk-8
docker manifest push --purge tetricz/minecraft:latest
echo "Cleaning up files"
docker buildx prune -fa
cd ..
rm -vfr docker-minecraft