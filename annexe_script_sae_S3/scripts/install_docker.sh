#!/bin/bash

install_docker(){
printf "Installation de Docker : \n"
apt-get -y install ca-certificates
apt-get -y install curl 
apt-get -y install gnupg
apt-get -y install lsb-release
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get -y update
apt-get install -y docker-ce -y docker-ce-cli -y containerd.io -y docker-compose-plugin
printf "Install ok \n"

}

## Proxy docker

proxy_conf(){
printf "Configuration du proxy : \n"
mkdir -p /etc/systemd/system/docker.service.d
 /etc/systemd/system/docker.service.d/http-proxy.conf

echo [Service] > /etc/systemd/system/docker.service.d/http-proxy.conf
echo Environment=\"HTTP_PROXY=http://cache.univ-lille.fr:3128\" >> /etc/systemd/system/docker.service.d/http-proxy.conf
echo Environment=\"HTTPS_PROXY=http://cache.univ-lille.fr:3128\" >> /etc/systemd/system/docker.service.d/http-proxy.conf

systemctl daemon-reload
systemctl restart docker
systemctl show --property=Environment docker

printf "Proxy ok\n"
}

mirror_conf(){
printf "Configuration du mirroir :\n"
echo '
{
  "registry-mirrors": ["http://172.18.48.9:5000"]
}' > /etc/docker/daemon.json


systemctl daemon-reload
systemctl restart docker
printf "Mirroir ok\n"
}

docker_proxy_conf(){
printf "Configuration du proxy Docker :\n"
mkdir ~/.docker/

echo '
{
 "proxies":
 {
   "default":
   {
     "httpProxy": "http://cache.univ-lille.fr:3128",
     "httpsProxy": "http://cache.univ-lille.fr:3128",
     "noProxy": "localhost"
   }
 }
}' > ~/.docker/config.json
systemctl daemon-reload
systemctl restart docker
printf "Docker proxies ok\n"
}

printf "Démarrage de l'installation de docker\n"
install_docker
proxy_conf
mirror_conf
docker_proxy_conf
