#!/bin/bash
echo "Forwarding port"
nohup kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard-kong-proxy 8443:443 > /dev/null 2>&1 &
