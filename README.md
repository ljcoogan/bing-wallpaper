A Bash script for Linux systems that will download the latest Bing daily image and set it as the wallpaper for the GNOME desktop environment.

To set this script to run on startup:
- `chmod +x bing.sh`
- `mkdir -p ~/.config/autostart`
- `mv bing.sh bing.desktop ~/.config/autostart`

This code should work on any system with the [GNOME](https://www.gnome.org/) desktop environment and [curl](https://curl.se/) installed. If you're running Ubuntu or Debian, run `sudo apt install curl`.
