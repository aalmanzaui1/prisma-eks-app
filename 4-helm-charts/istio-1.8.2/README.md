# How to install Istio Helm charts

## create Namespace

```bash

kubectl create namespace istio-system

```
## Install de base 
```bash

helm install --namespace istio-system istio-base 4-helm-charts/istio-1.8.2/manifests/charts/base

```

## Install de Discovery
```bash

helm install --namespace istio-system istiod 4-helm-charts/istio-1.8.2/manifests/charts/istio-control/istio-discovery --set global.hub="docker.io/istio" --set global.tag="1.8.2"

```
## Install de Ingres
```bash

helm install --namespace istio-system istio-ingress 4-helm-charts/istio-1.8.2/manifests/charts/gateways/istio-ingress --set global.hub="docker.io/istio" --set global.tag="1.8.2"

```

# How to delete the charts
```bash

helm delete -n istio-system istio-ingress istiod istio-base  

```