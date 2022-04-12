resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_a_cidr
  availability_zone       = "${var.region_name}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-a"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_b_cidr
  availability_zone       = "${var.region_name}b"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-b"
  }
}

resource "aws_subnet" "private_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_a_cidr
  availability_zone       = "${var.region_name}a"
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-private-a"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_b_cidr
  availability_zone       = "${var.region_name}b"
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-private-b"
  }
}

resource "aws_subnet" "data_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.data_a_cidr
  availability_zone       = "${var.region_name}a"
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-data-a"
  }
}

resource "aws_subnet" "data_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.data_b_cidr
  availability_zone       = "${var.region_name}b"
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-data-b"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "${var.project_name}-nat-gw"
  }
}

resource "aws_route_table" "internet_route_table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "internet-route-table"
  }
}

resource "aws_route_table" "nat_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "nat-route-table"
  }
}

# ASSOCIATE ROUTE TABLE -- PRIVATE_a LAYER
resource "aws_route_table_association" "internet_route_table_association_pvt_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.nat_route_table.id
}

# ASSOCIATE ROUTE TABLE -- PRIVATE_b LAYER
resource "aws_route_table_association" "internet_route_table_association_pvt_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.nat_route_table.id
}

# ASSOCIATE ROUTE TABLE -- DATA_a LAYER
resource "aws_route_table_association" "internet_route_table_association_data_a" {
  subnet_id      = aws_subnet.data_a.id
  route_table_id = aws_route_table.nat_route_table.id
}

# ASSOCIATE ROUTE TABLE -- DATA_b LAYER
resource "aws_route_table_association" "internet_route_table_association_data_b" {
  subnet_id      = aws_subnet.data_b.id
  route_table_id = aws_route_table.nat_route_table.id
}

# ASSOCIATE ROUTE TABLE -- PUBLIC_a LAYER
resource "aws_route_table_association" "internet_route_table_association_public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.internet_route_table.id
}

# ASSOCIATE ROUTE TABLE -- PUBLIC_b LAYER
resource "aws_route_table_association" "internet_route_table_association_public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.internet_route_table.id
}