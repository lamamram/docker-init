#!/bin/bash

# # ajout des éléments à utiliser à distance
# sudo apt-get install -y nfs-kernel-server
# sudo mkdir /mnt/nfs-dir
# cp index.php php8.2.conf mariadb-init.sql /mnt/nfs-dir

# # conf nfs "vanilla"
# sudo chown -R nobody:nogroup /mnt/nfs-dir
# sudo chmod 755 /mnt/nfs-dir
# sudo chmod 644 /mnt/nfs-dir/*
# # configuration server nfs
# echo "/mnt/nfs-dir *(rw,sync,no_subtree_check,no_all_squash)" | sudo tee -a /etc/exports
# sudo exportfs -a
# sudo systemctl restart nfs-kernel-server

docker volume create \
       --driver local \
       --opt type=nfs \
       --opt o=addr=192.168.1.30,ro \
       --opt device=:/mnt/nfs-dir \
       nfs-vol


