#! /bin/bash

set xe
WORKDIR=$(pwd)
CLUSTER_NAME="firefly"
REGISTRY_NAME="firefly"
REGISTRY_PORT="8081"
SERVER_COUNT=1
AGENT_COUNT=0
FIREFLY_NAMESPACE="firefly"
IMAGE_VERSION="rancher/k3s:v1.21.5-k3s2"

# TODO: add check for k3d >= 5.0.0
# k3s version must be 1.21.4 or better to avoid local-path permissions bug
#k3d registry create ${REGISTRY_NAME}.localhost -p ${REGISTRY_PORT} ;
k3d cluster create ${CLUSTER_NAME} \
  -p "8090:80@loadbalancer" \
  --servers ${SERVER_COUNT} \
  --agents ${AGENT_COUNT} \
  --kubeconfig-update-default=true \

# merge the kubeconfig into the default location
k3d kubeconfig merge -d firefly

# TODO: add check for helm binary. Must be v3 or better.
echo "Installing firefly stack..."
kubectl create namespace ${FIREFLY_NAMESPACE}

# This takes a _long_ time if you opted to pull all the base images in by default
helm install --namespace ${FIREFLY_NAMESPACE} firefly ../../../
cd $WORKDIR
echo "JupyterHub should be available at http://localhost:8090"
