# online-ml

Demonstration system that runs an ML model (including inference, ongoing training, and model updating) based on streaming data with a single script deploy to AWS using kops, kubernetes, terraform, argocd, and kubeflow.

# Run

To use IAM Identity Center as recommended (https://docs.aws.amazon.com/cli/latest/userguide/sso-configure-profile-token.html):
aws configure sso
export AWS_DEFAULT_PROFILE=<profile-name> # set this if you don't want to specify profile on all the commands
aws sso login

copy `config.template` to `config` and enter the values for the unset properties there.

For running commands or troubleshooting, you must set the properties in your current shell by running:
`source setenv.sh`

Run from the shell:
`./run.sh`
This will startup a cluster in AWS

When you're done with it, run
`./shudown.sh`
to shut down the cluster.

# Access components

haproxy configures host based access to:
k8s dashboard: https://${SUBDOMAIN_KUBERNETES}.${DOMAIN}
ArgoCD admin: https://${SUBDOMAIN_CD}.${DOMAIN}
Structurizr: https://${SUBDOMAIN_STRUCTURIZR}.${DOMAIN}

Forwarding brings acccess to:
`./kubernetes/forward_api.sh`: kubectl at localhost:7443
`./redpanda/connect.sh`: Makes the redpanda console available via http://localhost:8020
`./scylladb/connect.sh`: There's no UI, but you access a shell on the host via this command

# Notes:

I specified t4g.small for size because they are free during 2024. Also, oddly enough, the on-demand t4g.small's are free, but it seems I was charged a few cents when running them as spot instances. So, these scripts are currently not running spot instances until that changes.


# Prereqs

## Install command line tools

sudo apt-get install -y jq

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
