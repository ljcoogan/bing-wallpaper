#!/usr/bin/bash

# Last modified by Liam Coogan, 2025-05-03

# This script will download today's Bing wallpaper to the specified directory,
# and set it as the wallpaper on the GNOME desktop environment.

# To run this script every time your user logs in,
# place this and 'bing.desktop' in '~/.config/autostart'

# Directory wallpaper will be saved to
DIR="/home/$USER/Pictures/Bing"

# Allow time for computer to connect to the internet
sleep 10

# Download the XML metadata for today's image
XML=$(curl -s "https://www.bing.com/HPImageArchive.aspx?format=xml&idx=0&n=1")

# If XML has not downloaded, exit with failure
if [[ -z "$XML" ]]
then
	notify-send "Bing Wallpaper: Failed to download wallpaper."
 	exit 1
fi

# Get URL of image for downloading
IMG=$(echo "$XML" | grep -oP "(?<=<urlBase>).*?(?=</urlBase>)")
URL="https://bing.com${IMG}_1920x1080.jpg"

# File name will be date, formatted YYYYMMDD
DATE=$(echo "$XML" | grep -oP "(?<=<startdate>).*?(?=</startdate>)")
FILE="${DIR}/${DATE}.jpg"

# If file has already been downloaded, we can exit now
if [[ -f "$FILE" ]]
then
	exit 0
fi

# Save file to specified location
mkdir -p "$DIR"
curl -s -o "$FILE" "$URL"

# If the image file has not downloaded, exit with failure
if [[ ! -f "$FILE" ]]
then
	notify-send "Bing Wallpaper: Failed to download wallpaper."
	exit 1
 fi
 
# Set GNOME desktop wallpaper for current user
gsettings set org.gnome.desktop.background picture-uri "file://${FILE}"
gsettings set org.gnome.desktop.background picture-uri-dark "file://${FILE}"
