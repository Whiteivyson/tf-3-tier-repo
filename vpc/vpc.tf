#creation of vpc

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = var.tags
 }

#creation of public subnet

resource "aws_subnet" "public_sn1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_sn1_cidr
  availability_zone = "us-east-1a"

  tags = var.tags
}

resource "aws_subnet" "public_sn2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_sn2_cidr
  availability_zone = "us-east-1b"

  tags = var.tags
}

#creation of private subnet

resource "aws_subnet" "private_sn1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_sn1_cidr
  availability_zone = "us-east-1c"

  tags = var.tags
}

resource "aws_subnet" "private_sn2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_sn2_cidr
  availability_zone = "us-east-1c"

 tags = var.tags
}

#creation of internet gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = var.tags
}
#creation of elastic ip


resource "aws_eip" "eip" {
  domain = "vpc"
}


#creation of nat gateway

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_sn1.id

 tags = var.tags

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}



###creation of public rt
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }


  tags = var.tags
}

# Public RT association 

resource "aws_route_table_association" "public_sn1_association" {
  subnet_id      = aws_subnet.public_sn1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_sn2_association" {
  subnet_id      = aws_subnet.public_sn2.id
  route_table_id = aws_route_table.public_rt.id
}



###creation of private rt

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }


 tags = var.tags
  
}

resource "aws_route_table_association" "private_sn1_association" {
  subnet_id      = aws_subnet.private_sn1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_sn2_association" {
  subnet_id      = aws_subnet.private_sn2.id
  route_table_id = aws_route_table.private_rt.id
}