variable "region" {
    default = "us-east-2"
}

data "aws_availability_zones" "available" {}


module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "3.2.0"
    name = "lab-vpc"
    cidr = "10.0.0.0/16"
    azs = data.aws_availability_zones.available.names
    private_subnets = ["10.0.1.0/28","10.0.2.0/28"]
    public_subnets =  ["10.0.3.0/28","10.0.4.0/28"]
    enable_nat_gateway = true
    single_nat_gateway = true
    enable_dns_hostnames = true
}

resource "aws_security_group" "network-traffic" {
    name_prefix = "network-traffic"
    vpc_id = module.vpc.vpc_id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port        = 80
        to_port          = 80
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }
}