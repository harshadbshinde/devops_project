data "aws_iam_role" "eks_cluster_role" {

  name = "eks-cluster-role"

}


data "aws_iam_role" "node_role" {

  name = "eks-node-role"

}


resource "aws_iam_role_policy_attachment" "cluster_policy" {

  role = data.aws_iam_role.eks_cluster_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"

}


resource "aws_iam_role_policy_attachment" "worker1" {

  role = data.aws_iam_role.node_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"

}


resource "aws_iam_role_policy_attachment" "worker2" {

  role = data.aws_iam_role.node_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"

}


resource "aws_iam_role_policy_attachment" "worker3" {

  role = data.aws_iam_role.node_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"

}
