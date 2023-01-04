#!/bin/bash

set -x

# Install necessary dependencies
sudo apt-get update -y

#install ansible
sudo apt-add-repository ppa:ansible/ansible
sudo apt update
sudo apt install ansible -y
ansible-galaxy collection install amazon.aws
sudo apt-get install python3 -y
sudo apt-get install python3-pip -y
sudo pip3 install boto3
sudo mv /tmp/dynamic-inventory.aws_ec2.yaml /etc/ansible/dynamic-inventory.aws_ec2.yaml

sudo -H -i -u ansible-user -- env bash << EOF
set -x
whoami
echo ~$USERNAME

cd /home/$USERNAME
#Install go (https://go.dev/doc/install)
wget https://golang.org/dl/go1.19.4.linux-amd64.tar.gz
mkdir -p /home/$USERNAME/go
rm -rf /usr/local/go && tar -C /home/$USERNAME/go -xzf go1.19.4.linux-amd64.tar.gz
export GOROOT=/usr/lib/go
export GOPATH=/home/$USERNAME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
rm -rf https://golang.org/dl/go1.19.4.linux-amd64.tar.gz
#The cfssl and cfssljson command line utilities will be used to provision a PKI Infrastructure and generate TLS certificates.
curl -L https://github.com/cloudflare/cfssl/releases/download/v1.5.0/cfssl_1.5.0_linux_amd64 -o cfssl
chmod +x cfssl
curl -L https://github.com/cloudflare/cfssl/releases/download/v1.5.0/cfssljson_1.5.0_linux_amd64 -o cfssljson
chmod +x cfssljson
curl -L https://github.com/cloudflare/cfssl/releases/download/v1.5.0/cfssl-certinfo_1.5.0_linux_amd64 -o cfssl-certinfo
chmod +x cfssl-certinfo
mkdir -p ~/.local/bin
export PATH=$PATH:~/.local/bin
sudo mv cfssl cfssljson cfssl-certinfo ~/.local/bin
cfssl version || (echo "cfssl command not found" && exit 1)
# install kubectl
wget https://storage.googleapis.com/kubernetes-release/release/v1.21.0/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl ~/.local/bin/
kubectl version --client || (echo "kubectl command not found" && exit 1)
EOF
