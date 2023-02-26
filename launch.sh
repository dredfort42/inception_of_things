#!/bin/bash

LOGFILE=$0
FILEPATH=${LOGFILE:0:2}
FILEPATHLEN=`echo ${LOGFILE} | wc -m`
if [ $FILEPATH = "./" ]; then
  FILEPATH=`pwd`${LOGFILE:1:$(($FILEPATHLEN - 11))}
  LOGFILE=`pwd`${LOGFILE:1:$(($FILEPATHLEN - 5))}.log
fi

echo $LOGFILE
echo $FILEPATH

rm $LOGFILE 2>/dev/null

# Spinner for running state
spinner() {
local i sp n
sp='/-\|'
n=${#sp}
printf ' '
while sleep 0.2; do
printf "%s\b" "${sp:i++%n:1}"
done
}

#loop here 'cause api server can be not reachable on start
wait_sys_pods() {
  echo -en "\n\033[43m [INFO] Waiting for Kubernetes system pods to start \033[0m\n\n"
  while true
    do
      kubectl -n kube-system wait --for=condition=ContainersReady --timeout=5m --all pods >>$LOGFILE 2>&1
      test $? -eq 0 && break;
      sleep 1
    done
  echo done
}

# Start spinner
spinner &

wait_sys_pods
kubectl proxy --port=8080 >>$LOGFILE 2>&1

echo -en "\n\n\033[43m [INFO] Kubernetes cluster information \033[0m\n\n"
kubectl cluster-info

echo -en "\n\n\033[43m [INFO] Kubernetes components status \033[0m\n\n"
kubectl get componentstatus

echo -en "\n\n\033[43m [INFO] Kubernetes namespaces \033[0m\n\n"
kubectl get namespaces

echo -en "\n\n\033[43m [INFO] Hostname \033[0m\n\n"
HOSTNAME=$(kubectl get nodes | awk 'NR == 2 {print $1}')
echo $HOSTNAME
echo

echo -en "\n\n\033[43m [INFO] Kubernetes describe node \033[0m\n\n"
kubectl describe node $HOSTNAME

echo -en "\n\n\033[43m [INFO] Kubernetes nodes \033[0m\n\n"
kubectl get nodes

echo -en "\n\n\033[43m [INFO] Kubernetes describe node in json format \033[0m\n\n"
kubectl get nodes $HOSTNAME -o json | jq

echo -en "\n\n\033[43m [INFO] Kubernetes describe node in yaml format \033[0m\n\n"
kubectl get nodes $HOSTNAME -o yaml

echo -en "\n\n\033[32m>>> Kubernetes create namespace \033[0m\n\n"
kubectl create namespace 42iot >>$LOGFILE 2>&1
kubectl get ns #namespaces shortcut

kubectl config set-context --current --namespace=42iot >>$LOGFILE 2>&1 # set default namespace as 42iot

# kubectl create -f {файл с описанием объекта} для создания объектов
# kubectl apply -f {файл с описанием объекта} для обновления объектов
# kubectl delete -f {файл с описанием объекта} для удаления объекта

kubectl apply -f ${FILEPATH}demo-deployment.yaml >>$LOGFILE 2>&1 # create deployment in 42iot namespace
kubectl get pods
kubectl get deployment
kubectl get replicaset
kubectl apply -f ${FILEPATH}demo-service.yaml >>$LOGFILE 2>&1 # create service in 42iot namespace
kubectl get service demo

# echo -en "\n\n\033[32m>>> Kubernetes show getting-started pod status \033[0m\n\n"
# kubectl get pod 
# echo


# Stop spinner
kill "$!"

