## création du cluster
1. décommenter les 2 autres machines `docker.worker1.lan` et `docker.worker2.lan` dans le Vagrantfile
2. créer les 2 autres machines `vagrant up`
3. maintenant qu'on a 3 machines on utilise un paramètre pour se connecter sur les machines

```bash
vagrant ssh docker.lan
vagrant ssh docker.worker1.lan
vagrant ssh docker.worker2.lan
```

1. création d'un noeud de type **manager**
  * sur docker.lan: `docker swarm init --advertise-addr [ip de docker.lan]`
  * voir les noeuds du cluster: `docker node ls`

2. ajout d'un noeud de type **worker** au cluster
  * exécuter dans docker.worker{i}.lan
  ```
   docker swarm join --token SWMTKN-1-[SEPCIFIC_TOKEN] [manager_ip]:2377
  ```

3. pour ajouter un noeud plus tard, sur le manager,
   * `docker swarm join-token worker` => qui redonne le token

4. il est possible d'utiliser plusieurs noeuds de type manager
   => pour augmenter les ressources swarm qui pilotent **le cycle de vie des services**
   * dans le manager : `docker node promote worker[i]`
   * REM: un "mini-cluster" Manager élit régulièrement un Leader Prime pour initier les servies du Manager
   => étant qu'on a un élection il nous faut un nb **impair** de leaders pour faciliter le
   résulat


## lancement d'un service sur le cluster

* un service est l'abstraction de l'accès à un conteneur sans savoir sur quelle machine il se trouve
* le conteneur peut même être répliqué sur plusieurs noeuds du cluster
* pour 1 **service**, on peut avoir n conteneurs répliqués que l'on nomme **task**

* exemple: 
```
docker service create \
  --name helloswarm \
  --replicas 2 \
  alpine:3.16 \
  sleep 1000
```

* liste des services du cluster: `docker service ls`
* inspection d'un service: `docker service inspect --pretty [service_name]`
* détail des conteneurs d'un service (task): `docker service ps [service_name]`
* utiliser également `docker run -it -d -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock dockersamples/visualizer` pour visualiser graphiqument
* les logs du service: `docker service logs [service_name]`
* suppression du service: `docker service rm [service_name]`
> attention: on ne stoppe ni démarre un sevrvice !!!

### placement des tâches d'un service

1. utilisation de contraintes: `docker service ... --constraint node.role!=manager` pour préserver le manager
par ex.
2. contraintes custom utilisant les labels sur les nodes:
  * `docker node update --label-(add|rm) <label>=<value> <node_name>`
  * `docker service create ... --constraint node.labels.<label_name>(==|!=)<value> ...` 
3. équilibrage selon des labels: => disposition la plus équilibrée selon les valeurs d'un label
  * `docker service create ... --placement-pref spread=node.labels....`
  * avec `docker node(i) update --label-add key=x, node(j) update --label-add key=y, ...`
  * les nodes non taggés sont considéré avec la valeur null donc ils sont conernés dans la répartition
  * l'algorithme n'est pas très sûr ...

### mise à jour d'un service : rolling update

* mise à jour de tous les aspects d'un service
  - image des conteneurs: `--image [new_image]`
  - commande des tâches: `--args "new command"`
  - config réseaux des conteneurs `--network-add, --network-rm ...`
  - volumes
  - ressources dispo ...
  - repliques : `docker service scale <service_name>=<replica_nb>`

* montée en versions
  - préalable: établir un timeout entre 2 mises à jours de conteneurs pour un même service
  ```
  docker service create \
  --name helloswarm \
  --replicas 2 \
  --update-delay 10s \
  --
  alpine:3.16 \
  sleep 1000
  ```

  - mise à jour de l'image : `docker service update --image [new_image] [service]`
  - le service garde l'historique des conteneur de la version précédente en cas de rollback
  - visualiser l'historique d'un noeud : `docker node ps`
  - visualiser l'historique de toutes les tâches : `docker service ps`
  - connecter / déconnecter sur des réseaux (a priori on est sur le réseau ingress de type overlay): **--network-(add|rm)** 
  - fixer la profondeur de l'historique défaut 5: `docker swarm update --task-history-limit n`

  * mises à jour secondaires

  - ex: modifier le délais entre 2 phases d'une update
  - ex: modifier le nb de tâches mises à jour par phase
  `docker service update --update-delay --update-parallelism [service_name]`
  
  ![schéma](./rolling-update.gif)

### rollback
  - silplifié puisque on ne peut pas reset vers un état hors l'état précédent
  - le rollback ne va pas impacter le options liés au mode d'update (paralélisme etc.)

## configuration réseau mesh

* la communication utilise un réseau nommé **ingress** de type **overlay**
* ce driver fonctionne en utilisant la technologie **VXLAN** pour transiter les trames 2, 3 virtuelles dans une trame 4 tcp ou udp du réseau de noeuds => tunneling comme VLAN
* le réseau overlay est installé d'abord sur le manager et installé sur les workers lors une tâche est installée dessus
* un service ne spécifie pas de réseau utilise le réseau **ingress**
* le réseau docker_gwbridge connecte les dockers daemon des noeuds pour les rollings rollback create ...

* l'option `--publish published=8080,target=80` pilote l'utilisation du réseau 'mesh' ou réseau maillé de docker swarm par défaut
* quelque soit le noeud public sur lequel on demande le port publié, on aura accès au service
* cette disponibilité est assurée par des agents d'équilibrage de charge "load balancer" installé sur tous les noeuds => réseau maiilé => mesh network

![schema](./ingress-routing-mesh.png)

## relier les conteneur à travers les noeuds (overlay network)

* création sur le manager d'un réseau de type overlay qui couvre tous les noeuds
  - `docker network create --driver overlay app_net`

* ajout d'un service au réseau
  - `docker service update --network-add app_net nginx`

* tester le service java_app sur un réseau overlay
  - pb: l'image custom java_tomcat:1.0 n'existe a priori que sur le manager
  - les images doivent être téléchargeables depuis tous les noeuds ==> installer un service registry !!
  - WorkAround: utiliser les dossiers partagés /vagrant des VM vagrant
    + `docker save -o [/path/to/java_tomcat.tar] java_tomcat:1.0`: svg au format tar
    + `sudo docker load -i java_tomcat.tar` : charger sur worker1 et 2 à partir du tar dans /vagrant
  
  - création des deux services httpd et tomcat sur le réseau app_net
    + reconnaissance des **noms de services comme alias réseaux**
  ```
  docker service create \
    --name tomcat \
    --replicas 2 \
    --network app_net \
    java_tomcat:1.0
  
  docker service create \
    --name httpd \
    --replicas 2 \
    --network app_net \
    --publish published=8081,target=80 \
    java_httpd:1.0
  ```

  ## déploiement sur le cluster via docker compose

  * modification du stack.yml
    - voir swarm_stack_java/stack.yml
  
  * déploiement de la stack
  ```
  docker stack deploy \
    --compose-file swarm_stack_java/stack.yml \
    java_stack
  ```

  * analyse de la stack
    - `docker stack ls`
    - `docker stack ps [stack_name]`
  
  * relancer un conf
    - `docker stack rm [stack_name] && docker deploy ...
  
  * CAVEATS:
    - les images doivent être disponibles dans tous les noeuds 
      => le build des images est la responsabilité du dockerd 
      => et donc le stockage des images
  
# AJOUT d'un registre docker

1. ajouter un service 
  * même que docker compose sans restart
  * en ajoutant un réseau overlay au lieu un bridge
  * en ajoutant la structure deploy: avec un placement:constraint: node.role==manager

2. ajouter les "insecure-registries":"docker.lan:443" dans le /etc/docker/daemon.json
   * `sudo systemctl restart docker`

3. exécuter docker  login docker.lan:443 -u testuser -p password sur tous les noeuds
   * la conx sur le manager est locale parce que docker.lan est 127.0.0.1 
   => donc dockerd se dégrade sur http

4. on peut demander l'image poussée formation.lan:443/<image>:<tag> dans la stack.yml
5. `docker stack deploy --with-registry-auth --compose-file stack.yml stack_xxxx`
