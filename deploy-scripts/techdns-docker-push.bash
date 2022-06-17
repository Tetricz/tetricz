#!/bin/bash
timevar=$(date +%Y-%b-%d)
echo "Time Variable set to ${timevar}"
echo "Downloading repository"
git clone -4 https://github.com/Tetricz/docker-techdns.git
echo "Entering repository"
cd docker-techdns
echo "Enable multi-architecture support"
docker run --privileged --rm docker/binfmt:a7996909642ee92942dcd6cff44b9b95f08dad64
echo "Starting build process"
docker buildx build --build-arg SDK_VERSION=6.0-alpine --build-arg RUNTIME_VERSION=6.0-alpine --platform linux/amd64 -f "Dockerfile" -t tetricz/techdns:amd64$timevar --no-cache .
docker buildx build --build-arg SDK_VERSION=6.0 --build-arg RUNTIME_VERSION=6.0 --platform linux/arm64 -f "Dockerfile" -t tetricz/techdns:arm64$timevar --no-cache .
#docker buildx build --build-arg SDK_VERSION=6.0 --build-arg RUNTIME_VERSION=6.0 --platform linux/arm/v7 -f "Dockerfile" -t tetricz/techdns:arm32$timevar --no-cache .
echo "Pushing images to DockerHub"
docker push tetricz/techdns:amd64$timevar
docker push tetricz/techdns:arm64$timevar
#docker push tetricz/techdns:arm32$timevar
#docker push tetricz/techdns:armv7$timevar tetricz/techdns:armv7$timevar
docker manifest create tetricz/techdns:latest tetricz/techdns:arm64$timevar tetricz/techdns:amd64$timevar --amend
docker manifest create tetricz/techdns:8.13 tetricz/techdns:arm64$timevar tetricz/techdns:amd64$timevar --amend
docker manifest push --purge tetricz/techdns:latest
docker manifest push --purge tetricz/techdns:8.13
echo "Cleaning up files"
docker buildx prune -fa
cd ..
rm -vfr docker-techdns