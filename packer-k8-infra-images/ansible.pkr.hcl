packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}
variable "region" {
  type    = string
  default = "eu-west-1"
}
source "amazon-ebs" "k8-node" {
  ami_name = "ansible-packer-ami"
  instance_type = "t2.micro"
  region        = var.region
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners = ["amazon"]
  } 
  ssh_username = "ubuntu"
}

build {
  sources = ["source.amazon-ebs.k8-node"]

  provisioner "file" {
    source      = "../tf-packer.pub"
    destination = "/tmp/tf-packer.pub"
  }
  provisioner "file" {
    source = "../ansible-scripts/dynamic-inventory.yml"
    destination = "/tmp/dynamic-inventory.aws_ec2.yaml"
  }
  provisioner "shell" {
    environment_vars = [
    "USERNAME=ansible-user"
  ]
    script = "./scripts/base-bootstrap.sh"
  }
  provisioner "shell" {
    environment_vars = [
    "USERNAME=ansible-user"
  ]
    script = "./scripts/ansible-bootstrap.sh"
  }
}