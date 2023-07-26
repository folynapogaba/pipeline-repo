## Create ami role
# The policy that grants an entity permission to assume the role
# Use to access AWS ressources that you might not normally have access to. 
# The role that Amazon EKS will use to create AWS ressource for Kubernetes clusters.
resource "aws_iam_role" "eks" {
  name = "eks-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

#Ressource: aws_iam_role_policy_attachement
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/ressources/iam_role
# attache the ami to the EKS cluster

resource "aws_iam_role_policy_attachment" "proj-AmazonEKSClusterPolicy" {
  role       = aws_iam_role.eks.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}


# Create cluster

resource "aws_eks_cluster" "project" {
  name     = "project"
  role_arn = aws_iam_role.eks.arn

  ## Desired Kubernetes master version
  #version = "1.18"

  vpc_config {
    # Indicates whether or not the Amazon EKS private API server endpoint is anabled
    endpoint_private_access = false

    # Indicates whether or not the Amazon EKS private API server endpoint is anabled
    endpoint_public_access = true

    subnet_ids = [
      aws_subnet.public_subnets[0].id,
      aws_subnet.public_subnets[1].id,
      aws_subnet.private_subnets[0].id,
      aws_subnet.private_subnets[1].id
      #element(aws_subnet.public_subnets, count.index),
      #element(aws_subnet.private_subnets, count.index)
       ]
  }
  depends_on = [aws_iam_role_policy_attachment.proj-AmazonEKSClusterPolicy]
}