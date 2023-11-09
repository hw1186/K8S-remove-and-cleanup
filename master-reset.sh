sudo rm -r /etc/cni/net.d/*
sudo rm -r ~/.kube/config

sudo systemctl restart kubelet

yes | sudo kubeadm reset

echo "========================================================"

echo "remove master cluster"

echo "========================================================"

echo "Starting install Kubernetes"

sudo apt-get update
sudo apt-get install -y apt-transport-https gnupg2

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubectl kubeadm kubelet kubernetes-cni docker.io

sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl restart kubelet

sudo usermod -aG docker $USER

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system

HOST_IP=$(ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
sudo kubeadm init --apiserver-advertise-address=$HOST_IP --pod-network-cidr=10.244.0.0/16

echo '{"exec-opts": ["native.cgroupdriver=systemd"]}' | sudo tee /etc/docker/daemon.json

sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl restart kubelet

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml

kubectl get nodes


#master reset.sh 