# #!/bin/bash

# while [ $(kubectl get nodes -o jsonpath='{range .items[*]}{@.metadata.name}:{range @.status.conditions[*]}{@.type}={@.status};{end}{end}'| tr ';' "\n"  | grep "Ready=True" | wc -l) != "2" ];
# do sleep 1 ;
# done

#!/bin/bash
LOG=/tmp/launch.log

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
    echo "\n[INFO] Waiting for Kubernetes system pods to start"
    while true; do
        kubectl -n kube-system wait --for=condition=ContainersReady --timeout=5m --all pods >>$LOG 2>&1
        test $? -eq 0 && break
        sleep 1
    done
    echo done
}

spinner &
wait_sys_pods
#stop spinner
kill "$!"

kubectl proxy --port=8080 &
