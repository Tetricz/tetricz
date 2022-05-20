#!/bin/bash
timevar=$(date +%Y-%b-%d)
echo "Time Variable set to ${timevar}"
echo "Downloading repository"
git clone -4 https://github.com/Tetricz/docker-mumble.git
echo "Entering repository"
cd docker-mumble
echo "Enable multi-architecture support"
docker run --privileged --rm docker/binfmt:a7996909642ee92942dcd6cff44b9b95f08dad64
echo "Starting build process"
docker buildx build --platform linux/amd64 -f "Dockerfile" -t tetricz/mumble:$timevar --no-cache .
echo "Pushing images to DockerHub"
docker push tetricz/mumble:$timevar
docker manifest create tetricz/mumble:latest tetricz/mumble:$timevar --amend
docker manifest push --purge tetricz/mumble:latest
echo "Cleaning up files"
docker buildx prune -fa
cd ..
rm -vfr docker-mumble