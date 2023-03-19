clear
echo -en "\n\033[32m##### LAUNCH #####\033[0m\n\n"

cat <<EOF | sudo kubectl apply -f -
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
    repoURL: 'http://gitlab.local:8085/root/iot/'
    targetRevision: HEAD
  project: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
EOF

cat <<EOF | sudo kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-gateway
spec:
  rules:
  - host: app.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: dredfort-svc
            port:
              number: 8888
  - host: argocd.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: argocd-server
            port:
              number: 8080
  - host: gitlab.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: gitlab-svc
            port:
              number: 8085
EOF

sleep 5s
sudo kubectl -n dev wait --for=condition=Ready --timeout=5m pods --all

clear
sudo kubectl get pods -A
sleep 3s

clear
echo -en "\n\033[32m##### SYSTEM READY #####\033[0m\n\n"
echo
echo "APP ENDPOINT:"
echo "app.local:8888"
echo
echo "--------------------"
echo
echo "ARGOCD ENDPOINT:"
echo "argocd.local:8080"
echo
echo "ARGOCD USER:"
echo "admin"
echo
echo "ARGOCD PASSWORD:"
echo $(sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d; echo)
echo
echo "--------------------"
echo
echo "GITLAB ENDPOINT:"
echo "gitlab.local:8085"
echo
echo "GITLAB USER:"
echo "root"
echo
echo "GITLAB PASSWORD:"
echo $(sudo kubectl get secret -n gitlab gitlab-gitlab-initial-root-password -o jsonpath='{.data.password}' | base64 -d; echo)
echo

