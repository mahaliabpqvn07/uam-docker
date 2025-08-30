#!/bin/bash
cd /tmp
apt update && apt -yq install wget libglib2.0-0 dnsmasq ca-certificates wondershaper
update-ca-certificates
file=uam-latest_amd64.deb
rm $file
wget --no-check-certificate https://update.u.is/downloads/uam/linux/$file
dpkg -i /tmp/$file
cd /opt/uam/
echo "[net]" >> /root/.uam/uam.ini
container_ip="$(hostname -i)"
echo "listens=[${container_ip}]:$2" >> /root/.uam/uam.ini
# wondershaper eth0 $3 $4 &
./uam --pk $1 --http [0.0.0.0]:17099 --no-ui
