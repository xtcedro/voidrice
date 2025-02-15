distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
   && curl -fsSL https://dl.gitea.io/gitea/gpg.key | sudo tee /usr/share/keyrings/gitea-archive-keyring.gpg >/dev/null \
   && echo "deb [signed-by=/usr/share/keyrings/gitea-archive-keyring.gpg] https://dl.gitea.io/gitea $distribution main" | sudo tee /etc/apt/sources.list.d/gitea.list
