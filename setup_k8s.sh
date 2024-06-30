sudo kubeadm init --service-cidr 10.96.0.0/16 --pod-network-cidr=192.168.0.0/16
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.3/manifests/tigera-operator.yaml
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.3/manifests/custom-resources.yaml

kubectl taint nodes --all node-role.kubernetes.io/control-plane-
kubectl taint nodes --all node-role.kubernetes.io/master-

bash ./setup_qat.sh
bash ./qat_vf_status.sh
kubectl apply -f './k8s-qat-plugin.yaml'


kubectl create configmap envoy-config --from-file ./envoy-http1.yaml --from-file ./envoy-http1-qat.yaml
kubectl create configmap envoy-running-config --from-literal=concurrency=1 --from-literal=config="/etc/config/envoy-http1.yaml"

kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
