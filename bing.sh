#!/usr/bin/bash

# Last modified by Liam Coogan, 2024-04-30

# This script will download today's Bing wallpaper to the specified directory,
# and set it as the wallpaper on the GNOME desktop environment.

# To run this script every time your user logs in,
# place this and 'bing.desktop' in '~/.config/autostart'

# User whose wallpaper will be set
USER=$(whoami)

# Directory wallpaper will be saved to
DIR="/home/$USER/Pictures/Bing"

# Allow time for computer to connect to the internet
sleep 10

# Download the XML metadata for today's image
XML=$(wget -q -O - "https://www.bing.com/HPImageArchive.aspx?format=xml&idx=0&n=1")

# Ensure XML has downloaded successfully before continuing
if [[ -n "$XML" ]]
then
	# Get URL of image for downloading
	IMG=$(echo "$XML" | grep -oP "(?<=<urlBase>).*?(?=</urlBase>)")
	URL="https://bing.com${IMG}_1920x1080.jpg"
	
	# File name will be date, formatted YYYYMMDD
	DATE=$(echo "$XML" | grep -oP "(?<=<startdate>).*?(?=</startdate>)")
	FILE="${DIR}/${DATE}"
	
	# Ensure file has not already been downloaded before continuing
	if [[ ! -f "$FILE" ]]
	then
		# Save file to specified location
		mkdir -p "$DIR"
		wget -q -O "$FILE" "$URL"
		
		# Ensure file has downloaded successfully before continuing
		if [[ -f "$FILE" ]]
		then
			# Set GNOME desktop wallpaper for current user
			gsettings set org.gnome.desktop.background picture-uri "file://${FILE}"
		else
			# Notify user file failed to download
			notify-send "Bing Wallpaper: Failed to download wallpaper."
		fi
	fi
else
	# Notify user XML failed to download.
	notify-send "Bing Wallpaper: Failed to download wallpaper."
fi
