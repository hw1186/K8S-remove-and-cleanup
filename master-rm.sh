sudo rm -r /etc/cni/net.d/*
sudo rm -r ~/.kube/config

sudo systemctl restart kubelet

yes | sudo kubeadm reset

echo "remove master cluster"

#master-rm.sh