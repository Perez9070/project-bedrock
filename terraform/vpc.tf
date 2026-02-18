resource "aws_vpc" "project_bedrock" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = "project-bedrock-vpc"
    Project = "Bedrock"
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.azs)
  vpc_id                  = aws_vpc.project_bedrock.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name    = "project-bedrock-public-${count.index}"
    Project = "Bedrock"
    Tier    = "public"
  }
}

resource "aws_subnet" "private" {
  count                   = length(var.azs)
  vpc_id                  = aws_vpc.project_bedrock.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index + length(var.azs))
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name    = "project-bedrock-private-${count.index}"
    Project = "Bedrock"
    Tier    = "private"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.project_bedrock.id
  tags = {
    Name    = "project-bedrock-igw"
    Project = "Bedrock"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.project_bedrock.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name    = "project-bedrock-public-rt"
    Project = "Bedrock"
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name    = "project-bedrock-nat-eip"
    Project = "Bedrock"
  }

}


resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name    = "project-bedrock-nat-gateway"
    Project = "Bedrock"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.project_bedrock.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name    = "project-bedrock-private-rt"
    Project = "Bedrock"
  }

}

resource "aws_route_table_association" "private_assoc" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}


resource "aws_route_table_association" "public_assoc" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
