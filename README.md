# online-ml

Demonstration system that runs an ML model (including inference, ongoing training, and model updating) based on streaming data with a single script deploy to AWS using kops, kubernetes, terraform, argocd, and kubeflow.

# Run

Run from the shell:
`./run.sh`
This will startup a cluster in AWS

When you're done with it, run
`./shudown.sh`
to shut down the cluster.

For running commands or troubleshooting, you must set the vars in your current shell by running:
`. setenv.sh`

# Notes:

I specified t4g.small for size because they are free during 2024. Also, oddly enough, the on-demand t4g.small's are free, but it seems I was charged a few cents when running them as spot instances. So, these scripts are currently not running spot instances until that changes.


# Prereqs

## Install AWS CLI

## Install kubectl

## Install ArgoCD CLI
docs: https://kostis-argo-cd.readthedocs.io/en/refresh-docs/getting_started/install_cli/

```
ARGOCD_VERSION=$(curl --silent "https://api.github.com/repos/argoproj/argo-cd/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')

curl -sSL -o /tmp/argocd-${ARGOCD_VERSION} https://github.com/argoproj/argo-cd/releases/download/${ARGOCD_VERSION}/argocd-linux-amd64

chmod +x /tmp/argocd-${VERSION}
sudo mv /tmp/argocd-${VERSION} /usr/local/bin/argocd
argocd version --client
```
