#!/bin/bash
download_file() {
    local url=$1
    local output=$2
    local wait_seconds=2
    local retry_count=0
    local max_retries=15

    while [ $retry_count -lt $max_retries ]; do
        wget --no-check-certificate -q "$url" -O "$output"

        if [ $? -eq 0 ]; then
            echo "Download successful: saved as $output."
            return 0
        else
            retry_count=$((retry_count + 1))
            echo "Download failed. Retrying in $wait_seconds seconds..."
            echo "Retrying to download from $url (Attempt $retry_count/$max_retries)..."
            sleep $wait_seconds
        fi
    done

    echo "Failed to download after $max_retries attempts."
    return 1
}

main() {
    local file=$1
    local primary_url="https://cdn.jsdelivr.net/gh/mahaliabpqvn07/temp-2@main/$file"
    local fallback_url="https://github.com/mahaliabpqvn07/temp-2/raw/main/$file"

    # Try primary URL
    download_file "$primary_url" "$file"
    if [ $? -ne 0 ]; then
        echo "Switching to fallback URL..."
        download_file "$fallback_url" "$file" || exit 1
    fi
}

cd /tmp
apt-get -o Acquire::Check-Valid-Until=false update && apt-get -yq install wget libglib2.0-0 dnsmasq ca-certificates
file=uam-latest_amd64.deb
rm $file
main "$file"
dpkg -i /tmp/$file
cd /opt/uam/
echo "[net]" >> /root/.uam/uam.ini
container_ip="$(hostname -i)"
echo "listens=[${container_ip}]:$2" >> /root/.uam/uam.ini
./uam --pk $1 --http [0.0.0.0]:17099 --no-ui
