resource "aws_eks_node_group" "workers" {

  cluster_name = aws_eks_cluster.main.name

  node_group_name = "eks-workers"

  node_role_arn = data.aws_iam_role.node_role.arn

  subnet_ids = [
    aws_subnet.public1.id,
    aws_subnet.public2.id
  ]

  instance_types = ["t3.medium"]

  scaling_config {
    desired_size = 2
    min_size     = 1
    max_size     = 3
  }

  depends_on = [
    aws_iam_role_policy_attachment.worker1,
    aws_iam_role_policy_attachment.worker2,
    aws_iam_role_policy_attachment.worker3
  ]
}
