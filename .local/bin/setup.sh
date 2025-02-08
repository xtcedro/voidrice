#!/bin/bash

# Ensure script is run as root
if [[ $EUID -ne 0 ]]; then
   whiptail --title "Error" --msgbox "This script must be run as root!" 10 50
   exit 1
fi

# Step 1: System Update & Install Dependencies
whiptail --title "System Update" --msgbox "Updating system and installing dependencies..." 10 50
apt update && apt upgrade -y
apt install -y git nodejs npm neovim ufw fail2ban mariadb-server nginx zsh neofetch

# Step 2: Configure GitHub Account
GITHUB_NAME=$(whiptail --title "GitHub Setup" --inputbox "Enter your GitHub Name:" 10 50 3>&1 1>&2 2>&3)
GITHUB_EMAIL=$(whiptail --title "GitHub Setup" --inputbox "Enter your GitHub Email:" 10 50 3>&1 1>&2 2>&3)

if [[ -n "$GITHUB_NAME" && -n "$GITHUB_EMAIL" ]]; then
    git config --global user.name "$GITHUB_NAME"
    git config --global user.email "$GITHUB_EMAIL"
    whiptail --title "GitHub Setup" --msgbox "GitHub details configured successfully!" 10 50
else
    whiptail --title "GitHub Setup" --msgbox "GitHub configuration skipped!" 10 50
fi

# Step 3: Generate SSH Key & Add to Agent
whiptail --title "SSH Key Generation" --msgbox "Generating SSH key for GitHub..." 10 50
ssh-keygen -t ed25519 -C "$GITHUB_EMAIL" -f "$HOME/.ssh/github_id_ed25519" -N ""
eval "$(ssh-agent -s)"
ssh-add "$HOME/.ssh/github_id_ed25519"

# Step 4: Display SSH Key for GitHub Setup
PUBLIC_KEY=$(cat "$HOME/.ssh/github_id_ed25519.pub")
whiptail --title "Add SSH Key to GitHub" --msgbox "Copy the following SSH key and add it to GitHub:\n\n$PUBLIC_KEY\n\nGo to GitHub -> Settings -> SSH Keys -> Add Key." 15 70

# Step 5: Configure Firewall
whiptail --title "Firewall Configuration" --msgbox "Configuring UFW firewall rules..." 10 50
ufw allow 443
ufw allow 80
ufw allow 8080
ufw allow OpenSSH
ufw allow 'Nginx Full'
ufw enable

# Step 6: Secure SSH Configuration
whiptail --title "SSH Configuration" --msgbox "Opening SSH config for security tweaks..." 10 50
nano /etc/ssh/sshd_config

# Step 7: Enable & Start Services
whiptail --title "Enabling Services" --msgbox "Enabling and starting Nginx & Fail2Ban..." 10 50
systemctl enable nginx fail2ban
systemctl start nginx fail2ban

# Step 8: Clone NodeLite Repository
whiptail --title "Cloning NodeLite" --msgbox "Cloning the NodeLite repository..." 10 50
cd /opt || exit
git clone https://github.com/xtcedro/NodeLite.git

# Step 9: Move Backend Files to /var/www/backend
whiptail --title "Setting Up Backend" --msgbox "Moving backend files to /var/www/backend/..." 10 50
mkdir -p /var/www/backend
cp -r /opt/NodeLite/* /var/www/backend/
chown -R www-data:www-data /var/www/backend
chmod -R 755 /var/www/backend

# Step 10: Install Dependencies
whiptail --title "Installing Node.js Dependencies" --msgbox "Running npm install to set up backend..." 10 50
cd /var/www/backend || exit
npm install

# Step 11: Install & Configure PM2
whiptail --title "Installing PM2" --msgbox "Installing PM2 process manager..." 10 50
npm install -g pm2@latest

# Ask the user for the PM2 process name
PM2_NAME=$(whiptail --title "PM2 Process Name" --inputbox "Enter a name for your PM2 process:" 10 50 3>&1 1>&2 2>&3)

if [[ -z "$PM2_NAME" ]]; then
    PM2_NAME="backend-service" # Default name if none is provided
fi

# Step 12: Start the Backend with PM2
whiptail --title "Starting Backend with PM2" --msgbox "Starting Node.js backend using PM2..." 10 50
cd /var/www/backend || exit
pm2 start server.js --name "$PM2_NAME"
pm2 save
pm2 startup systemd

# Step 13: Install & Configure Zsh
whiptail --title "Installing Zsh" --msgbox "Installing and setting up Zsh shell..." 10 50
chsh -s /bin/zsh "$USER"

# Step 14: Clone Voidrice Dotfiles
whiptail --title "Cloning Voidrice" --msgbox "Cloning Voidrice configuration files..." 10 50
cd "$HOME" || exit
git clone https://github.com/xtcedro/voidrice.git "$HOME/.voidrice"

# Step 15: Set Up Neofetch
whiptail --title "Setting Up Neofetch" --msgbox "Adding Neofetch to Zsh startup..." 10 50
echo "neofetch" >> "$HOME/.zshrc"

# Final Success Message
whiptail --title "Setup Complete" --msgbox "✅ Backend setup is complete! 🚀\n\n- Node.js backend is running at /var/www/backend/\n- Cloned NodeLite successfully\n- Firewall & security configured\n- PM2 process started as '$PM2_NAME'\n- **Zsh shell installed** and set as default\n- **Voidrice dotfiles cloned**\n- **Neofetch added to shell startup**\n\nUse 'pm2 list' to check running processes!" 15 70