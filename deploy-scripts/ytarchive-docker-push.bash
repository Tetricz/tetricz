#!/bin/bash
timevar=$(date +%Y-%b-%d)
echo "Time Variable set to ${timevar}"
echo "Downloading repository"
git clone -4 https://github.com/Tetricz/docker-yt-archive.git
echo "Entering repository"
cd docker-yt-archive
echo "Enable multi-architecture support"
docker run --privileged --rm docker/binfmt:a7996909642ee92942dcd6cff44b9b95f08dad64
echo "Starting build process"
docker buildx build --build-arg GIT_BRANCH=release --platform linux/amd64 -f "Dockerfile" -t tetricz/yt-archive:amd64$timevar --no-cache .
docker buildx build --build-arg GIT_BRANCH=release --platform linux/arm64 -f "Dockerfile" -t tetricz/yt-archive:arm64$timevar --no-cache .
echo "Pushing images to DockerHub"
docker push tetricz/yt-archive:amd64$timevar
docker push tetricz/yt-archive:arm64$timevar
docker manifest create tetricz/yt-archive:latest tetricz/yt-archive:amd64$timevar tetricz/yt-archive:arm64$timevar --amend
docker manifest push --purge tetricz/yt-archive:latest
echo "Cleaning up files"
docker buildx prune -fa
cd ..
rm -vfr docker-yt-archive