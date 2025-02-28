data "template_file" "user_data" {
  template = <<EOF
#!/bin/bash

# Update packages
sudo apt update && sudo apt upgrade -y

# Install dependencies
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker's GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list'

# Update packages again
sudo apt update && sudo apt upgrade -y

# Install Docker
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Start and enable Docker
sudo systemctl start docker
sudo systemctl enable docker

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Enable kubectl autocompletion
source <(kubectl completion bash)
echo "source <(kubectl completion bash)" >> ~/.bashrc

# Install Helm
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

# Download and install Kind
curl -Lo ./kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# Create the cluster with Kind
kind create cluster --name asatech

# Export kubeconfig
kind export kubeconfig --name asatech --kubeconfig /home/ubuntu/.kube/config

# Change ownership of kubeconfig to the ubuntu user
sudo chown -R ubuntu:ubuntu /home/ubuntu/.kube

# Wait until the node is ready
until kubectl get nodes | grep -q "Ready"; do
  sleep 4
done

# Add your Helm repository
helm repo add generic-app https://owiltoncezar.github.io/generic-app/
helm repo update

# Install your Helm chart
helm install nginx generic-app/generic-app --namespace nginx --create-namespace

EOF
}

