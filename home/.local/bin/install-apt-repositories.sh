#!/bin/bash

echo "Adding APT repositories:"

echo "- HomeBank"
sudo apt-add-repository -y ppa:mdoyen/homebank

echo "- Java"
sudo apt-add-repository -y ppa:webupd8team/java

echo "- Wine"
sudo apt-add-repository -y ppa:ubuntu-wine/ppa

echo "- PHP 5.6"
sudo apt-add-repository -y ppa:ondrej/php

echo "- Spotify"
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

echo "- VirtualBox"
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
echo "deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list

echo "- Chrome"
wget -q https://dl-ssl.google.com/linux/linux_signing_key.pub -O- | sudo apt-key add - 
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google.list

echo "- DropBox"
sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 5044912E
echo "deb http://linux.dropbox.com/ubuntu/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/dropbox.list

echo "- Docker"
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-$(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/docker.list

echo "- Haskell Stack"
wget -q -O- https://s3.amazonaws.com/download.fpcomplete.com/ubuntu/fpco.key | sudo apt-key add -
echo "deb http://download.fpcomplete.com/ubuntu/$(lsb_release -sc) stable main" | sudo tee /etc/apt/sources.list.d/fpco.list

sudo apt-get update

