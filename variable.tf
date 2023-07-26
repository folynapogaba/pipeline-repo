variable "region" {
  type    = string
  #default = "us-east-1"
}

variable "vpc_cidr" {
  description = "(vpc ip4 cidr block)"
  type        = string
}

variable "vpc_name" {
  description = "the vpc will take the three environement name: dev, qa, production"
  type        = string
}


variable "public_subnet_cidrs" {
 type        = list(string)
 description = "Public Subnet CIDR values"
}

variable "private_subnet_cidrs" {
 type        = list(string)
 description = "Public Subnet CIDR values"
}

variable "azs" {
 type        = list(string)
 description = "Availability Zones"
}

variable "workspace" {
type        = string
description = "define different work space"
}