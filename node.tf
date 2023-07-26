# nodes iam role

resource "aws_iam_role" "nodes" {
  name = "eks-nodes"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Statement = [{
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }]
      Version = "2012-10-17"
  })

  tags = {
    tag-key = "nod"
  }
}

# attache the ami to the nodes cluster
## access to EC2 and EKS
resource "aws_iam_role_policy_attachment" "nodes-EKSWorkerPolicy" {
  role       = aws_iam_role.nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}


resource "aws_iam_role_policy_attachment" "nodes-CNI_Policy" {
  role       = aws_iam_role.nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# this policy help downloads and push images
resource "aws_iam_role_policy_attachment" "nodes-Container" {
  role       = aws_iam_role.nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# create nodes group

resource "aws_eks_node_group" "private-nodes" {
  cluster_name    = aws_eks_cluster.project.name
  node_group_name = "private-nodes"
  node_role_arn   = aws_iam_role.nodes.arn
  subnet_ids      = [
    #aws_subnet.private_subnets[*].id
    aws_subnet.private_subnets[0].id,
    aws_subnet.private_subnets[1].id
  ]
  
  capacity_type = "ON_DEMAND"
  disk_size = 20
  force_update_version = false
  instance_types = ["t2.medium"]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role ="general"
  }

  #kubernetes version 
  #version = ""

  # taint {
  # key = "team"
  # value = "devops"
  # effect = "NO_SCHEDULE"
  # }
  # launch_template {
  #   name = aws_launch_template.eks-with-disks.name
  #   version = aws_launch_template.eks-with-disks.latest_version   
  #}

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.nodes-EKSWorkerPolicy,
    aws_iam_role_policy_attachment.nodes-CNI_Policy,
    aws_iam_role_policy_attachment.nodes-Container,

    #aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
    #aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
    #aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
  ]
}