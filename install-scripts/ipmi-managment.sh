#!/bin/bash
echo "Installing dependencies...."
# Currently as I am writing, it seems to be built on Java 11
sudo apt-get install openjdk-11-jre-headless
echo "Downloading IPMITool"
# This is my own hosted link, as I could not get a link from supermicro's official site
# If this isn't up to date message me, if you have a link that is continously up to date hosted by supermicro... please gib me
curl -L https://link.us1.storjshare.io/s/jvh6kbc3pdgqzpt5pxls3or55nsq/files/tools/SMCIPMITool_2.26.0_build.220209_bundleJRE_Linux_x64.tar.gz?download=1 --output ./IPMITool.tar.gz
tar -xvf ./IPMITool.tar.gz
mv -v SMCIPMITool_2* IPMITool