#!/bin/sh

set -e

echo "Editing hostname file..."
sudo nano /etc/hostname

echo "Editing SSH configuration..."
sudo nano /etc/ssh/sshd_config

echo "Updating and upgrading system packages..."
(sudo apt update -yy && sudo apt dist-upgrade -yy) &
wait
sudo apt full-upgrade -yy & wait

echo "Installing required packages..."
sudo apt install \
    ufw fail2ban neofetch zsh mariadb-server git btop \
    neovim nginx certbot cron python3-certbot-nginx \
    nodejs npm unattended-upgrades -yy &
wait

echo "Configuring UFW rules..."
sudo ufw allow 22 &
sudo ufw allow ssh &
sudo ufw allow 443 &
sudo ufw allow 443/tcp &
sudo ufw allow 3000 &
sudo ufw allow 3000/tcp &
sudo ufw allow http &
sudo ufw allow https &
sudo ufw allow 'Nginx Full' &
wait
sudo ufw enable & wait

echo "Enabling services..."
sudo systemctl enable ssh &
sudo systemctl enable fail2ban &
sudo systemctl enable nginx &
wait

echo "Reconfiguring unattended-upgrades..."
sudo dpkg-reconfigure --priority=low unattended-upgrades & wait

echo "Cloning configuration repository..."
git clone https://github.com/xtcedro/voidrice.git & wait

echo "Removing old configurations..."
rm .bash* &
rm .profile &
wait

echo "Copying new configurations..."
cp -r ~/voidrice/.config . &
cp -r ~/voidrice/.local . &
ln -s ~/.config/shell/profile .zprofile &
ln -s ~/zsh/.zshrc . &
mkdir -p ~/.cache/zsh/ &
touch ~/.cache/zsh/history &
wait

echo "Setting admin password..."
sudo passwd admin

echo "Changing default shell to zsh..."
chsh

echo "Configuring Git..."
git config --global user.name "xtcedro" &
git config --global user.email "pedro.dfedro@gmail.com" &
wait

echo "Generating SSH key..."
ssh-keygen -t ed25519 -C "pedro.dfedro@gmail.com" &
wait
eval "$(ssh-agent -s)" &
wait
ssh-add ~/.ssh/id_ed25519 &
wait

echo "Setup complete. Please log back in to update the shell to zsh."

echo "Add this SSH key to GitHub for authentication:"
cat ~/.ssh/id_ed25519.pub

exit
