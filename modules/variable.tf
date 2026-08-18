variable "cluster_name" {
  default = "my-eks-cluster"
}

variable "kubernetes_version" {
  default = "1.33"
}

variable "instance_type" {
  default = "m7i-flex.large"
}

variable "desired_size" {
  default = 2
}

variable "min_size" {
  default = 1
}

variable "max_size" {
  default = 2
}