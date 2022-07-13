

resource "aws_vpc" "newVPC" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_hostnames = true

    tags = {
        Name = "newVPC"
    }
}

resource "aws_subnet" "pubSubnet" {
    vpc_id = aws_vpc.newVPC.id
    cidr_block = "10.0.1.0/24"

    tags = {
        Name = "pubSubnet"
    }
}

resource "aws_route_table" "pubRoute" {
    vpc_id = aws_vpc.newVPC.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.newGateway.id
    }

    tags = {
        Name = "pubRoute"
    }

}

resource "aws_main_route_table_association" "tableAssign" {
  vpc_id         = aws_vpc.newVPC.id
  route_table_id = aws_route_table.pubRoute.id
}


resource "aws_internet_gateway" "newGateway" {
    vpc_id = aws_vpc.newVPC.id

    tags = {
        Name = "newGateway"
    }
}

resource "aws_route_table_association" "subnetAssociation" {
    subnet_id = aws_subnet.pubSubnet.id
    route_table_id = aws_route_table.pubRoute.id
}


resource "aws_security_group" "allow_traffic" {
  name        = "allow_traffic"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.newVPC.id

  ingress {
    description      = "Inbound rule"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

   ingress {
    description      = "Inbound rule"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

 ingress {
    description      = "Inbound rule"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  

  tags = {
    Name = "allow_traffic"
  }
}

resource "aws_instance" "ec2_server" {
    ami = data.aws_ami.ec2_server.id
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.allow_traffic.id]
    key_name = "sressh"
    subnet_id = aws_subnet.pubSubnet.id
    associate_public_ip_address = true
}