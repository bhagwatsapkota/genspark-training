

resource "aws_vpc" "vpc-lab" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_hostnames = true

    tags = {
        Name = "vpc-lab"
    }
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "newSubnet-1" {
    vpc_id = aws_vpc.vpc-lab.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true
    availability_zone = data.aws_availability_zones.available.names

    tags = {
        Name = "newSubnet-1"
    }
}

resource "aws_subnet" "newSubnet-2" {
    vpc_id = aws_vpc.vpc-lab.id
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = true
    availability_zone = data.aws_availability_zones.available.names


    tags = {
        Name = "newSubnet-2"
    }
}

resource "aws_route_table" "route-lab" {
    vpc_id = aws_vpc.vpc-lab.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.lab-gateway.id
    }

    tags = {
        Name = "route-lab"
    }

}

resource "aws_main_route_table_association" "tableAssign" {
  vpc_id         = aws_vpc.vpc-lab.id
  route_table_id = aws_route_table.route-lab.id
}


resource "aws_internet_gateway" "lab-gateway" {
    vpc_id = aws_vpc.vpc-lab.id

    tags = {
        Name = "lab-gateway"
    }
}

resource "aws_route_table_association" "subnetAssociation-1" {
    subnet_id = aws_subnet.newSubnet-1.id
    route_table_id = aws_route_table.route-lab.id
}

resource "aws_route_table_association" "subnetAssociation-2" {
    subnet_id = aws_subnet.newSubnet-2.id
    route_table_id = aws_route_table.route-lab.id
}


resource "aws_security_group" "allow_traffic" {
  name        = "allow_traffic"
  description = "Allow TCP inbound traffic"
  vpc_id      = aws_vpc.vpc-lab.id

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