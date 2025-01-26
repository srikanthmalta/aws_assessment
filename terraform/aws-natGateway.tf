resource "aws_eip" "nat_eip" {

  tags = {
    Name = "NAT Gateway EIP"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnets["terraform-test-subnet-a"].id

  tags = {
    Name = "NAT Gateway"
  }
}
