#!/bin/bash

# Ensure the script runs as root
if [[ $EUID -ne 0 ]]; then
    whiptail --msgbox "This script must be run as root. Try using sudo." 10 60
    exit 1
fi

# Prompt user to set a new password
whiptail --msgbox "You will now set a password for your user account." 10 60

# Run passwd command to change the user's password
passwd $USER

# System Update & Package Installation
whiptail --msgbox "Updating system and installing necessary packages..." 10 60
apt update && apt upgrade -y
apt install -y git nodejs npm neovim ufw fail2ban mariadb-server nginx certbot python3-certbot-nginx zsh neofetch 

# Configure Firewall (UFW)
whiptail --msgbox "Configuring firewall rules..." 10 60
ufw allow 443
ufw allow http
ufw allow https
ufw allow ssh
ufw allow 22
ufw allow 80
ufw allow 8080
ufw allow 'Nginx Full'
ufw enable

# SSH Configuration
whiptail --msgbox "Editing SSH configuration for security. Press Enter, modify as needed, then save & exit." 10 60
nano /etc/ssh/sshd_config
systemctl restart ssh

# Prompt user for domain name
DOMAIN=$(whiptail --inputbox "Enter your domain name (e.g., example.com):" 10 60 3>&1 1>&2 2>&3)

# Check if domain was entered
if [ -z "$DOMAIN" ]; then
    whiptail --msgbox "No domain entered. SSL certificate setup skipped." 10 60
else
    # Run Certbot with the provided domain
    certbot --nginx -d "www.$DOMAIN" -d "$DOMAIN"

    # Notify user of completion
    whiptail --msgbox "SSL certificate setup completed for $DOMAIN and www.$DOMAIN!" 10 60
fi



# Prompt user for GitHub details
GITHUB_USERNAME=$(whiptail --inputbox "Enter your GitHub username:" 10 60 3>&1 1>&2 2>&3)
GITHUB_EMAIL=$(whiptail --inputbox "Enter your GitHub email:" 10 60 3>&1 1>&2 2>&3)

# Confirm details before proceeding
whiptail --yesno "You entered:\n\nUsername: $GITHUB_USERNAME\nEmail: $GITHUB_EMAIL\n\nProceed with SSH key generation?" 12 60
if [ $? -ne 0 ]; then
    whiptail --msgbox "Operation canceled!" 10 40
    exit 1
fi

# Generate SSH Key
whiptail --msgbox "Generating SSH Key for GitHub access..." 10 60
ssh-keygen -t ed25519 -C "$GITHUB_EMAIL"

# Start the SSH agent and add the key
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Display public SSH key for GitHub setup
SSH_KEY=$(cat ~/.ssh/id_ed25519.pub)
whiptail --msgbox "Copy your SSH key and add it to GitHub:\n\n$SSH_KEY\n\nGo to GitHub > Settings > SSH and GPG keys > New SSH Key." 15 80

# Clone NodeLite Backend & Setup PM2
whiptail --msgbox "Setting up Node.js backend..." 10 60
mkdir -p /var/www/backend && cd /var/www/backend
git clone https://github.com/xtcedro/NodeLite.git .
npm install

APP_NAME=$(whiptail --inputbox "Enter a name for your Node.js app in PM2:" 10 60 3>&1 1>&2 2>&3)
pm2 start server.js --name "$APP_NAME"
pm2 startup systemd
pm2 save

# Install Zsh & Clone Voidrice
whiptail --msgbox "Installing Zsh and cloning Voidrice for customization..." 10 60
chsh -s /bin/zsh
git clone https://github.com/xtcedro/voidrice.git ~/voidrice
whiptail --msgbox "Voidrice has been cloned. You may need to manually apply configurations." 10 60



# Set up auto-renewal of SSL certificates
echo "0 0 * * * certbot renew --quiet" | crontab -

# ==============================
# MariaDB Secure Installation & Setup
# ==============================

whiptail --msgbox "Configuring MariaDB security settings..." 10 60
mysql_secure_installation <<EOF

Y
n
Y
Y
Y
Y
EOF

# Create database and user
DB_NAME=$(whiptail --inputbox "Enter the database name:" 10 60 3>&1 1>&2 2>&3)
DB_USER=$(whiptail --inputbox "Enter the database username:" 10 60 3>&1 1>&2 2>&3)
DB_PASS=$(whiptail --passwordbox "Enter the database password:" 10 60 3>&1 1>&2 2>&3)

mysql -u root -p <<EOF
CREATE DATABASE $DB_NAME;
CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
EOF

# ==============================
# Environment Variable Setup
# ==============================
whiptail --msgbox "Setting up environment variables for the backend..." 10 60

cat <<EOF > /var/www/backend/.env
PORT=3000
DB_HOST=localhost
DB_USER=$DB_USER
DB_PASS=$DB_PASS
DB_NAME=$DB_NAME
EOF

chown $(whoami):$(whoami) /var/www/backend/.env
chmod 600 /var/www/backend/.env

# Restart PM2 to apply changes
pm2 restart "$APP_NAME"

# Enable & Start Essential Services
whiptail --msgbox "Enabling and starting essential services (Nginx, Fail2Ban)..." 10 60
systemctl enable --now nginx fail2ban

# Final Success Message
whiptail --msgbox "Setup completed successfully! 🚀 Your server is now fully configured with MariaDB, Node.js, PM2, and security enhancements." 10 60