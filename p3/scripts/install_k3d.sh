clear
echo -en "\n\033[32m##### INSTALL K3D #####\033[0m\n\n"

curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
sudo k3d cluster create dredfort
sudo k3d kubeconfig get dredfort > ~/.kube/config

sleep 60s
sudo kubectl -n kube-system delete pods --all --force
sudo kubectl -n kube-system wait --for=condition=Ready --timeout=5m pods --all
sudo kubectl get pods -A

sudo kubectl create namespace dev