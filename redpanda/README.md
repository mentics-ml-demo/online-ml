Random commands and notes as I was working on it.

###############

alias internal-rpk="kubectl --namespace rpanda exec -i -t redpanda-0 -c redpanda -- rpk"

kubectl apply -f redpanda/topic.yaml -n rpanda

kubectl logs -l app.kubernetes.io/name=operator -c manager --namespace rpanda

internal-rpk topic describe test-topic
echo "test message" | internal-rpk topic produce test-topic

internal-rpk topic consume test-topic --num 1

# Doc on api port: https://docs.redpanda.com/current/deploy/deployment-option/self-hosted/kubernetes/local-guide/?tab=tabs-3-helm-operator#nodeport-service
# node port: 31092, container port: 9094
kubectl --namespace rpanda port-forward svc/redpanda-external 8021:31092

kubectl --namespace rpanda port-forward redpanda-0 8021:31092

# > /dev/null 2>&1 &

# for testing, use this standalone kcat (kafkacat)
# https://github.com/edenhill/kcat


kubectl --namespace rpanda port-forward i-0746ee640d9f55eb7 8021:31092


####
# install rpk locally
# mkdir -p ~/.local/bin
curl -LO https://github.com/redpanda-data/redpanda/releases/latest/download/rpk-linux-amd64.zip
# export PATH="~/.local/bin:$PATH"
unzip rpk-linux-amd64.zip -d ~/.local/bin/
rpk version
