# online-ml

Demonstration system that runs an ML model (including inference, ongoing training, and model updating) based on streaming data with a single script deploy to AWS using kops, kubernetes, terraform/opentofu, argocd, and kubeflow.

# Run

Run from the shell:
`./run.sh`
This will startup a cluster in AWS

When you're done with it, run
`./shudown.sh`
to shut down the cluster.

For running commands or troubleshooting, you can set the vars in your current shell by running:
`. setenv.sh`

# Notes:

I specified t4g.small for size because they are free during 2024. Also, oddly enough, the on-demand t4g.small's are free, but it seems I was charged a few cents when running them as spot instances. So, these scripts are currently not running spot instances until that changes.

TODO: After building everything, can go in manually and
delete the load balancer
delete the elastic ip