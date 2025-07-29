#!/bin/bash

set -e

echo "🔧 Updating system..."
sudo apt-get update -y && sudo apt-get upgrade -y

echo "🐳 Installing Docker..."
sudo apt-get install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER

echo "📦 Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client && echo "✅ kubectl installed"

echo "📦 Installing kind (Kubernetes in Docker)..."
curl -Lo ./kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64
chmod +x kind
sudo mv kind /usr/local/bin/
kind version && echo "✅ kind installed"

echo "📁 Creating Kubernetes cluster with kind..."
cat <<EOF > kind-config.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
    extraPortMappings:
      - containerPort: 30080
        hostPort: 30080
EOF

kind create cluster --name local-k8s --config kind-config.yaml

echo "🧪 Verifying setup..."
kubectl get nodes

echo "🎉 Kind + kubectl setup completed successfully!"
echo "🔁 Please logout and login again or run: newgrp docker"
