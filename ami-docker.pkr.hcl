packer {
  required_plugins {
    docker = {
      version = ">= 1.0.8"
      source  = "github.com/hashicorp/docker"
    }
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
    ansible = {
      version = "~> 1"
      source = "github.com/hashicorp/ansible"
    }
  }
}

variable "docker_image" {
  type    = string
  default = "ubuntu:jammy"
}

variable "msg" {
  type = string
  default = "I am from the var"
}

variable "focal_msg" {
  type = string
  default = "for the ubuntu-focal var"
}

variable "docker_username" {
  type = string
  default = "" 
}

variable "docker_password" {
  type = string
  default = "" 
}

# Commented out AWS-related variables
# variable "aws_region" {
#   type    = string
#   default = "us-west-2"
# }

# variable "source_ami" {
#   type    = string
#   default = "ami-12345678"  # Replace with your base AMI
# }

# Docker sources
source "docker" "ubuntu" {
  image  = var.docker_image
  commit = true
}

source "docker" "ubuntu-focal" {
  image  = "ubuntu:focal"
  commit = true
}

# Commented out AWS AMI source
# source "amazon-ebs" "my-ami" {
#   region           = var.aws_region
#   source_ami       = var.source_ami
#   instance_type    = "t2.micro"
#   ssh_username     = "ubuntu"  # Adjust based on your AMI's default user
#   ami_name         = "my-custom-ami-{{timestamp}}"
#   ami_description  = "My custom AMI with NGINX server"
#   tags = {
#     Name = "MyCustomAMI"
#   }

#   # File provisioner to upload a local HTML page for AMI
#   provisioner "file" {
#     source      = "local_index.html"  # Local HTML file for AMI
#     destination = "/tmp/index.html"
#   }

#   # Ansible provisioner to install NGINX and copy HTML file for AMI
#   provisioner "ansible" {
#     playbook_file = "ami_nginx_setup.yml"  # Ansible playbook for NGINX installation and setup
#   }
# }

build {
  name    = "learn-packer"
  sources = [
    "source.docker.ubuntu",
    "source.docker.ubuntu-focal",
  ]

  provisioner "shell" {
    inline = [
      "apt-get update",
      "apt-get install -y apt-utils sudo python3 python3-pip",
    ]
  }


  # File provisioner for Docker to upload local HTML file
  provisioner "file" {
    source      = "./docker_index.html"  # Local HTML file for Docker
    destination = "/tmp/docker_index.html"
  }

  # Ansible provisioner for Docker to install NGINX and copy HTML file
  provisioner "ansible" {
      user = "ubuntu"
      playbook_file = "./docker-nginx-setup.yml"  # Ansible playbook for Docker NGINX installation and setup
  }

  post-processors {
    post-processor "docker-tag" {
      repository = "muzakkirsaifi/ubuntu"
      tags       = ["ubuntu-jammy-ansible"]
      only       = ["docker.ubuntu"]
    }

    post-processor "docker-tag" {
      repository = "muzakkirsaifi/ubuntu_focal"
      tags       = ["ubuntu-focal-ansible"]
      only       = ["docker.ubuntu-focal"]
    }

    post-processor "docker-push" {
      login          = true
      login_username = var.docker_username
      login_password = var.docker_password
    }
  }
}


























# packer {
#   required_plugins {
#     docker = {
#       version = ">= 1.0.8"
#       source  = "github.com/hashicorp/docker"
#     }
#     amazon = {
#       version = ">= 1.2.8"
#       source  = "github.com/hashicorp/amazon"
#     }
#   }
# }

# variable "docker_image" {
#   type    = string
#   default = "ubuntu:jammy"
# }

# variable "msg" {
#   type = string
#   default = "I am from the var"
# }

# variable "focal_msg" {
#   type = string
#   default = "for the ubuntu-focal var"
# }

# variable "docker_username" {
#   type = string
#   default = "" 
# }

# variable "docker_password" {
#   type = string
#   default = "" 
# }

# variable "aws_region" {
#   type    = string
#   default = "us-west-2"
# }

# variable "source_ami" {
#   type    = string
#   default = "ami-12345678"  # Replace with your base AMI
# }

# # Docker sources
# source "docker" "ubuntu" {
#   image  = var.docker_image
#   commit = true
# }

# source "docker" "ubuntu-focal" {
#   image  = "ubuntu:focal"
#   commit = true
# }

# # AWS AMI source
# source "amazon-ebs" "my-ami" {
#   region           = var.aws_region
#   source_ami       = var.source_ami
#   instance_type    = "t2.micro"
#   ssh_username     = "ubuntu"  # Adjust based on your AMI's default user
#   ami_name         = "my-custom-ami-{{timestamp}}"
#   ami_description  = "My custom AMI with NGINX server"
#   tags = {
#     Name = "MyCustomAMI"
#   }

#   # File provisioner to upload a local HTML page for AMI
#   provisioner "file" {
#     source      = "local_index.html"  # Local HTML file for AMI
#     destination = "/tmp/index.html"
#   }

#   # Ansible provisioner to install NGINX and copy HTML file for AMI
#   provisioner "ansible" {
#     playbook_file = "ami_nginx_setup.yml"  # Ansible playbook for NGINX installation and setup
#   }
# }

# build {
#   name    = "learn-packer"
#   sources = [
#     "source.docker.ubuntu",
#     "source.docker.ubuntu-focal",
#   ]

#   # File provisioner for Docker to upload local HTML file
#   provisioner "file" {
#     source      = "docker_index.html"  # Local HTML file for Docker
#     destination = "/tmp/docker_index.html"
#   }

#   # Ansible provisioner for Docker to install NGINX and copy HTML file
#   provisioner "ansible" {
#     playbook_file = "docker_nginx_setup.yml"  # Ansible playbook for Docker NGINX installation and setup
#   }

#   post-processors {
#     post-processor "docker-tag" {
#       repository = "muzakkirsaifi/ubuntu"
#       tags       = ["ubuntu-jammy"]
#       only       = ["docker.ubuntu"]
#     }

#     post-processor "docker-tag" {
#       repository = "muzakkirsaifi/ubuntu_focal"
#       tags       = ["ubuntu-focal"]
#       only       = ["docker.ubuntu-focal"]
#     }

#     post-processor "docker-push" {
#       login          = true
#       login_username = var.docker_username
#       login_password = var.docker_password
#     }
#   }
# }
