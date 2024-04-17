#!/bin/bash
set -e

kubectl create ns structurizr

# Add
helm repo add virtualroot https://charts.virtualroot.dev/

# helm install -n structurizr structurizr virtualroot/structurizr --set users="structurizr=$2a$10$06NrHN.vy1spw7j0IogiveInFimGayNNjvBF2/cVwpkSbJr.tewem"
# helm install -n structurizr structurizr virtualroot/structurizr --set users="structurizr=password"
helm -n structurizr upgrade --install structurizr virtualroot/structurizr

kubectl -n structurizr get configmap structurizr-users -o json > /tmp/configmap.json

export POD_NAME=$(kubectl get pods --namespace structurizr -l "app.kubernetes.io/name=structurizr,app.kubernetes.io/instance=structurizr" -o jsonpath="{.items[0].metadata.name}")
export CONTAINER_PORT=$(kubectl get pod --namespace structurizr $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
kubectl -n structurizr port-forward $POD_NAME 8084:$CONTAINER_PORT > /dev/null 2>&1 &

ENCRYPTED=$(curl http://localhost:8084/bcrypt/password)

sed -i "s/.*structurizr.users\":.*/\"structurizr.users\": \"structurizr=${ENCRYPTED}\"/" /tmp/configmap.json
kubectl -n structurizr apply -f /tmp/configmap.json
# delete the pod. the deployment created by helm will auto create immediately
kubectl -n structurizr delete pod $POD_NAME

# Create ingress
kubectl -n structurizr apply -f ingress.yaml

export POD_NAME=$(kubectl get pods --namespace structurizr -l "app.kubernetes.io/name=structurizr,app.kubernetes.io/instance=structurizr" -o jsonpath="{.items[0].metadata.name}")
export CONTAINER_PORT=$(kubectl get pod --namespace structurizr $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
nohup kubectl -n structurizr port-forward $POD_NAME 8084:$CONTAINER_PORT > /dev/null 2>&1 &
echo "Structurizr URL: http://127.0.0.1:8084"
