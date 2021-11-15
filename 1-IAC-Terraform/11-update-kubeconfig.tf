resource "null_resource" "get-eks-credentials" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${aws_eks_cluster.eks-cluster.name}"
  }
  depends_on = [aws_eks_cluster.eks-cluster, aws_ecr_repository.ecr-repository]
}