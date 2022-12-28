#!/bin/bash

set -x

# Install necessary dependencies
sudo apt-get update -y

# Setup sudo to allow no-password sudo for "hashicorp" group and adding "terraform" user
sudo groupadd -r hashicorp
sudo useradd -m -s /bin/bash terraform
sudo usermod -a -G hashicorp terraform
sudo cp /etc/sudoers /etc/sudoers.orig
echo "terraform  ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/terraform

# Installing SSH key
sudo mkdir -p /home/terraform/.ssh
sudo chmod 700 /home/terraform/.ssh
sudo cp /tmp/tf-packer.pub /home/terraform/.ssh/authorized_keys
sudo chmod 600 /home/terraform/.ssh/authorized_keys
sudo chown -R terraform /home/terraform/.ssh
sudo usermod --shell /bin/bash terraform

sudo -H -i -u terraform -- env bash << EOF
whoami
echo ~terraform

cd /home/terraform
#Install go (https://go.dev/doc/install)
wget https://golang.org/dl/go1.16.5.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.19.4.linux-amd64.tar.gz
export GOROOT=/usr/lib/go
export GOPATH=/usr/local/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
rm -rf https://golang.org/dl/go1.16.5.linux-amd64.tar.gz
#The cfssl and cfssljson command line utilities will be used to provision a PKI Infrastructure and generate TLS certificates.
curl -L https://github.com/cloudflare/cfssl/releases/download/v1.5.0/cfssl_1.5.0_linux_amd64 -o cfssl
chmod +x cfssl
curl -L https://github.com/cloudflare/cfssl/releases/download/v1.5.0/cfssljson_1.5.0_linux_amd64 -o cfssljson
chmod +x cfssljson
curl -L https://github.com/cloudflare/cfssl/releases/download/v1.5.0/cfssl-certinfo_1.5.0_linux_amd64 -o cfssl-certinfo
chmod +x cfssl-certinfo
sudo mv cfssl cfssljson cfssl-certinfo /usr/local/bin
cfssl version || echo "cfssl command not found" && exit 1
# install kubectl
wget https://storage.googleapis.com/kubernetes-release/release/v1.21.0/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version --client || echo "kubectl command not found" && exit 1
#install ssm agent
sudo snap install amazon-ssm-agent --classic
sudo snap list amazon-ssm-agent || sudo snap start amazon-ssm-agent
sudo snap services amazon-ssm-agent || echo "ssm agent not running" && exit 1
EOF