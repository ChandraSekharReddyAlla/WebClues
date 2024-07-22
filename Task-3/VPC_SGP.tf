provider "aws" {
  region     = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
 
  tags = {
    Name = "My_Vpc"
  }
}

resource "aws_subnet" "tf-sub_pub" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.10.0/24"

  tags = {
    Name = "pub_sb"
  }
}

resource "aws_subnet" "tf-sub_prv" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.9.0/24"

  tags = {
    Name = "prv_sb"
  }

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "IGW"
  }
}

resource "aws_eip" "ip" {
  vpc      = true
}

resource "aws_nat_gateway" "natgateway" {
  allocation_id = aws_eip.ip.id
  subnet_id     = aws_subnet.tf-sub_pub.id

  tags = {
    name = "prod_nategatway"
  }
  depends_on = [aws_eip.ip]
}

resource "aws_route_table" "pbr" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "pub_route"
  }
}

resource "aws_route_table" "pvrr" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgateway.id
  }

  tags = {
    Name = "prv_toute"
  }
}
resource "aws_security_group" "main" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "security_group"
  }
}

resource "aws_instance" "pbserver" {
  ami           = "ami-0574da719dca65348"
  instance_type = "t2.micro"
  subnet_id  = "subnet-0e6138836b7a702f3"

  tags = {
    Name = "terra-server"
  }
}

resource "aws_instance" "prvserver" {
  ami           = "ami-0574da719dca65348"
  instance_type = "t2.micro"
  subnet_id  = "subnet-0e6138836b7a702f3"

  tags = {
    Name = "terra-server123"
  }
}
