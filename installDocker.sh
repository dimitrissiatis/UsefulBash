#! /bin/bash

echo "!! PLEASE NOTE THAT DOCKER IS NOT SUPPORTED BY REDHAT BASED OS NEWER THAN VERSION 8 !!"
checkOS=$( cat /etc/redhat-release | wc -l )

if [ $checkOS -eq 1 ]
then
        sudo dnf remove podman buildah -y
        sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
        sudo dnf install -y docker-ce
        sudo systemctl enable --now docker
        if [ $USER != 'root' ]
        then
                sudo usermod -aG docker $USER
        fi
        read -p 'Do you want to install Docker Compose plugin?: y|n ' compvar
        if [ $compvar == 'y' ]
        then
                sudo dnf install docker-compose-plugin -y
        fi
        checkinstall=$( rpm -q docker-ce | wc -l )
        if [ $checkinstall -eq 1 ]
        then
                echo "Successfully installed Docker"
                newgrp docker
        else
                echo "Something went wrong"
        fi
else
        echo "Not a RedHat Family OS"
fi
