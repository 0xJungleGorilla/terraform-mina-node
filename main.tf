provider "aws" {
  region = "us-east-1"
  # access_key = "asdf"
  # secret_key = "jkl"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "terraform-testing-admin-id_rsa" {
  key_name   = var.sshKeyName
  public_key = var.sshKeyPubKey
}

resource "aws_instance" "minaInstance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.minaInstanceType
  key_name               = var.sshKeyName
  vpc_security_group_ids = [aws_security_group.main.id]
  tags = {
    Name = "Mina Node"
  }
  provisioner "file" {
    source      = ".mina-env"
    destination = "/home/ubuntu/.mina-env"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.sshKeyName)
      host        = aws_instance.minaInstance.public_ip
    }
  }
  provisioner "remote-exec" {
    inline = [
      "mkdir /home/ubuntu/keys",
      "chmod 700 /home/ubuntu/keys",
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.sshKeyName)
      host        = aws_instance.minaInstance.public_ip
    }
  }
  provisioner "file" {
    source      = "keys/my-wallet"
    destination = "/home/ubuntu/keys/my-wallet"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.sshKeyName)
      host        = aws_instance.minaInstance.public_ip
    }
  }
  provisioner "file" {
    source      = "keys/my-wallet.pub"
    destination = "/home/ubuntu/keys/my-wallet.pub"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.sshKeyName)
      host        = aws_instance.minaInstance.public_ip
    }
  }
  provisioner "file" {
    source      = "setup-mina.sh"
    destination = "/home/ubuntu/setup-mina.sh"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.sshKeyName)
      host        = aws_instance.minaInstance.public_ip
    }
  }
  provisioner "file" {
    source      = "setup-apache2.sh"
    destination = "/home/ubuntu/setup-apache2.sh"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.sshKeyName)
      host        = aws_instance.minaInstance.public_ip
    }
  }
  provisioner "remote-exec" {
    inline = [
      "chmod 600 /home/ubuntu/keys/my-wallet*",
      "chmod +x /home/ubuntu/setup-mina.sh",
      "sh -c /home/ubuntu/setup-mina.sh",
      "chmod +x /home/ubuntu/setup-apache2.sh",
      "sh -c /home/ubuntu/setup-apache2.sh",
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.sshKeyName)
      host        = aws_instance.minaInstance.public_ip
    }
  }
}

resource "aws_security_group" "main" {
  egress = [
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
  ingress = [
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 22
    },
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 80
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 80
    },
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 8302
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 8302
    },
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 9180
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 9180
    },
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 3085
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 3085
    }
  ]
}
