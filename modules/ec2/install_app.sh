#!/bin/bash 
sudo apt update && sudo apt upgrade -y 
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https 
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg 
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list 
sudo apt update 
sudo apt install caddy -y 
systemctl enable caddy && systemctl start caddy 
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - &&\ 
sudo apt-get install -y nodejs 
sudo apt install supervisor -y 