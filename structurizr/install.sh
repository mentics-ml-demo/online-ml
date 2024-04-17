#!/bin/bash
set -e

helm repo add virtualroot https://charts.virtualroot.dev/

helm install -n structurizr the-structurizr virtualroot/structurizr --version 0.3.0