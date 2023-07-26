resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.k8.id

  tags = {
    Name = "igw"
  }
}