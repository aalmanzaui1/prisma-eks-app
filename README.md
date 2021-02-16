# prisma-eks-app
Deploy Next.js application

## Task 1 

Given this project deploy it to AWS in an automated and reproducible fashion. The website should be reachable from all over the world.

[Infraestructure as a code] (https://github.com/aalmanzaui1/prisma-eks-app/tree/main/1-IAC-Terraform)

## Task 2 

Restrict access to the site by using mechanisms that can be adapted programmatically.

[Infraestructure as a code] (https://github.com/aalmanzaui1/prisma-eks-app/tree/main/1-IAC-Terraform)
 
 variables.tf 26 line 

## Task 3 

Deploy the site using at least 2 technology stacks. Make sure that both types of deployment can be reproduced in an automated fashion.

This proyect use :
1. Terraform
2. Docker
3. Kubernetes
4. Jenkins

## Task 4 

What issues can you identify in the given site? What types of improvements would you suggest?

When the start command is executed the frontend app shown an error 404 not found, this is because the names of the applications are wrong, I need to modified the extension to js. I found in the documentation: (https://nextjs.org/docs/basic-features/pages)

that the routes are based on the files with extensions .js, .jsx, .ts, or .tsx allocated in the pages directory


# Table of Contents
1. [Introduction](#Introduction )
2. [Tasks](#Tasks)
3. [How-to-deploy](#How-to-deploy)
  1. [Deploy-by-command-line] (##How-to-deploy)
  2. [Deploy-by-jenkins] (##Deploy-by-jenkins)

# Introduction


This project pretends to demonstrate how to deploy an application using infrastructure as a code inside AWS cloud provider with Terraform, create an AWS EKS cluster to use Kubernetes as an orchestration tool, and implement and application to be expose using Istio service mesh ingress controller

# Tasks
1. Create a Terraform project with the following elements:
    1. AWS VPC and its network elements (route tables, subnets, NatGW IGW)
    2. Create and ECR repository
    3. Create EKS Cluster
2. Create docker container with Nextjs application.
3. Deploy the container in the EKS Cluster
4. Install Istio Service Mesh Helm chart
5. Deploy ingress file
6. Retrieve the endpoint and visit the page

# How-to-deploy

## PRE-REQUISITES

1. AWS cli v2
2. Kubectl 1.18
3. Helm 3
4. Terraform

## Deploy-by-command-line

### CLONE THE REPO

git clone git@github.com:aalmanzaui1/prisma-eks-app.git

### Create Infra as a code

(check the variable.tf file in order to change any parameter that you need, by default it has been set to work but may be will be good idea modified the variable "ip-eks-access" to restrict the access to the api eks cluster and this ip variable also allows the sg to the incoming traffic.)

(the terraform backend has been commented to avoid the creation of the s3 bucket, if you wish, you can create it and save the tf state in that container.)

access to "1-creating-infra-with-terraform" and execute the command:

```bash
cd 1-creating-infra-with-terraform
terraform apply -var="deploy-name=almanza-app-lab-a" -var="env=dev"

```

The terraform will create all the infraestructura and will create a deployment and service inside of the cluster with the container applications

### Deploy Istio service Mesh

To explose the application outside of the cluster it will be deploy Istio. to deploy the entire framework:


#### create Namespace

```bash

kubectl create namespace istio-system

```
##### Install de base 
```bash

helm install --namespace istio-system istio-base 4-helm-charts/istio-1.8.2/manifests/charts/base

```

#### Install de Discovery
```bash

helm install --namespace istio-system istiod 4-helm-charts/istio-1.8.2/manifests/charts/istio-control/istio-discovery --set global.hub="docker.io/istio" --set global.tag="1.8.2"

```
#### Install de Ingress
```bash

helm install --namespace istio-system istio-ingress 4-helm-charts/istio-1.8.2/manifests/charts/gateways/istio-ingress --set global.hub="docker.io/istio" --set global.tag="1.8.2"

```

### Deploy Ingress file

```bash

kubectl apply -f 5-deploy-ingress/gateway.yaml

```

### Get the Ingress endpoint to access to the app

```bash
kubectl get svc -n istio-system -o=jsonpath='{.items[0].status.loadBalancer.ingress[0].hostname}'

```

### Destroy de Stack

IMPORTANT it is necessary to delete first the istio helm charts to avoid error in the terraform part, this charts create a bind hardware elements

#### Delete ingress (optional)

```bash

kubectl delete -f 5-deploy-ingress

```

#### DELETE HELM CHART MANDATORY FIRST

```bash

helm delete -n istio-system istio-base istiod istio-ingress

```

#### Delete IAC

```bash

cd 1-creating-infra-with-terraform
terraform destroy -var="deploy-name=prisma-app-lab-a" -var="env=dev"

```

## Deploy-by-jenkins

## Docker pull Jenkins Sword

```bash

docker pull alvaroalmanza/jenkins-sword:v1

```

If you prefer to build the container locally, you can clone this repo:

[Jenkins-sword](https://github.com/aalmanzaui1/jenkins-sword.git)

### Run the Jenkins Sword

### CLONE THE REPO

git clone (https://github.com/aalmanzaui1/prisma-eks-app.git)

Get this points before run the docker 
 

1. local directory path where the repository is
2. local directory path where aws credentials is


### Execute the container


docker run -d -p 8080:8080 -p 50000:50000 --name jenkins-sword -v $HOME/.aws:/root/.aws -v $HOME/repos:/var/repos -v /var/run/docker.sock:/var/run/docker.sock alvaroalmanza/jenkins-sword:v1

### execute the pipelines

app-deploy-pipeline

OR 

app-destroy-pipeline

