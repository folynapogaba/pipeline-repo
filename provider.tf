terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.5.0"
    }
  }
}

 #Configure the AWS Provider
provider "aws" {
  region = var.region
}

terraform {
  cloud {
    organization = "FOLLY"

    workspaces {
      name = "dev-workspace"
    }
  }
}
