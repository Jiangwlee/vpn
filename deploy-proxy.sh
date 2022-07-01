#!/usr/bin/sh

# Update repository and install docker
sudo apt update
sudo apt-get install -y ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt udpate
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo docker run hello-world
sudo docker pull teddysun/xray
sudo docker images

# Create a default xray config file and start xray
UUID=$(sudo docker run --rm teddysun/xray xray uuid)
echo "Client UUID: $UUID"
sudo mkdir -p /etc/xray
sudo sed "s/CLIENT-UUID/$UUID/" config.json > /etc/xray/config.json
sudo docker run -d -p 8080:8080 --name xray --restart=always -v /etc/xray:/etc/xray teddysun/xray
