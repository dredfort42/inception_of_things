clear
echo -en "\n\033[32m##### INSTALL KUBECTL #####\033[0m\n\n"

export INSTALL_K3S_EXEC="--write-kubeconfig-mode=644 --tls-san $(hostname) --node-ip=$IP_ENP0S3  --bind-address=$IP_ENP0S3 --advertise-address=$IP_ENP0S3 "
curl -sfL https://get.k3s.io |  sh -