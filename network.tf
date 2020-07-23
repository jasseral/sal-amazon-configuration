data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block = "${var.network}.0.0/16"

  tags = {
    Name = "sal-${var.env}"
  }

  enable_dns_hostnames = true
}

resource "aws_subnet" "private" {
  count = 1
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "sal-${var.env}-private-${count.index}"
  }
}

resource "aws_subnet" "public" {
  count = 2
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, 2 + count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id = aws_vpc.main.id
  map_public_ip_on_launch = true

  tags = {
    Name = "sal-${var.env}-public-${count.index}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "sal-${var.env}"
  }

}

resource "aws_route" "internet_access" {
  route_table_id = aws_vpc.main.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}

