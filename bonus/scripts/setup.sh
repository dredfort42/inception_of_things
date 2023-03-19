clear
echo -en "\n\033[32m##### PREPARE SYSTEM #####\033[0m\n\n"

sudo apt-get update
# sudo apt-get upgrade -y

sudo apt-get install -y \
    ufw \
    net-tools \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    apt-transport-https \
    vim \
    jq

sudo ufw enable
sudo ufw default allow incoming
sudo ufw default allow outgoing

sudo iptables -L

export IP_ENP0S3=$(ifconfig enp0s3 | grep inet |  awk '/inet/ {print $2}' | head -1)

bash ./install_docker.sh
bash ./install_kubectl.sh
bash ./install_k3d.sh
bash ./install_helm.sh
bash ./install_gitlab.sh
bash ./install_argocd.sh
bash ./launch.sh