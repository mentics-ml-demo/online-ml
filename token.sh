#!/bin/bash

echo "# Use the following bearer token to log in to the kubernetes dashboard:"
kubectl -n default create token cadmin --duration=720h
