#!/bin/bash
timevar=$(date +%Y-%b-%d)
echo "Time Variable set to ${timevar}"
echo "Downloading repository"
git clone -4 https://github.com/Tetricz/nextcloud-docker.git
echo "Entering repository"
cd nextcloud-docker
echo "Enable multi-architecture support"
docker run --privileged --rm docker/binfmt:a7996909642ee92942dcd6cff44b9b95f08dad64
echo "Starting build process"
docker buildx build --build-arg NC_VERSION=24.0.1 --platform linux/amd64 -f "Dockerfile" -t tetricz/nextcloud:amd64$timevar --no-cache .
echo "Pushing images to DockerHub"
docker push tetricz/nextcloud:amd64$timevar

docker manifest create tetricz/nextcloud:latest tetricz/nextcloud:amd64$timevar --amend
docker manifest create tetricz/nextcloud:24 tetricz/nextcloud:amd64$timevar --amend

docker manifest push --purge tetricz/nextcloud:latest
docker manifest push --purge tetricz/nextcloud:24
echo "Cleaning up files"
docker buildx prune -fa
cd ..
rm -vfr nextcloud-docker