#!/bin/bash

set -x

# Install necessary dependencies
sudo apt-get update -y

# Setup sudo to allow no-password sudo for "devops" group and adding "$USERNAME" user
sudo groupadd -r devops
sudo useradd -m -s /bin/bash $USERNAME
sudo usermod -a -G devops $USERNAME
sudo cp /etc/sudoers /etc/sudoers.orig
echo "$USERNAME  ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$USERNAME

# Installing SSH key
sudo mkdir -p /home/$USERNAME/.ssh
sudo chmod 700 /home/$USERNAME/.ssh
sudo cp /tmp/tf-packer.pub /home/$USERNAME/.ssh/authorized_keys
sudo chmod 600 /home/$USERNAME/.ssh/authorized_keys
sudo chown -R $USERNAME /home/$USERNAME/.ssh
sudo usermod --shell /bin/bash $USERNAME

#install ssm agent
sudo snap install amazon-ssm-agent --classic
sudo snap list amazon-ssm-agent 
sudo snap start amazon-ssm-agent
sudo snap services amazon-ssm-agent

