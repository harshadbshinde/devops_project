resource "aws_eks_node_group" "workers" {

  cluster_name = aws_eks_cluster.main.name

  node_group_name = "worker-node"

  node_role_arn = aws_iam_role.node_role.arn

  subnet_ids = [
    aws_subnet.public1.id,
    aws_subnet.public2.id
  ]

  scaling_config {

    desired_size = var.desired_size

    min_size = var.min_size

    max_size = var.max_size
  }

  instance_types = [
    var.instance_type
  ]

  capacity_type = "ON_DEMAND"

  depends_on = [
    aws_iam_role_policy_attachment.worker1,
    aws_iam_role_policy_attachment.worker2,
    aws_iam_role_policy_attachment.worker3
  ]
}