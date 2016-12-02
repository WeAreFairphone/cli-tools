#!/bin/bash

# Usage:
# curl -O https://raw.githubusercontent.com/WeAreFairphone/cli-tools/master/checksums.sh
# chmod +x checksums.sh
# ./checksums.sh > fpopensums
# sha256sum -c fpopensums

# Change this to "false" if you don't want the FP2-gms_stuff-ota_from_open.zip file
gmsfile=true
# Change this to "false" if you don't want the blob checksum
blobs=true


### RELEASES
html=$(curl -s http://code.fairphone.com/projects/fp-osos/user/fairphone-open-source-os-downloads.html)
sums=($(echo "$html" | grep -A1 sha256sum | awk '/sha256sum/{getline; print}' | cut -d '<' -f2 | cut -d '>' -f2))
filenames=($(echo "$html" | grep ".zip" | cut -d '<' -f3 | cut -d '>' -f2))

if [ "${#sums[@]}" != "${#filenames[@]}" ]; then
    echo "Some weird error, sorry :)"
    exit 1
fi

if [ "$gmsfile" = false ]; then
    unset sums[${#sums[@]}-1]
    unset filenames[${#filenames[@]}-1]
fi

for i in "${!sums[@]}"
do
    echo "${sums[i]} ${filenames[i]}"
done

### BLOBS
if [ "$blobs" = true ]; then
    blobhtml=$(curl -s http://code.fairphone.com/projects/fp-osos/dev/fp2-blobs-download-page.html)
    blobsums=($(echo "$blobhtml" | grep -A1 SHA256SUM | awk '/SHA256SUM/{getline; print}' | cut -d '<' -f2 | cut -d '>' -f2))
    blobfilenames=($(echo "$blobhtml" | grep fp2-sibon- | cut -d '"' -f4 | cut -d '/' -f7))

    if [ "${#blobsums[@]}" != "${#blobfilenames[@]}" ]; then
        echo "Some weird error, sorry :) (2)"
        exit 1
    fi

    # Only print latest
    echo "${blobsums} ${blobfilenames}"
fi
