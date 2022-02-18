#! /bin/bash
set xe

# install helm
./contrib/build/install-helm.sh

# install kubectl
curl -LO "https://dl.k8s.io/release/v1.22.2/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# install k3d
./contrib/build/install-k3d.sh

# start and enable docker service
systemctl start docker
systemctl enable docker.service
