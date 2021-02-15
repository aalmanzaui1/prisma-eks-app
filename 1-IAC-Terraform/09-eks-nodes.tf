
resource "aws_eks_node_group" "eks-cluster-nodes" {
  provider        = aws.region-master
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = "${var.deploy-name}-eks-nodes"
  node_role_arn   = aws_iam_role.eks-node-role.arn
  subnet_ids      = [aws_subnet.subnet-private-3.id, aws_subnet.subnet-private-4.id]
  capacity_type   = "SPOT"

  scaling_config {
    desired_size = var.env == "prod" ? 5 : 2
    max_size     = var.env == "prod" ? 7 : 3
    min_size     = var.env == "prod" ? 5 : 1
  }

  depends_on = [
    aws_eks_cluster.eks-cluster,
    aws_iam_role_policy_attachment.node-policy-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node-policy-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node-policy-AmazonEC2ContainerRegistryReadOnly
  ]
}