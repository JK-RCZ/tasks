#!/bin/bash


# VARIABLES-------------------------------------------------------------------------------------------------------------------------
s3_bucket_name=k8s-buffer-19556
docker_version=5:24.0.7-1~ubuntu.22.04~jammy # You can list the available versions: apt-cache madison docker-ce | awk '{ print $3 }'
k8s_version=v1.25
containerd_config_file_path=/etc/containerd/config.toml
# ----------------------------------------------------------------------------------------------------------------------------------


# UTILITIES INSTALLATION -----------------------------------------------------------------------------------------------------------
apt-get update
apt-get install -y awscli
apt-get install -y net-tools
#-----------------------------------------------------------------------------------------------------------------------------------


# DOCKER INSTALLATION---------------------------------------------------------------------------------------------------------------
#Uninstall all conflicting packages
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do apt-get remove $pkg; done
# Add Docker's official GPG key:
apt-get update
apt-get install -y ca-certificates curl gnupg
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
#Install Docker
apt-get install -y docker-ce=$docker_version docker-ce-cli=$docker_version containerd.io docker-buildx-plugin docker-compose-plugin
#Enable Docker
systemctl enable --now docker
#Create default configuration for containerd
containerd config default > ${containerd_config_file_path}
# Enable Systemd for containerd
sed -i "s|SystemdCgroup = .*$|SystemdCgroup = true|" ${containerd_config_file_path}
systemctl restart containerd
# -----------------------------------------------------------------------------------------------------------------------------------


# KUBERNETES INSTALLATION------------------------------------------------------------------------------------------------------------
apt-get update
apt-get install -y apt-transport-https ca-certificates curl
# Download the public signing key for the Kubernetes package repositories
curl -fsSL https://pkgs.k8s.io/core:/stable:/${k8s_version}/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
# This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/${k8s_version}/deb/ /" | tee /etc/apt/sources.list.d/kubernetes.list
# Update the apt package index, install kubelet, kubeadm and kubectl, and pin their version
apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl
# Initialize control plane
kubeadm init --pod-network-cidr=192.168.0.0/16 | tee /tmp/temp.txt
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
mkdir -p /root/.kube
cp -i /etc/kubernetes/admin.conf /root/.kube/config
#export KUBECONFIG=/etc/kubernetes/admin.conf
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/tigera-operator.yaml
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/custom-resources.yaml
# Create bash script in order to launch init command on worker node
echo "#!/bin/bash" > /tmp/init-worker-node.sh
tail -n 2 /tmp/temp.txt >> /tmp/init-worker-node.sh
# Copy /tmp/init-worker-node.sh to S3
aws s3 cp /tmp/init-worker-node.sh s3://${s3_bucket_name}
# -----------------------------------------------------------------------------------------------------------------------------------
