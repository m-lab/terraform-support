# Update the apt package index and install packages to allow apt to use a repository over HTTPS
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - 

# Set up the stable repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu `lsb_release -cs` stable" 

sudo apt update 
sudo apt install -y docker-ce

# Add docker group to the list of default groups for all new users. This file
# configures the google-guest-agent, adding the "docker" group to the default
# set of groups all new users are automatically made part of.
# NOTE: The documentation for google-guest-agent indicates that the right file
# should be instance_configs.cfg, but that file appears to be ignored by the
# agent. The file used here is instance_configs.cfg.distro, which contains
# defaults set by the Linux distribution, and appears to work as intended.
sudo sed -i -r '/docker/!s/^groups(.+)$/groups \1,docker/' /etc/default/instance_configs.cfg.distro
sudo systemctl restart google-guest-agent.service
