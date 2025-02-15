#!/bin/bash

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    whiptail --title "Permission Denied" --msgbox "This script must be run as root!" 10 50
    exit 1
fi

# Function to show a progress bar
show_progress() {
    {
        for ((i = 0; i <= 100; i += 10)); do
            echo $i
            sleep 0.2
        done
    } | whiptail --gauge "$1" 10 50 0
}

# Update system
show_progress "Updating system packages..."
apt update && apt upgrade -y

# Install dependencies
show_progress "Installing dependencies..."
apt install -y ca-certificates curl gnupg lsb-release

# Add Docker’s GPG Key
show_progress "Adding Docker's GPG Key..."
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | tee /etc/apt/keyrings/docker.gpg > /dev/null
chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker repository
show_progress "Adding Docker repository..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package index
show_progress "Updating package index..."
apt update

# Install Docker
show_progress "Installing Docker..."
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start & Enable Docker
show_progress "Starting and enabling Docker..."
systemctl start docker
systemctl enable docker

# Verify installation
docker --version &> /dev/null
if [ $? -eq 0 ]; then
    whiptail --title "Installation Complete" --msgbox "Docker has been successfully installed!" 10 50
else
    whiptail --title "Installation Failed" --msgbox "Docker installation failed. Check logs for details." 10 50
    exit 1
fi

# Offer to add user to Docker group
if (whiptail --title "User Permissions" --yesno "Do you want to add your user to the Docker group (run Docker without sudo)?" 10 60); then
    usermod -aG docker $USER
    whiptail --title "User Added" --msgbox "User added to the Docker group. Please log out and log back in." 10 50
fi

# Test Docker installation
if (whiptail --title "Test Docker" --yesno "Do you want to test Docker with 'hello-world'?" 10 50); then
    docker run hello-world
fi