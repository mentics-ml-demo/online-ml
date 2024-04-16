#!/bin/bash
set -e

aws iam create-policy --policy-name Ec2InstanceConnectAll --policy-document ec2-instance-connect-all.json