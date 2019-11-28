#!/bin/bash

set -euo pipefail


if (( $# != 2 ))
then
    echo "Uasge: timelapse.sh [PERIOD] [SECONDS OF CAPTURe]"
    echo "e.g. timelapse.sh 1 60, to get 1 minute of capture with a picture every 1 second"
    echo
    echo "set 0 and 0 to get a single shot"
    exit 0
fi

# How many seconds between screenshots
period=$1

# How long in total to make the screenshots
session=$2

WIDTH=${WITH:-1280}
HEIGHT=${HEIGHT:-960}

if [[ "$period" == 0 ]] 
then
    count=1
else
    count=$((session/period))
fi
i=0

HOME_DIR=/home/pi/capture

mkdir -p "$HOME_DIR"

while [ "$i" -lt "$count" ]
do
    echo "SNAP $((i++))/$count"
    raspistill -dt -o "$HOME_DIR/image%d.jpg" -w "$WIDTH" -h "$HEIGHT" -rot 90
    sleep "$period"
done

