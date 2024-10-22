packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
    ansible = {
      version = "~> 1"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "source_ami" {
  type    = string
  default = "ami-0ea3c35c5c3284d82" # Replace with your base AMI
}

variable "ami_name" {
  type    = string
  default = "learn-packer-linux-aws"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ssh_username" {
  type    = string
  default = "ubuntu"
}

source "amazon-ebs" "ubuntu" {
  ami_name      = var.ami_name
  instance_type = var.instance_type
  region        = var.aws_region
  source_ami    = var.source_ami
  ssh_username  = var.ssh_username
}

build {
  name = "learn-packer"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
    ]
  }

  provisioner "file" {
    source      = "./docker_index.html" # Local HTML file for Docker
    destination = "/tmp/docker_index.html"
  }

  provisioner "ansible" {
    playbook_file = "./docker-nginx-setup.yml" # Ansible playbook for further configuration
  }

}
























# packer {
#   required_plugins {
#     amazon = {
#       version = ">= 1.2.8"
#       source  = "github.com/hashicorp/amazon"
#     }
#     ansible = {
#       version = "~> 1"
#       source = "github.com/hashicorp/ansible"
#     }
#   }
# }

# variable "aws_region" {
#   type    = string
#   default = "us-east-2"
# }

# variable "source_ami" {
#   type    = string
#   default = "ami-0ea3c35c5c3284d82"  # Replace with your base AMI
# }
# variable "ami_name" {
#   type    = string
#   default = "learn-packer-linux-aws"
# }

# variable "instance_type" {
#   type    = string
#   default = "t2.micro"
# }
# variable "ssh_username" {
#   type    = string
#   default = "ubuntu"
# }
# source "amazon-ebs" "ubuntu" {
#   ami_name      = var.ami_name
#   instance_type = var.instance_type
#   region        = var.aws_region
#   source_ami    = var.source_ami
#   ssh_username  = var.ssh_username
# }


# build {
#   name    = "learn-packer"
#   sources = [
#     "source.amazon-ebs.ubuntu"
#   ]
# }
