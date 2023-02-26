#!/bin/bash

LOGFILE=$0
FILEPATH=${LOGFILE:0:2}
FILEPATHLEN=`echo ${LOGFILE} | wc -m`
FILEPATHLEN=$(($FILEPATHLEN - 5))
if [ $FILEPATH = "./" ]; then
        LOGFILE=`pwd`${LOGFILE:1:$FILEPATHLEN}.log
fi

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

prepare_brew() {
    # Fetch the newest version of Homebrew and all formulas
    if [ $(brew update >>$LOGFILE 2>&1 | wc -l) == 1 ]; then
        echo -en "\b\033[32m[ OK ]\033[0m Brew already up-to-date\n"
    else
        echo -en "\b\033[43m[ OK ]\033[0m Brew update complete\n"
    fi

    # Enable brew autoupdate
    if [ $(brew autoupdate status | wc -l) != 5 ]; then
        brew autoupdate start
        echo -en "\033[43m[ OK ]\033[0m Brew autoupdate started\n"
    else
        echo -en "\033[32m[ OK ]\033[0m Brew autoupdate enabled\n"
    fi

    # Upgrade outdated casks and outdated, unpinned formulas
    brew upgrade >>$LOGFILE 2>&1 && \
    echo -en "\033[32m[ OK ]\033[0m Brew formulas upgraded\n"
}

# install_virtualbox() {
#     # Install virtualbox
#     if [ $(vboxmanage --version 2>>$LOGFILE | wc -l) == 0 ]; then
#         brew install --cask virtualbox >>$LOGFILE 2>&1
#         echo -en "\033[43m[ OK ]\033[0m VirtualBox was installed\n"
#     else
#         echo -en "\033[32m[ OK ]\033[0m VirtualBox ready\n"
#     fi
# }

# get_virtualbox_version() {
#     echo
#     echo -en "\033[43m*** VirtualBox version **********\033[0m\n"
#     echo
#     vboxmanage --version
# }

install_docker() {
    # Install docker
    if [ $(docker version 2>>$LOGFILE | wc -l) == 0 ]; then
        brew install --cask docker >>$LOGFILE 2>&1
        open /Applications/Docker.app
        sleep 10
        echo -en "\033[43m[ OK ]\033[0m Docker was installed\n"
    else
        echo -en "\033[32m[ OK ]\033[0m Docker ready\n"
    fi
}

get_docker_version() {
    echo
    echo -en "\033[43m*** Docker version **************\033[0m\n"
    echo
    docker version
}

install_minikube() {
    # Install minikube
    if [ $(minikube version --short 2>>$LOGFILE | wc -l) == 0 ]; then
        brew install minikube >>$LOGFILE 2>&1
        echo -en "\033[43m[ OK ]\033[0m Minikube was installed\n"
    else
        echo -en "\033[32m[ OK ]\033[0m Minikube ready\n"
    fi

    if [ $(kubectl get nodes | wc -l) == 1 ]; then
        minikube start >>$LOGFILE 2>&1
        echo "[[ $commands[kubectl] ]] && source <(kubectl completion zsh)" >> ~/.zshrc # add autocomplete permanently to your zsh shell
    fi
}

get_kubernetes_version() {
    echo
    echo -en "\033[43m*** Kubernetes version **********\033[0m\n"
    echo
    kubectl version --short
    minikube version
}

get_kubernetes_nodes() {
    echo
    echo -en "\033[43m*** Kubernetes nodes ************\033[0m\n"
    echo
    kubectl get nodes 2>>$LOGFILE
}

clean_brew() {
    # Uninstall no longer needed formulas
    brew autoremove

    # Remove old versions of installed formulas
    brew cleanup

    echo -en "\033[32m[ OK ]\033[0m Brew cleared\n"
}

environment_ready_message() {
    echo
    echo -en "\033[32m*********************************\033[0m\n"
    echo -en "\033[32m*       Environment ready       *\033[0m\n"
    echo -en "\033[32m*********************************\033[0m\n"
    echo
}

# Start spinner
spinner &
prepare_brew

# install_virtualbox
install_docker
install_minikube

clean_brew

# get_virtualbox_version
get_docker_version
get_kubernetes_version
get_kubernetes_nodes

environment_ready_message
# Stop spinner
kill "$!"