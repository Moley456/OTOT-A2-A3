#! /bin/bash

line="-----------------------------------------------------------------------------------------------------------------"

echo "Create kind cluster using given config file"
kind create cluster --name kind-1 --config k8s/kind/cluster-config.yaml

echo $line
echo "Check nodes and cluster info"
docker ps
kubectl get nodes
kubectl cluster-info

echo $line
echo "Deploy app image"
kubectl apply -f k8s/manifests/backend-deployment.yaml

echo $line
echo "Wait for backend Deployment to complete"
kubectl rollout status deployment/backend

echo $line
echo "Confirm backend Deployment is running"
kubectl get deployment/backend
kubectl get po -lapp=backend

echo $line
echo "Create the Service"
kubectl apply -f k8s/manifests/backend-service.yaml

echo $line
echo "Check Service is running"
kubectl get svc

echo $line
echo "Deploy ingress controller"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

echo $line
echo "Wait for ingress controller Deployment to complete"
kubectl -n ingress-nginx rollout status deploy

echo $line
echo "Confirm ingress controller is running"
kubectl -n ingress-nginx get deploy    

sleep 2
echo $line
echo "Create ingress"
kubectl apply -f k8s/manifests/backend-ingress.yaml

echo $line
echo "Check ingress is running"
kubectl get ingress
