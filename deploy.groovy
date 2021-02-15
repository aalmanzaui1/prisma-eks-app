pipeline {
    agent any 
        environment { 
        //gitRepo = 'data'
        dirRepos = '/var/repos'
    }
    parameters {
        string(name: 'deployname', defaultValue: '', description: 'Name of the platform and eks cluster important to tagging the vpc resources correctly')
        choice(name: 'enviroment', choices: ['dev','prod'], description: 'size of the platform and the cluster eks nodes')
    }
    stages {
        stage('Deploy infra') {
            steps{
                sh(script:"""\
                 cd /var/repos/prisma-eks-app/1-IAC-Terraform
                 terraform init
                 terraform apply -auto-approve -var=\"deploy-name="${params.deployname}"\" -var=\"env="${params.enviroment}"\"
                 """)
            }
        }
        stage('Deploy helm charts') {
            steps{
                sh(script:"""\
                 cd /var/repos/prisma-eks-app/
                 kubectl create ns istio-system
                 helm install --namespace istio-system istio-base 4-helm-charts/istio-1.8.2/manifests/charts/base
                 helm install --namespace istio-system istiod 4-helm-charts/istio-1.8.2/manifests/charts/istio-control/istio-discovery --set global.hub="docker.io/istio" --set global.tag="1.8.2"
                 helm install --namespace istio-system istio-ingress 4-helm-charts/istio-1.8.2/manifests/charts/gateways/istio-ingress --set global.hub="docker.io/istio" --set global.tag="1.8.2"
                 """)
            }
        }
        stage('Deploy ingress file') {
            steps{
                sh(script:"""\
                 cd /var/repos/prisma-eks-app/
                 kubectl apply -f 5-deploy-ingress 
                 """)
            }

        }
        stage('Get istio ingress endpoint') {
            steps {
                sh(script:"""\
                kubectl get svc -n istio-system -o=jsonpath='{.items[0].status.loadBalancer.ingress[0].hostname}'
                 """)
            }
        }
    }
}