#!/bin/bash

echo -e "\n[Installing HomeBank]"
sudo apt-add-repository -y ppa:mdoyen/homebank

echo -e "\n[Installing Java]"
sudo apt-add-repository -y ppa:webupd8team/java

echo -e "\n[Installing Wine]"
sudo apt-add-repository -y ppa:ubuntu-wine/ppa

echo -e "\n[Installing PHP 5.6]"
sudo apt-add-repository -y ppa:ondrej/php

echo -e "\n[Installing Spotify]"
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

echo -e "\n[Installing VirtualBox]"
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
echo "deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list

echo -e "\n[Installing Chrome]"
wget -q https://dl-ssl.google.com/linux/linux_signing_key.pub -O- | sudo apt-key add - 
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google.list

echo -e "\n[Installing DropBox]"
sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 5044912E
echo "deb http://linux.dropbox.com/ubuntu/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/dropbox.list

sudo apt-get update


