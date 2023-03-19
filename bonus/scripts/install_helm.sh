clear
echo -en "\n\033[32m##### INSTALL HELM #####\033[0m\n\n"

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | sudo bash
sudo helm version