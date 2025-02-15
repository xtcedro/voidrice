sudo adduser --system --group --disabled-password --home /var/lib/gitea git

export GITEA_VERSION="1.20.3"
sudo -u git wget -O /var/lib/gitea/gitea https://dl.gitea.com/gitea/${GITEA_VERSION}/gitea-${GITEA_VERSION}-linux-amd64
sudo chmod +x /var/lib/gitea/gitea


sudo mkdir -p /var/lib/gitea/{custom,data,log}
sudo chown -R git:git /var/lib/gitea
sudo chmod -R 750 /var/lib/gitea