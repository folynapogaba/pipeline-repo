# The goal is to create private and public rout table and associate them to the subnets

# Private route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.k8.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private"
  }
}

# Public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.k8.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id 
  }

  tags = {
    Name = "public"
  }
}


## association private route table to  private subnet

resource "aws_route_table_association" "PRV" {
  count = length(var.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = aws_route_table.private.id
}


## association private route table to  public subnet
