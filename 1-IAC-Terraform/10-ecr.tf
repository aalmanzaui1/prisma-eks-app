resource "aws_ecr_repository" "ecr-repository" {
  provider             = aws.region-master
  name                 = var.deploy-name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  provisioner "local-exec" {
    command = "aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin ${aws_ecr_repository.ecr-repository.repository_url}"
  }
    depends_on = [aws_eks_cluster.eks-cluster]
}

resource "null_resource" "build-docker" {
  provisioner "local-exec" {
    command = "docker build -t ${aws_ecr_repository.ecr-repository.repository_url}:prismav1 ../2-app/ && docker push ${aws_ecr_repository.ecr-repository.repository_url}:prismav1"
  }
  depends_on = [aws_eks_cluster.eks-cluster,aws_ecr_repository.ecr-repository]
}

locals {
  container_deploy = <<-EOT
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    creationTimestamp: null
    labels:
      app: prisma-app
    name: prisma-app
  spec:
    replicas: 1
    selector:
      matchLabels:
        app: prisma-app
    strategy: {}
    template:
      metadata:
        creationTimestamp: null
        labels:
          app: prisma-app
      spec:
        containers:
        - image: ${aws_ecr_repository.ecr-repository.repository_url}:prismav1
          name: prisma-app
          resources: {}
          ports:
          - containerPort: 3000
  status: {}

 EOT
}

locals {
  services = <<-EOT
  apiVersion: v1
  kind: Service
  metadata:
    name: prisma-app-service
  spec:
    selector:
      app: prisma-app
    ports:
      - protocol: TCP
        port: 80
        targetPort: 3000
 EOT
}

resource "local_file" "container1_deployment" {
  filename = "../3-deployment-files/container_deployment.yml"
  content  = local.container_deploy
  depends_on = [aws_eks_cluster.eks-cluster,aws_ecr_repository.ecr-repository]
}

resource "local_file" "services-k8s" {
  filename = "../3-deployment-files/services.yml"
  content  = local.services
  depends_on = [aws_eks_cluster.eks-cluster,aws_ecr_repository.ecr-repository]
}