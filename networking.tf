locals {
  ingress_routes = [
    {
      from     = 443,
      to       = 443,
      protocol = "tcp"
    },
    {
      from     = 80,
      to       = 80,
      protocol = "tcp"
    },
    {
      from     = 22,
      to       = 22,
      protocol = "tcp"
    },
  ]
}

resource "aws_vpc" "pds_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "pds_subnet" {
  availability_zone       = var.zone
  vpc_id                  = aws_vpc.pds_vpc.id
  map_public_ip_on_launch = "true" # This is what makes it a public subnet
  cidr_block              = "10.0.1.0/24"
}

resource "aws_security_group" "pds_sg" {
  name        = "pds_sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.pds_vpc.id

  tags = {
    Name = "PDS Security Group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ingress" {
  count             = length(local.ingress_routes)
  security_group_id = aws_security_group.pds_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = local.ingress_routes[count.index].from
  ip_protocol       = local.ingress_routes[count.index].protocol
  to_port           = local.ingress_routes[count.index].to
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.pds_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.pds_vpc.id

  tags = {
    Name = "PDS VPC IG"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.pds_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public Route Table"
  }
}

resource "aws_route_table_association" "public_subnet_asso" {
  subnet_id      = aws_subnet.pds_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

## Elastic IP for NAT Gateway
resource "aws_eip" "pds-public-eip" {
  domain   = "vpc"
  instance = aws_instance.pds.id
  tags = {
    Name = "pds-public-eip"
  }
}
