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
        stage('destroy ingress file') {
            steps{
                sh(script:"""\
                 cd /var/repos/prisma-eks-app/
                 kubectl delete -f 5-deploy-ingress 
                 """)
            }
        }
        stage('destroy helm charts') {
            steps{
                sh(script:"""\
                 cd /var/repos/prisma-eks-app/
                 helm delete -n istio-system istio-base istiod istio-ingress
                 """)
            }
        }
        stage('Destroy infra') {
            steps{
                sh(script:"""\
                 cd /var/repos/prisma-eks-app/1-IAC-Terraform
                 terraform destroy -auto-approve -var=\"deploy-name="${params.deployname}"\" -var=\"env="${params.enviroment}"\"
                 """)
            }
        }
    }
}