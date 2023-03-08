clear
echo -en "\n\033[32m##### LAUNCH #####\033[0m\n\n"

echo "
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: playground-app
  namespace: argocd
spec:
  destination:
    name: ''
    namespace: dev
    server: 'https://kubernetes.default.svc'
  source:
    path: manifests
    repoURL: 'https://github.com/dredfort42/iot/'
    targetRevision: HEAD
  project: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
" > app.yaml

sudo kubectl apply -f app.yaml
rm app.yaml

sleep 5s
sudo kubectl -n dev wait --for=condition=Ready --timeout=5m pods --all

clear
sudo kubectl get pods -A
sleep 3s

clear
echo -en "\n\033[32m##### SYSTEM READY #####\033[0m\n\n"
echo
echo "ARGOCD USER:"
echo "admin"
echo
echo "ARGOCD PASSWORD:"
echo $(sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d; echo)
echo