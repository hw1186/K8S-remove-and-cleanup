# Kubernetes Cluster CleanUp and Remove 

### How to create and join new Node 
Setting File and Directory Permissions to 777  
in master node  
```bash 
kubeadm token create 
```
```bah
openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | \
   openssl dgst -sha256 -hex | sed 's/^.* //'
``` 
```bash 
sudo kubeadm join MasterIP:6443 --token <token> \
        --discovery-token-ca-cert-hash sha256:<hash> 
``` 

 command, verify that the node has joined the cluster successfully : 
 ```bash
kubectl get nodes -o wide
```
