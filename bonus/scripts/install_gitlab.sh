clear
echo -en "\n\033[32m##### INSTALL GITLAB #####\033[0m\n\n"

export EMAIL="dredfort42@gmail.com"
export DOMAIN="gitlab.local"
export KUBECONFIG="/etc/rancher/k3s/k3s.yaml"

sudo kubectl create namespace gitlab

helm repo add gitlab https://charts.gitlab.io/
helm repo update

helm install gitlab gitlab/gitlab -n gitlab \
    --set global.edition=ce \
    --set global.hosts.domain=$DOMAIN \
    --set global.hosts.https="false" \
    --set global.ingress.configureCertmanager="false" \
    --set certmanager-issuer.email=$EMAIL \
    --set gitlab-runner.install="false" 

sudo kubectl wait -n gitlab --for=condition=available deployment --all --timeout=5m

cat <<EOF | sudo kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: gitlab-svc
  namespace: gitlab
spec:
  type: LoadBalancer
  selector:
    app.kubernetes.io/name: gitlab-webservice-default
  ports:
  - port: 8085
    protocol: TCP
    targetPort: 8085
EOF

sudo kubectl port-forward --address 0.0.0.0 svc/gitlab-webservice-default -n gitlab 8085:8181 
# sudo kubectl port-forward --address 0.0.0.0 svc/argocd-server -n argocd 8080:443 

