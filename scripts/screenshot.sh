#!/usr/bin/env bash

filename=$(date +%s).png
location=~/Screenshots/

full() {
    maim -u $location$filename
}

select_area() {

    maim -us $location$filename
}

notification() {
    xclip -selection clipboard -t image/png $location$filename
    ffmpeg -i $location$filename -vf scale=320:-1 /tmp/$filename
    notify-send -i /tmp/$filename "Screenshot taken" "Saved and copied to clipboard"
}

help() {
    echo "Screenshot script using Maim.
    full - screenshot full screen
    window - screenshot window or area
    "
}

case "$@" in
    "full") full; notification
    ;;
    "window") select_area; notification
    ;;
*) help
    ;;
esac
