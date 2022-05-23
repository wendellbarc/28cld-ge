
### Get Region AZ's ###
data "aws_availability_zones" "available" {
  state = "available"
}

#### VPC #####
resource "aws_vpc" "create" {
  cidr_block = var.cidr_block
  tags = {
    Name = "vpc-28cld"

  }
}

#### SUBNETS ####
resource "aws_subnet" "alb_subnets" {
  count             = length(var.alb_subnets)
  vpc_id            = aws_vpc.create.id
  cidr_block        = element(var.alb_subnets, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "public-sb-28cld"
  }
}


resource "aws_subnet" "application_subnets" {
  count             = length(var.application_subnets)
  vpc_id            = aws_vpc.create.id
  cidr_block        = element(var.application_subnets, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "private-app-sb-28cld"
  }
}

resource "aws_subnet" "database_subnets" {
  count             = length(var.database_subnets)
  vpc_id            = aws_vpc.create.id
  cidr_block        = element(var.database_subnets, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "private-db-sb-28cld"
  }
}

#### INTERNET GATEWAY ####
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.create.id
  tags = {
    Name = "igw-28cld"
  }
}

#### ROUTES #### 
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.create.id
  tags = {
    Name = "public-rtb-28cld"
  }

}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.create.id
  route {
    nat_gateway_id = aws_nat_gateway.nat-gateway.id
    cidr_block     = "0.0.0.0/0"
  }
  tags = {
    Name = "private-rtb-28cld"
  }

}

resource "aws_route_table_association" "public" {
  count          = length(var.alb_subnets)
  subnet_id      = aws_subnet.alb_subnets[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "privatedb" {
  count          = length(var.database_subnets)
  subnet_id      = aws_subnet.database_subnets[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "privateapp" {
  count          = length(var.application_subnets)
  subnet_id      = aws_subnet.application_subnets[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id

}

#### ELASTIC IP ####
resource "aws_eip" "lb" {
  vpc = true
  tags = {
    Name = "eip-28cld"
  }
}

#### NAT GATEWAY #### 
resource "aws_nat_gateway" "nat-gateway" {
  allocation_id = aws_eip.lb.id
  subnet_id     = aws_subnet.alb_subnets[0].id
  tags = {
    Name = "nat-28cld"
  }
}

