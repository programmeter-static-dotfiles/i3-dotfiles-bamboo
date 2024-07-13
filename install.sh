#!/bin/bash

# THIS SCRIPT IS NOT JUST FOR INSTALLING MY I3 THEME!!!
# IT ALSO INSTALLS PACKAGES WHICH YOU PROBABLY DON'T NEED,
# AND THEY MIGHT EVEN BREAK YOUR SYSTEM
# IT IS FOR MY PERSONAL USE ONLY
# DO NOT RUN THIS SCRIPT

# Set up variables
read -p "[!] Enter username: " username
read -p "Install Nvidia drivers? [y/n]: " nvidia_prompt
while [[ "$nvidia_prompt" != "y" && "$nvidia_prompt" != "Y" && "$nvidia_prompt" != "n" && "$nvidia_prompt" != "y" && "$nvidia_prompt" != "N" ]]
do	
	echo "Please select y/n"
	read -p "Install Nvidia drivers? [y/n]: " nvidia_prompt
done
home_dir='/home/'"$username"

# Update LightDM to match given username
sed -i 's/defaultuser/'"$username"'/g' lightdm.conf

# Add additional repositories
apt install software-properties-common -y
apt-add-repository non-free -y
apt-add-repository contrib -y
dpkg --add-architecture i386

# Get Enpass repo key
echo "deb https://apt.enpass.io/ stable main" > \
  /etc/apt/sources.list.d/enpass.list
wget -O - https://apt.enpass.io/keys/enpass-linux.key | tee /etc/apt/trusted.gpg.d/enpass.asc
apt update

# Download necessary .debs
wget https://launcher.mojang.com/download/Minecraft.deb

# Install all packages
if [[ "$nvidia_prompt" == "y" || "$nvidia_prompt" == "Y" ]]; then
	apt install nvidia-driver nvidia-settings nvidia-driver-libs:i386 -y
fi
apt install xorg i3 pulseaudio alsa-utils steam gimp inkscape xfce4-settings yaru-theme-gtk thunderbird firefox-esr alacritty thunar vim git unzip shotwell celluloid gvfs-backends samba cifs-utils smbclient rofi i3blocks kbdd lightdm feh picom xinput maim xclip xdotool libsdl2-2.0-0 libsdl2-dev libsdl2-image-2.0-0 libsdl2-image-dev libsdl2-ttf-2.0-0 libsdl2-ttf-dev libsdl2-mixer-2.0-0 libsdl2-mixer-dev gtk2-engines-murrine gtk2-engines-pixbuf rhythmbox xautolock htop libavcodec-extra playerctl gnome-disk-utility gufw enpass libreoffice libreoffice-gtk3 printer-driver-hpcups hplip gamemode openvpn openssl openresolv transmission-gtk rsync timeshift pavucontrol gdb flatpak galculator mousepad python3.11-venv thunar-archive-plugin neovim ./Minecraft.deb -y
apt install --no-install-recommends xfce4-session -y
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install com.discordapp.Discord io.github.shiftey.Desktop com.vscodium.codium -y
apt autoremove dmenu libreoffice-math libreoffice-draw libreoffice-draw libreoffice-impress libreoffice-base -y

# Copy all configurations
mkdir -p "$home_dir"/.local/share/
mkdir "$home_dir"/.config/
cp -r .scripts/ "$home_dir"
sudo cp -r /usr/share/themes/Yaru /usr/share/themes/Yaru-dark /usr/share/themes/Yaru-sage /usr/share/themes/Yaru-sage-dark ~/.local/share/themes/
cp -r wallpapers/ "$home_dir"/.local/share/
cp -r icons/ "$home_dir"/.local/share/
cp .bashrc "$home_dir"/
cp .vimrc "$home_dir"/
cp settings.desktop /usr/share/applications/
cp lightdm.conf /etc/lightdm/
cp alacritty/alacritty.yml "$home_dir"/.config/
cp -r picom/ "$home_dir"/.config/
cp -r i3/ "$home_dir"/.config/
cp -r i3blocks/ "$home_dir"/.config/
cp -r dunst/ "$home_dir"/.config/
cp -r rofi/ "$home_dir"/.config/
mkdir -p "$home_dir"/Pictures/screenshots

flatpak override --filesystem=xdg-data/themes
flatpak override --filesystem=xdg-data/icons
flatpak override --env=GTK_THEME=Yaru-sage-dark
flatpak override --env=ICON_THEME=Papirus-Dark

chown -R "$username":"$username" "$home_dir"/.local
chown -R "$username":"$username" "$home_dir"/.config
chown -R "$username":"$username" "$home_dir"/Pictures/screenshots

timedatectl set-local-rtc 0

xdg-settings set default-web-browser firefox-esr.desktop
xdg-mime default thunar.desktop inode/directory

mkdir /boot/grub/theme
cp -r grub-theme-debian/* /boot/grub/theme/
cp -r .fonts/ "$home_dir"/
cp grub /etc/default/

chown root:root /etc/default/grub
chown -R root:root /boot/grub/theme/
chown root:root "$home_dir"/.config/i3/vpn.sh
chmod -w /etc/default/grub
chmod -w "$home_dir"/.config/i3/vpn.sh

update-grub

echo "Don't forget to copy VPN files to /etc/openvpn"
echo "Set up Timeshift and set rsync destination in i3/config"
echo "Add @reboot sleep 10 && /usr/bin/apt-get update to sudo crontab -e"
echo "Copy lightdm.conf to /etc/lightdm/ if you are prompted to log in after boot"
echo "Reboot your computer to apply the changes!"
