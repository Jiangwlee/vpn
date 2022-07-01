#!/usr/bin/sh

OSID=$(grep -o '^ID=.*' /etc/os-release | sed -n "s/ID=\(.*\)/\1/p")
LINE="----------------------------------------------------"
echo "The OS is: $(uname -a)"

# Update repository and install docker
sudo rm /etc/apt/sources.list.d/docker.list
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings

# Install Docker
echo $LINE
echo "Start installing Docker ..."
case "$OSID" in
	"ubuntu") echo "Install Docker on Ubuntu"
		sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
		echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
		;;
	"debian") echo "Install Docker on Debian"
                sudo curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
                echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
		;;
	*) echo "Unknown OS Type: $OSID"
	   exit 1
	   ;;
esac	   

sudo apt update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo docker run --rm hello-world
echo $LINE
echo  "\nStart pulling Xray image..."
sudo docker pull teddysun/xray
sudo docker images

# Create a default xray config file and start xray
UUID=$(sudo docker run --rm teddysun/xray xray uuid)
echo "Client UUID: $UUID"
sudo mkdir -p /etc/xray
sed "s/CLIENT-UUID/$UUID/" ./xray/config.json > newconfig.json
sudo mv newconfig.json /etc/xray/config.json
sudo docker run -d -p 8080:8080 --name xray --restart=always -v /etc/xray:/etc/xray teddysun/xray
