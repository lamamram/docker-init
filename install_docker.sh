#!/bin/bash

# vérification de l'uid (identifiant utilisateur) qui lance le script
if [ "$(id -u)" -ne 0 ]; then
  echo "lancer avec sudo !!!"
  exit 1
fi

if [[ ! -z $(which docker) ]]; then
  exit 0
fi

# génération du cachec apt
apt-get update -q

# install des prérequis (-y confirme, -q diminue l'affichage en console)
apt-get install -yq \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# téléchargement et install de la clé d'authentification des paquets
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# ajout du dépôt docker qui contient les paquets docker à apt
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

# regénénrer le cache apt pour tenir compte du nouveau dépôt
apt-get update -q

# install des paquets docker
apt-get install -yq \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-compose-plugin

cat <<EOF > /etc/docker/daemon.json
{
  "insecure-registries": ["127.0.0.1:443","$1:443"]
}
EOF

# ajout de l'utilisateur vagrant au groupe docker 
# autorisé à exécuter des commandes docker sans sudo
usermod -aG docker vagrant

