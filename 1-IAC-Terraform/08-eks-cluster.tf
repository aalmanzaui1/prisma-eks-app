resource "aws_eks_cluster" "eks-cluster" {
  provider = aws.region-master
  name     = var.deploy-name
  role_arn = aws_iam_role.eks-role.arn

  vpc_config {
    subnet_ids              = [aws_subnet.subnet-private-3.id, aws_subnet.subnet-private-4.id]
    endpoint_private_access = true
    endpoint_public_access  = var.eks-public-access
    public_access_cidrs     = var.ip-eks-access
    security_group_ids      = [aws_security_group.eks.id]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.policy-attach
  ]
}


resource "aws_iam_openid_connect_provider" "sa-provider" {
  provider = aws.region-master
  url      = aws_eks_cluster.eks-cluster.identity[0].oidc[0].issuer

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = ["9E99A48A9960B14926BB7F3B02E22DA2B0AB7280"]
  depends_on      = [aws_eks_cluster.eks-cluster]
}