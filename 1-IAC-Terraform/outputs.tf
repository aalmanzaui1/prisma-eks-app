output "eks-creation-status" {
  value = aws_eks_cluster.eks-cluster.status
}

# output "ecr-repository" {
#   value = aws_ecr_repository.ecr-repository.repository_url
# }

output "external-dns-iam-role" {
  value = aws_iam_role.external-dns.arn
}