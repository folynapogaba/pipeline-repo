resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name = "nat"
  }
}

## PUBLIC NAT   "aws_subnet" "PR1a"
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id    = aws_subnet.public_subnets[1].id  
  #subnet_id     = element(aws_subnet.public_subnets, count.index)  "${element(module.vpc.public_subnets, count.index)}"
  tags = {
    Name = "NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}