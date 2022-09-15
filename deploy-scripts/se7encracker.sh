#!/bin/bash
timevar=$(date +%Y-%b-%d)
echo "Time Variable set to ${timevar}"
echo "Downloading repository"
git clone -4 https://github.com/Tetricz/se7enCracker.git
echo "Entering repository"
cd se7enCracker
git checkout dev
echo "Enable multi-architecture support"
docker run --privileged --rm docker/binfmt:a7996909642ee92942dcd6cff44b9b95f08dad64
echo "Starting build process"
docker buildx build -f "Dockerfile" -t tetricz/se7encracker:amd64$timevar --no-cache .
echo "Pushing images to DockerHub"
docker push tetricz/se7encracker:amd64$timevar
docker manifest create tetricz/se7encracker:latest tetricz/se7encracker:amd64$timevar --amend
docker manifest push --purge tetricz/se7encracker:latest
echo "Cleaning up files"
docker buildx prune -fa
cd ..
rm -vfr se7enCracker