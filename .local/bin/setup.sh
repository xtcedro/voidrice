#!/bin/sh

set -e

sudo nano /etc/hostname

sudo nano /etc/ssh/sshd_config

sudo apt update -yy && sudo apt dist-upgrade -yy

sudo apt full-upgrade -yy

sudo apt install \
	 ufw fail2ban neofetch zsh mariadb-server git btop \
	neovim nginx certbot cron python3-certbot-nginx \
	nodejs npm unattended-upgrades -yy \

sudo ufw allow 22
sudo ufw allow ssh
sudo ufw allow 443
sudo ufw allow 443/tcp
sudo ufw allow 3000
sudo ufw allow 3000/tcp
sudo ufw allow http
sudo ufw allow https
sudo ufw allow 'Nginx Full'
sudo ufw enable

sudo systemctl enable ssh
sudo systemctl enable fail2ban
sudo systemctl enable nginx

sudo dpkg-reconfigure --priority=low unattended-upgrades
git clone https://github.com/xtcedro/voidrice.git
rm .bash*
rm .profile
cp -r ~/voidrice/.config .
cp -r ~/voidrice/.local .
ln -s ~/.config/shell/profile .zprofile
ln -s ~/zsh/.zshrc .
sudo passwd admin
chsh
git config --global user.name "xtcedro"
git config --global user.email "pedro.dfedro@gmail.com"
ssh-keygen -t ed25519 -C "pedro.dfedro@gmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
echo "Setup Complete please log back in to update shell to zsh"

echo "Add this to github to authenticate"
cat ~/.ssh/id_ed25519.pub
exit
