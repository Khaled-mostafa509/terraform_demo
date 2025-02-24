resource "aws_instance" "demo" {
  ami           = var.ami-data
  instance_type = var.ec2-type
  tags = {
    name = "demo"
  }

  key_name               = aws_key_pair.demo_keypair.key_name
  vpc_security_group_ids = [aws_security_group.demoSG.id]
  subnet_id = aws_subnet.demo_subnet.id
  depends_on = [ aws_route_table.demo_RT]

}
resource "aws_security_group" "demoSG" {
  name        = "allows_ssh"
  description = "allow inbound ssh and all outbound "
  vpc_id = aws_vpc.demo_vpc.id
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    name = "demoSG"
  }
  
}
resource "tls_private_key" "demo_key" {
  algorithm = "RSA"
  rsa_bits  = 2048

}

resource "aws_key_pair" "demo_keypair" {
  key_name   = "demo_keypair"
  public_key = tls_private_key.demo_key.public_key_openssh

}
resource "local_file" "private_key" {
  content  = tls_private_key.demo_key.private_key_pem
  filename = "/home/khaled/demo_keypair.pem"

}

resource "aws_vpc" "demo_vpc" {
    cidr_block = var.aws-vpc
    instance_tenancy = "default"
    tags = {
      name = "main"
    }
  
}
resource "aws_subnet" "demo_subnet" {
    vpc_id = aws_vpc.demo_vpc.id
    cidr_block = var.aws-subnet
    map_public_ip_on_launch = true
  
}

resource "aws_internet_gateway" "demo_IGW" {
    vpc_id = aws_vpc.demo_vpc.id
    tags = {
      name = "demo_IGW"
    }
  
}

resource "aws_route_table" "demo_RT" {
    vpc_id = aws_vpc.demo_vpc.id
    route  {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.demo_IGW.id
    }
    tags = {
      name = "demo_RT"
    }
  
}
resource "aws_route_table_association" "demo_route_assoc" {
    subnet_id = aws_subnet.demo_subnet.id
    route_table_id = aws_route_table.demo_RT.id
  
}