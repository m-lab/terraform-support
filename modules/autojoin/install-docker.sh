# Update the apt package index and install packages to allow apt to use a repository over HTTPS
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - 

# Set up the stable repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu `lsb_release -cs` stable" 

sudo apt update 
sudo apt install -y docker-ce

# Add docker group to the list of default groups for all new users.
sudo echo "[Accounts]
groups  = ubuntu,adm,dialout,cdrom,floppy,audio,dip,video,plugdev,netdev,lxd,docker" > /etc/default/instance_configs.cfg
sudo systemctl restart google-guest-agent.service

# Add every existing interactive user to the docker group. This is needed
# because this script appears to run after the google-guest-agent is started,
# and some users already exist at this point.
for ID in $(cat /etc/passwd | grep /home | cut -d ':' -f1); do (sudo adduser $ID docker); done