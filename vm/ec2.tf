variable "awsprops" {
  type = map(string)
  default = {
    region = "ap-northeast-1"
    # ami        = "ami-04beabd6a4fb6ab6f" # AMAZON LINUX 2
    # ami          = "ami-0fda573abc329ed59" # ECS optimized AMAZON LINUX 2023
    ami          = "ami-07c589821f2b353aa" # UBUNTU 22.04
    prod_itype   = "t2.micro"
    publicip     = true
    keyname      = "senior_thesis"
    secgroupname = "mypotal_vpc_sg"
  }
}

resource "aws_key_pair" "my_key" {
  key_name   = var.awsprops["keyname"]
  public_key = file(var.public_key_path) # 変数を使用してパスを指定
}

resource "aws_instance" "secure_prog" {
  ami                         = var.awsprops["ami"]
  instance_type               = var.awsprops["prod_itype"]
  subnet_id                   = aws_subnet.my_subnet.id
  associate_public_ip_address = var.awsprops["publicip"]
  key_name                    = aws_key_pair.my_key.key_name

  vpc_security_group_ids = [
    aws_security_group.mypotal_vpc_sg.id
  ]

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  user_data = <<-EOF
            #!/bin/bash
            apt-get update -y
            apt-get upgrade -y
            EOF

  root_block_device {
    volume_size = 10
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

output "prod_ssh_command" {
  value = "ssh -i ~/.ssh/myPotal ec2-user@${aws_eip.secure_ec2_eip.public_ip}" # Elastic IPを使用
}

resource "aws_eip" "secure_ec2_eip" {
  domain   = "vpc"
  instance = aws_instance.secure_prog.id
}
