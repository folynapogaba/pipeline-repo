resource "aws_vpc" "k8" {
# using the maximun IP address
 cidr_block = var.vpc_cidr
 
 tags = {
   Name = var.vpc_name
 }
}