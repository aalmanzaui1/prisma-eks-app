resource "aws_iam_role" "eks-role" {
  provider = aws.region-master
  name     = "eks-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

  tags = {
    environment = var.env
    deploy      = var.deploy-name
  }
}

resource "aws_iam_role_policy_attachment" "policy-attach" {
  provider   = aws.region-master
  role       = aws_iam_role.eks-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "policy-attach-service" {
  provider   = aws.region-master
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks-role.name
}

resource "aws_iam_role" "eks-node-role" {
  provider = aws.region-master
  name     = "eks-node-group-example"

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
}

resource "aws_iam_role_policy_attachment" "node-policy-AmazonEKSWorkerNodePolicy" {
  provider   = aws.region-master
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-node-role.name
}

resource "aws_iam_role_policy_attachment" "node-policy-AmazonEKS_CNI_Policy" {
  provider   = aws.region-master
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-node-role.name
}

resource "aws_iam_role_policy_attachment" "node-policy-AmazonEC2ContainerRegistryReadOnly" {
  provider   = aws.region-master
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-node-role.name
}

resource "aws_iam_policy" "external-dns" {
  provider   = aws.region-master
  name       = "external-dns"
  policy     = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets"
      ],
      "Resource": [
        "arn:aws:route53:::hostedzone/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ListHostedZones",
        "route53:ListResourceRecordSets"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
  depends_on = [aws_eks_cluster.eks-cluster, aws_iam_openid_connect_provider.sa-provider]
}

resource "aws_iam_role" "external-dns" {
  provider = aws.region-master
  name     = "external-dns"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "${aws_iam_openid_connect_provider.sa-provider.arn}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${aws_iam_openid_connect_provider.sa-provider.url}:sub": "system:serviceaccount:kube-system:external-dns"
        }
      }
    }
  ]
}
EOF
  depends_on         = [aws_eks_cluster.eks-cluster, aws_iam_openid_connect_provider.sa-provider]
}

resource "aws_iam_role_policy_attachment" "external-dns" {
  provider   = aws.region-master
  role       = aws_iam_role.external-dns.name
  policy_arn = aws_iam_policy.external-dns.arn
  depends_on = [aws_eks_cluster.eks-cluster, aws_iam_openid_connect_provider.sa-provider]
}