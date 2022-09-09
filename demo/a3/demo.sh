#! /bin/bash

line="-----------------------------------------------------------------------------------------------------------------"

echo "Create metrics server"
kubectl apply -f k8s/manifests/metrics-server.yaml

echo $line
echo "Wait for metrics server creation to be complete"
kubectl -n kube-system rollout status deploy/metrics-server

echo $line
echo "Check metric server Deployment is running"
kubectl -n kube-system get deploy

echo $line
echo "Create HPA"
kubectl apply -f k8s/manifests/backend-hpa.yaml

sleep 5
echo $line
echo "Check HPA is working"
kubectl describe hpa

echo $line
echo "Stress test"
./demo/a3/stressTest.sh

sleep 10
echo $line
echo "Check that HPA scales"
kubectl describe hpa

echo $line
echo "Create backend-zone-aware Deployment"
kubectl apply -f k8s/manifests/backend-deployment-zone-aware.yaml

echo $line
echo "Wait for backend-zone-aware Deployment to be completed"
kubectl rollout status deployment/backend-zone-aware

echo $line
echo "Check pod distribution"
kubectl get po -lapp=backend-zone-aware -owide --sort-by=.spec.nodeName

