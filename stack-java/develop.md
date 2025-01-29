# utilisation du mode watch avec VSCODE

## problème avec une VM et un dossier partagé avec VSCODE

* si on utilise de mode `docker compose up --watch` ou `docker compose watch`
* l'édition des fichiers synchronisés ne fonctionnent pas avec l'éditeur GUI de VSCODE
* mais l'édition des fichiers depuis un éditeur dans un terminal (vim, nano ...)

## solution: développer avec VSCODE avec une session Remote SSH

1. dans la VM: placer le projet dans le home de la VM `cp -r /vagrant... ~`
2. dans le HOST: exécuter `vagrant ssh-config`
2. dans le HOST: copier le contenu et le placer dans `~/.ssh/config`
3. dans VSCODE : `ctrl + shift + p` > remote-ssh
4. selectionner le nom d'hôte pour se connecter
5. ouvrir le dossier du projet dans `~/<proj>`
6. ici créer un terminal puis `docker compose up --watch`
7. l'édtion depuis l'éditeur VSCODE fonctionne !!!



