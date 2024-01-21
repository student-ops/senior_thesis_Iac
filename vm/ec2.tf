variable "awsprops" {
  type = map(string)
  default = {
    region = "ap-northeast-1"
    # ami        = "ami-04beabd6a4fb6ab6f" # AMAZON LINUX 2
    # ami          = "ami-0fda573abc329ed59" # ECS optimized AMAZON LINUX 2023
    ami = "ami-07c589821f2b353aa" # UBUNTU 22.04 for x86_64
    # ami          = "ami-01044a7484292fef7" # UBUNTU 22.04 for aarch
    prod_itype   = "t3.small"
    publicip     = true
    keyname      = "senior_thesis"
    secgroupname = "mypotal_vpc_sg"
  }
}

resource "aws_key_pair" "my_key" {
  key_name   = var.awsprops["keyname"]
  public_key = file(var.public_key_path) # 変数を使用してパスを指定
}

locals {
  user_data = <<-EOF
  #!/bin/bash
  apt-get update -y
  apt-get upgrade -y
  EOF
}

resource "aws_instance" "k3s_server" {
  ami                         = var.awsprops["ami"]
  instance_type               = "t3.medium"
  subnet_id                   = aws_subnet.my_subnet.id
  associate_public_ip_address = var.awsprops["publicip"]
  key_name                    = aws_key_pair.my_key.key_name

  vpc_security_group_ids = [
    aws_security_group.mypotal_vpc_sg.id
  ]

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  user_data = local.user_data
  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }

  tags = {
    Name        = var.instancename
    Environment = "DEV"
    OS          = "UBUNTU"
    Managed     = "IAC"
  }

  depends_on = [aws_security_group.mypotal_vpc_sg]
}

resource "aws_instance" "k3s_edge_worker" {
  ami                         = var.awsprops["ami"]
  instance_type               = var.awsprops["prod_itype"]
  subnet_id                   = aws_subnet.my_subnet.id
  associate_public_ip_address = var.awsprops["publicip"]
  key_name                    = aws_key_pair.my_key.key_name

  vpc_security_group_ids = [
    aws_security_group.mypotal_vpc_sg.id
  ]

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  user_data = local.user_data
  root_block_device {
    volume_size = 10
    volume_type = "gp2"
  }

  tags = {
    Name        = "k3s_edge_worker"
    Environment = "DEV"
    OS          = "UBUNTU"
    Managed     = "IAC"
  }

  depends_on = [aws_security_group.mypotal_vpc_sg]
}

resource "aws_instance" "k3s_central_worker" {
  ami                         = var.awsprops["ami"]
  instance_type               = var.awsprops["prod_itype"]
  subnet_id                   = aws_subnet.my_subnet.id
  associate_public_ip_address = var.awsprops["publicip"]
  key_name                    = aws_key_pair.my_key.key_name

  vpc_security_group_ids = [
    aws_security_group.mypotal_vpc_sg.id
  ]

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  user_data = local.user_data
  root_block_device {
    volume_size = 10
    volume_type = "gp2"
  }

  tags = {
    Name        = "k3s_central_worker"
    Environment = "DEV"
    OS          = "UBUNTU"
    Managed     = "IAC"
  }

  depends_on = [aws_security_group.mypotal_vpc_sg]
}

output "server_ssh_command" {
  value = "ssh -i ~/.ssh/myPotal ubuntu@${aws_eip.k3s_server.public_ip}"
}

output "edge_worker_ssh_command" {
  value = "ssh -i ~/.ssh/myPotal ubuntu@${aws_eip.k3s_edge_worker.public_ip}"
}

output "central_worker_ssh_command" {
  value = "ssh -i ~/.ssh/myPotal ubuntu@${aws_eip.k3s_central_worker.public_ip}"
}

output "export_ip" {
  value = "export IP_k3s_main=${aws_eip.k3s_server.public_ip}\nexport IP_k3s_edge_worker=${aws_eip.k3s_edge_worker.public_ip}\nexport IP_k3s_central_worker=${aws_eip.k3s_central_worker.public_ip}"
}

resource "aws_eip" "k3s_server" {
  domain   = "vpc"
  instance = aws_instance.k3s_server.id
}

resource "aws_eip" "k3s_edge_worker" {
  domain   = "vpc"
  instance = aws_instance.k3s_edge_worker.id
}

resource "aws_eip" "k3s_central_worker" {
  domain   = "vpc"
  instance = aws_instance.k3s_central_worker.id
}

