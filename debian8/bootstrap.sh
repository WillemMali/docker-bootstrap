#!/bin/sh -eu
# ensure we don't have old docker versions installed
apt-get purge lxc-docker* || true
apt-get purge docker.io* || true

# ensure we can use https apt sources
apt-get update
apt-get install apt-transport-https ca-certificates

# trust docker apt signing key
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

# install docker source
sudo cp docker.list /etc/apt/sources.list

# install docker-engine
apt-get update
apt-get install docker-engine

# start docker service
systemctl start docker

# check if docker is working
docker run hello-world



# add docker group (for non-root access)
groupadd docker || true

while true; do
    read -p "Do you want to add a user to the docker group for non-root docker access? (Y/N) " yn
    case $yn in
        [Yy]* )
            read -p "Username (must exist): " user
            if id "$user" >/dev/null 2>&1; then
                gpasswd -a $user docker
            else
                echo "User '$user' does not exist!"
            fi;;
        [Nn]* ) exit;;
        * ) echo "Y/N";;
    esac
done

systemctl restart docker
