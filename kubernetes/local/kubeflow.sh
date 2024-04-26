#!/usr/bin/env bash
set -e
docker run --name mk8s -d ubuntu:latest /bin/bash -c "sleep infinity"
docker exec -it mk8s bash

apt-get update
apt-get install -y snapd

snap install microk8s --classic --channel=1.26/stable

MK8S_USER=mk8s
useradd -m $MK8S_USER
chsh -s /bin/bash mk8s
adduser mk8s sudo
usermod -a -G microk8s $MK8S_USER
su - mk8s

newgrp microk8s

--------------------------

sudo snap install multipass
multipass launch --cpus 16 --memory 32G --disk 20G --name mk8s lts
multipass shell mk8s

sudo snap install microk8s --classic --channel=1.26/stable
sudo usermod -a -G microk8s $USER
newgrp microk8s
sudo chown -f -R $USER ~/.kube
# TODO: add newgrp mcirok8s to .bashrc?

microk8s enable dns hostpath-storage ingress metallb:10.64.140.43-10.64.140.49 rbac

# expect the above to be enabled
microk8s status

sudo snap install juju --classic --channel=3.1/stable
mkdir -p ~/.local/share
microk8s config | juju add-k8s my-k8s --client
juju bootstrap my-k8s uk8sx
juju add-model kubeflow

sudo sysctl fs.inotify.max_user_instances=1280
sudo sysctl fs.inotify.max_user_watches=655360

cat <<EOT | sudo tee -a /etc/sysctl.conf
fs.inotify.max_user_instances=1280
fs.inotify.max_user_watches=655360
EOT

juju deploy kubeflow --trust  --channel=1.8/stable

juju status
# juju status --watch 5s

IP=microk8s kubectl -n kubeflow get svc istio-ingressgateway-workload -o jsonpath='{.status.loadBalancer.ingress[0].ip}'

juju config dex-auth public-url=http://${IP}.nip.io
juju config oidc-gatekeeper public-url=http://${IP}.nip.io
juju config dex-auth static-username=admin
juju config dex-auth static-password=admin


