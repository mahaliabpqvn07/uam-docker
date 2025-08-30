#!/bin/bash
cd /tmp
apt-get -o Acquire::Check-Valid-Until=false update && apt-get -yq install wget libglib2.0-0 dnsmasq ca-certificates
file=uam-latest_amd64.deb
rm $file
wget --no-check-certificate https://github.com/anhtuan9414/temp-2/raw/main/$file
dpkg -i /tmp/$file
cd /opt/uam/
./uam --pk $1 --http [0.0.0.0]:17099 --no-ui
