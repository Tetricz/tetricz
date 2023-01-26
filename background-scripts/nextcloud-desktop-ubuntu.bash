#!/bin/bash
# Run this script be wherever you want the nextcloud desktop AppImage to downloaded/stored
# Then add this script to either yor crontab or systemd timer such that it starts after boot/login
# You may also need to install libfuse2(sudo apt install libfuse2)

# Tests whether github is pingable/online
# Since the cdn is github
function test_connection () {
    echo "Testing connection"
    if ! ping -qc 1 -W 2 github.com &>/dev/null; then
        echo "No connection to github.com"
        exit 1
    fi
    echo "OK 200"
}

# Download the latest version of the AppImage
function download_latest () {
    echo "Downloading latest version"
    curl -LO $appimage
    curl -LO $imageasc
    chmod +x Nextcloud*.AppImage
}

# https://nextcloud.com/nextcloud.asc
# Check if it's already installed and if not install it
function nextcloud_pub_key () {
    if ! gpg --list-keys "Nextcloud Security" &> /dev/null; then
        curl -LO https://nextcloud.com/nextcloud.asc
        gpg --keyid-format long --list-options show-keyring nextcloud.asc
        gpg --import nextcloud.asc
        rm -vf nextcloud.asc
    fi
}

# Verify the AppImage
function verify_image () {
    echo "Verifying image"
    gpg --verify Nextcloud*.AppImage.asc Nextcloud*.AppImage
}


# Main
test_connection
nextcloud_pub_key
#Split .AppImage and .AppImage.asc into a list
nc_links=$(curl -s https://api.github.com/repos/nextcloud/desktop/releases/latest | grep -i 'browser_download_url.*\.AppImage' | sed 's/.*\(http.*\)"/\1/')
appimage=$(echo $nc_links | cut -f1 -d" ")
imageasc=$(echo $nc_links | cut -f2 -d" ")

# Determine which version is currently downloaded
# Then download newer if newer is available
ls Nextcloud*.AppImage &>/dev/null
nc_file=$?
ls Nextcloud*.AppImage.asc &>/dev/null
nc_fasc=$?
if [[ $nc_file != 0 || $nc_fasc != 0 ]]
then
    rm -vf Nextcloud*.AppImage Nextcloud*.AppImage.asc
    download_latest
else
    current=$(ls Nextcloud*.AppImage | sed 's/.*\/\([^\/]*\)/\1/')
    echo "Current Version: ${current}"
    online=$(echo $appimage | sed 's/.*\/\([^\/]*\)/\1/')
    echo "Online Version: ${online}"
    if [ ${online} != ${current} ]; then
        echo "Version mismatch"
        echo "Removing old version"
        rm -fv ${current} ${current}.asc
        download_latest
    fi
fi

verify_image

# Run the AppImage
./Nextcloud*.AppImage
