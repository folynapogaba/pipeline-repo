# to meet EKS requirement we need at least 4 subnet (2 public and 2 privates)
## public subnets

resource "aws_subnet" "public_subnets" {
 count      = length(var.public_subnet_cidrs)
 vpc_id     = aws_vpc.k8.id
 cidr_block = element(var.public_subnet_cidrs, count.index)
 map_public_ip_on_launch = true
 availability_zone = element(var.azs, count.index)
 
 tags = {
   "Name" = "Public Subnet ${count.index + 1}"
   "kubernetes.io/role/elb"          = "1"
   "kubernetes.io/cluster/project"   = "owned"
 }
}
 
resource "aws_subnet" "private_subnets" {
 count      = length(var.private_subnet_cidrs)
 vpc_id     = aws_vpc.k8.id
 cidr_block = element(var.private_subnet_cidrs, count.index)
 map_public_ip_on_launch = true
 availability_zone = element(var.azs, count.index)
 
 tags = {
   "Name" = "Private Subnet ${count.index + 1}"
   "kubernetes.io/role/internal-elb" = "1"
   "kubernetes.io/cluster/project"   = "owned"

 }
}