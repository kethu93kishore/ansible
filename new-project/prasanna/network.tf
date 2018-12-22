provider "aws" {
  access_key = "AKIAJEX3BTRICHATWV3Q"
  secret_key = "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"
  region     = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.1.0.0/16"
}

resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.34.0.0/20"
}

resource "aws_subnet" "in_secondary_cidr" {
  vpc_id     = "${aws_vpc_ipv4_cidr_block_association.secondary_cidr.vpc_id}"
  cidr_block = "10.34.0.0/25"
  availability_zone = "us-east-1e"
}

resource "aws_subnet" "in_secondary_cidr1" {
  vpc_id     = "${aws_vpc_ipv4_cidr_block_association.secondary_cidr.vpc_id}"
  cidr_block = "10.34.0.126/25"
  availability_zone = "us-east-1f"
}

resource "aws_subnet" "in_secondary_cidr2" {
  vpc_id     = "${aws_vpc_ipv4_cidr_block_association.secondary_cidr.vpc_id}"
  cidr_block = "10.34.1.0/24"
  availability_zone = "us-east-1e"
tags {
    Name = "App"
  }
}

resource "aws_subnet" "in_secondary_cidr3" {
  vpc_id     = "${aws_vpc_ipv4_cidr_block_association.secondary_cidr.vpc_id}"
  cidr_block = "10.34.2.0/24"
  availability_zone = "us-east-1f"
tags {
    Name = "App"
  }
}

resource "aws_subnet" "in_secondary_cidr4" {
  vpc_id     = "${aws_vpc_ipv4_cidr_block_association.secondary_cidr.vpc_id}"
  cidr_block = "10.34.3.0/24"
  availability_zone = "us-east-1e"
tags {
    Name = "DB"
  }
}

resource "aws_subnet" "in_secondary_cidr5" {
  vpc_id     = "${aws_vpc_ipv4_cidr_block_association.secondary_cidr.vpc_id}"
  cidr_block = "10.34.4.0/24"
  availability_zone = "us-east-1f"
tags {
    Name = "DB"
  }
}

resource "aws_subnet" "in_secondary_cidr6" {
  vpc_id     = "${aws_vpc_ipv4_cidr_block_association.secondary_cidr.vpc_id}"
  cidr_block = "10.34.5.0/24"
  availability_zone = "us-east-1e"
tags {
    Name = "EMR"
  }
}

resource "aws_subnet" "in_secondary_cidr7" {
  vpc_id     = "${aws_vpc_ipv4_cidr_block_association.secondary_cidr.vpc_id}"
  cidr_block = "10.34.6.0/24"
  availability_zone = "us-east-1f"
tags {
    Name = "EMR"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc_ipv4_cidr_block_association.secondary_cidr.vpc_id}"

tags {
    Name = "VPC IGW"
  }
}

resource "aws_nat_gateway" "gw" {
  allocation_id = "${aws_eip.lb.id}"
  subnet_id     = "${aws_subnet.in_secondary_cidr1.id}"
}


resource "aws_route_table" "r" {
  vpc_id = "${aws_vpc_ipv4_cidr_block_association.secondary_cidr.vpc_id}"

 route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = "${aws_subnet.in_secondary_cidr.id}"
  route_table_id = "${aws_route_table.r.id}"
}

resource "aws_route_table_association" "a1" {
  subnet_id      = "${aws_subnet.in_secondary_cidr1.id}"
  route_table_id = "${aws_route_table.r.id}"
}

resource "aws_route_table" "p" {
  vpc_id = "${aws_vpc_ipv4_cidr_block_association.secondary_cidr.vpc_id}"

route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.gw.id}"
  }

}

resource "aws_route_table_association" "p1" {
  subnet_id      = "${aws_subnet.in_secondary_cidr2.id}"
  route_table_id = "${aws_route_table.p.id}"
}

resource "aws_route_table_association" "p2" {
  subnet_id      = "${aws_subnet.in_secondary_cidr3.id}"
  route_table_id = "${aws_route_table.p.id}"
}

resource "aws_route_table_association" "p3" {
  subnet_id      = "${aws_subnet.in_secondary_cidr4.id}"
  route_table_id = "${aws_route_table.p.id}"
}

resource "aws_route_table_association" "p4" {
  subnet_id      = "${aws_subnet.in_secondary_cidr5.id}"
  route_table_id = "${aws_route_table.p.id}"
}

resource "aws_route_table_association" "p5" {
  subnet_id      = "${aws_subnet.in_secondary_cidr6.id}"
  route_table_id = "${aws_route_table.p.id}"
}

resource "aws_route_table_association" "p6" {
  subnet_id      = "${aws_subnet.in_secondary_cidr7.id}"
  route_table_id = "${aws_route_table.p.id}"
}




resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc_ipv4_cidr_block_association.secondary_cidr.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip" "lb" {
  vpc      = true
}






























