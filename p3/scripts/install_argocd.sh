clear
echo -en "\n\033[32m##### INSTALL ARGO CD #####\033[0m\n\n"

sudo kubectl create namespace argocd
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
sudo kubectl -n argocd wait --for=condition=Ready --timeout=5m pods --all

echo "
apiVersion: v1
kind: Service
metadata:
  finalizers:
  - service.kubernetes.io/load-balancer-cleanup
  labels:
    app.kubernetes.io/component: server
    app.kubernetes.io/name: argocd-server
    app.kubernetes.io/part-of: argocd
  name: argocd-server
  namespace: argocd
spec:
  type: LoadBalancer
  selector:
    app.kubernetes.io/name: argocd-server
  ports:
  - port: 8080
    protocol: TCP
    targetPort: 8080
" > argo-service.yaml

sudo kubectl apply -f argo-service.yaml
rm argo-service.yaml