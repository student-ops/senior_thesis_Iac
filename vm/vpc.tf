variable "instancename" {
  default = "myPotal"
}

variable "public_key_path" {
  default = "~/.ssh/myPotal.pub"
}

resource "aws_vpc" "mypotal_vpc" {
  cidr_block           = "10.0.0.0/24"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.mypotal_vpc.id
  cidr_block              = "10.0.0.0/28"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private-db1" {
  vpc_id            = aws_vpc.mypotal_vpc.id
  cidr_block        = "10.0.0.16/28"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "private-db1"
  }
}

resource "aws_subnet" "private-db2" {
  vpc_id            = aws_vpc.mypotal_vpc.id
  cidr_block        = "10.0.0.32/28"    # 別のCIDRブロックを指定
  availability_zone = "ap-northeast-1c" # 別のAZを指定
  tags = {
    Name = "private-db2"
  }
}


resource "aws_internet_gateway" "my_gw" {
  vpc_id = aws_vpc.mypotal_vpc.id
}

resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.mypotal_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_gw.id
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}
