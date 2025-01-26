resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.test_vpc.id

  tags = {
    Name = "terraform-test-igw"
  }
}

# Route Table Creation 
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.test_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  /*  route {
    cidr_block = aws_vpc.test_vpc.cidr_block
    gateway_id = aws_internet_gateway.igw.id
  }
dynamic "route" {
    for_each = var.routes_public
    content {
      cidr_block           = route.value.cidr_block
      gateway_id           = lookup(route.value, "gateway_id", null)
      transit_gateway_id   = lookup(route.value, "transit_gateway_id", null)
      nat_gateway_id       = lookup(route.value, "nat_gateway_id", null)
      network_interface_id = lookup(route.value, "network_interface_id", null)
    }
  }
  */

  tags = {
    Name = "terraform-test-public-rt"
  }
}

resource "aws_route_table_association" "public_subnets_assoc" {
  for_each       = aws_subnet.public_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}



resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.test_vpc.id
 /*   route {
    cidr_block = aws_vpc.test_vpc.cidr_block
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
dynamic "route" {
    for_each = var.routes_private
    content {
      cidr_block           = route.value.cidr_block
      gateway_id           = lookup(route.value, "gateway_id", null)
      transit_gateway_id   = lookup(route.value, "transit_gateway_id", null)
      nat_gateway_id       = lookup(route.value, "nat_gateway_id", null)
      network_interface_id = lookup(route.value, "network_interface_id", null)
    }
  }*/

  tags = {
    Name = "terraform-test-private-rt"
  }
}

resource "aws_route_table_association" "private_subnets_assoc" {
  for_each       = aws_subnet.private_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt.id
}

