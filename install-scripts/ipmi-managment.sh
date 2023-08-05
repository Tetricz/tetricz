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
rm -r IPMITool/jre
sed -i 's/\jre\/bin\/java/\/usr\/bin\/java/g' IPMITool/SMCIPMITool.lax
echo "Test run"
./IPMITool/SMCIPMITool
if [ $? -eq 182 ]; then
    echo "Ran correctly - moving to bin folder"
    sudo mv -v IPMITool /usr/bin/IPMITool
    rm -vr IPMITool*
    cp -v /etc/profile /tmp/profile
    echo "export PATH=/usr/bin/IPMITool:\$PATH" >> /tmp/profile
    sudo cp -v /tmp/profile /etc/profile
    echo "Run using \"SMCIPMITool\""
    exit 0
else
    echo "Something went wrong...."
    exit 1
fi