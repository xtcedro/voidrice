#!/bin/bash

# Ensure the script runs with root privileges
if [[ $EUID -ne 0 ]]; then
    whiptail --title "Permission Denied" --msgbox "Please run this script as root using sudo." 10 50
    exit 1
fi

# Set variables
GITEA_VERSION="latest"  # You can change this to a specific version
DOWNLOAD_URL="https://dl.gitea.io/gitea/${GITEA_VERSION}/gitea-${GITEA_VERSION}-linux-amd64"
INSTALL_DIR="/usr/local/bin/gitea"

# Confirmation dialog before downloading
if whiptail --title "Download Gitea" --yesno "Do you want to download Gitea (AMD64)?" 10 60; then
    # Downloading Gitea
    whiptail --title "Downloading Gitea" --infobox "Downloading Gitea (AMD64)..." 10 50
    wget -q --show-progress -O "$INSTALL_DIR" "$DOWNLOAD_URL"

    # Check if download was successful
    if [[ $? -ne 0 ]]; then
        whiptail --title "Download Failed" --msgbox "Failed to download Gitea. Check your internet connection." 10 50
        exit 1
    fi

    # Set executable permissions
    chmod +x "$INSTALL_DIR"

    # Notify the user
    whiptail --title "Installation Complete" --msgbox "Gitea has been downloaded and installed in $INSTALL_DIR." 10 50

    # Ask if the user wants to run Gitea
    if whiptail --title "Run Gitea" --yesno "Do you want to start Gitea now?" 10 50; then
        "$INSTALL_DIR" web
    else
        whiptail --title "Exit" --msgbox "You can start Gitea later using: \n\n sudo gitea web" 10 50
    fi
else
    whiptail --title "Installation Cancelled" --msgbox "Gitea installation was cancelled." 10 50
    exit 0
fi