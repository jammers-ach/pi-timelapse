#!/bin/bash

set -euo pipefail


if (( $# != 3 ))
then
    echo "Uasge: make_timelapse.sh [dir_of_capture/] [duration_in_seconds] filename "
    echo "e.g. make_timelapse.sh ./capture/ 60 output"
    echo "to make a 60 second video of all the files in ./capture/"
    exit 0
fi


capture_dir="$1"
total_dur="$2"
filename="$3"

total_files=$(ls $capture_dir/*.jpg | wc -l)
frame_rate=$((total_files/total_dur))

if [ $frame_rate -lt 1 ] 
then
    echo "Can't display at less than 1 fps, aborting"
    exit
fi

echo "There are $total_files images"
echo "Display at $frame_rate fps"

rm $capture_dir/new_image*.jpg || true

# create nicely numbered files for avconv/ffmpeg to handle
pushd "$capture_dir"
ls image*.jpg| awk 'BEGIN{ a=0 }{ printf "cp %s new_image%010d.jpg\n", $0, a++ }' | sh
popd


avconv -r "$frame_rate" -i "$capture_dir/new_image%010d.jpg" -r "$frame_rate" -vcodec libx264 -vf scale=1280:720 "$filename.mp4"

rm $capture_dir/new_image*.jpg || true
