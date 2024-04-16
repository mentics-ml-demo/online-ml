#!/bin/bash
set -e

# TODO: just deleting the namespace would leave jetstack cert-manager... do I care?

kubectl delete ns redpanda
kubectl delete ns cert-manager

# kubectl delete -f redpanda-cluster.yaml --namespace <namespace>
# helm uninstall redpanda-controller --namespace <namespace>
# kubectl delete pod --all --namespace <namespace>
# kubectl delete pvc --all --namespace <namespace>
# kubectl delete secret --all --namespace <namespace>