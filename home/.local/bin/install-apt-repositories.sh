#!/bin/bash

# HomeBank
sudo apt-add-repository -y ppa:mdoyen/homebank

# Spotify
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list

# Virtualbox
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
echo "deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list

# Oracle Java
sudo apt-add-repository -y ppa:webupd8team/java

# Wine 
sudo apt-add-repository -y ppa:ubuntu-wine/ppa

