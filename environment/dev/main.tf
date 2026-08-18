module "eks" {

  source = "../../modules"

  cluster_name       = var.cluster_name
  kubernetes_version = var.kubernetes_version

  instance_type = var.instance_type

  desired_size = var.desired_size
  min_size     = var.min_size
  max_size     = var.max_size
}