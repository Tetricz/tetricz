#!/bin/bash
timevar=$(date +%Y-%b-%d)
echo "Time Variable set to ${timevar}"
echo "Downloading repository"
git clone -4 https://github.com/Tetricz/docker-xbs-api.git
echo "Entering repository"
cd docker-xbs-api
echo "Enable multi-architecture support"
docker run --privileged --rm docker/binfmt:a7996909642ee92942dcd6cff44b9b95f08dad64
echo "Starting build process"
docker buildx build --platform linux/amd64 -f "Dockerfile" -t tetricz/xbs-api:amd64$timevar --no-cache .
docker buildx build --platform linux/arm64 -f "Dockerfile" -t tetricz/xbs-api:arm64$timevar --no-cache .
echo "Pushing images to DockerHub"
docker push tetricz/xbs-api:amd64$timevar
docker push tetricz/xbs-api:arm64$timevar
docker manifest create tetricz/xbs-api:latest tetricz/xbs-api:amd64$timevar tetricz/xbs-api:arm64$timevar --amend
docker manifest push --purge tetricz/xbs-api:latest
echo "Cleaning up files"
docker buildx prune -fa
cd ..
rm -vfr docker-xbs-api