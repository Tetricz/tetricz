#!/bin/bash
timevar=$(date +%Y-%b-%d)
echo "Time Variable set to ${timevar}"
echo "Downloading repository"
git clone -4 https://github.com/Tetricz/docker-jmusic-bot.git
echo "Entering repository"
cd docker-jmusic-bot
echo "Enable multi-architecture support"
docker run --privileged --rm docker/binfmt:a7996909642ee92942dcd6cff44b9b95f08dad64
echo "Starting build process"
docker buildx build --platform linux/amd64 -f "Dockerfile" -t tetricz/jmusic-bot:amd64$timevar --no-cache .
docker buildx build --build-arg OPENJDK_VERSION=16-buster --platform linux/arm64 -f "Dockerfile" -t tetricz/jmusic-bot:arm64$timevar --no-cache .
echo "Pushing images to DockerHub"
docker push tetricz/jmusic-bot:amd64$timevar
docker push tetricz/jmusic-bot:arm64$timevar
docker manifest create tetricz/jmusic-bot:latest tetricz/jmusic-bot:amd64$timevar tetricz/jmusic-bot:arm64$timevar --amend
docker manifest push --purge tetricz/jmusic-bot:latest
echo "Cleaning up files"
docker buildx prune -fa
cd ..
rm -vfr docker-jmusic-bot