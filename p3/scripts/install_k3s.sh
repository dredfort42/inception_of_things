clear
echo -en "\n\033[32m##### INSTALL K3S #####\033[0m\n\n"

export INSTALL_K3S_EXEC="--write-kubeconfig-mode=644 --tls-san $(hostname) --node-ip="10.0.2.15"  --bind-address="10.0.2.15" --advertise-address="10.0.2.15" "
curl -sfL https://get.k3s.io |  sh -