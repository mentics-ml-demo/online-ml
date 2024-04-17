#!/bin/bash

export POD_NAME=$(kubectl get pods --namespace structurizr -l "app.kubernetes.io/name=structurizr,app.kubernetes.io/instance=the-structurizr" -o jsonpath="{.items[0].metadata.name}")
export CONTAINER_PORT=$(kubectl get pod --namespace structurizr $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
echo "Structurizr URL: http://127.0.0.1:8084"
nohup kubectl --namespace structurizr port-forward $POD_NAME 8084:$CONTAINER_PORT > /dev/null 2>&1 &
