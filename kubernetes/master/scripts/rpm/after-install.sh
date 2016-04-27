#!/bin/bash
if [ $1 -eq 1 ] ; then

        chmod +x /usr/bin/kube-apiserver
        chmod +x /usr/bin/kube-scheduler
        chmod +x /usr/bin/kube-controller-manager

        chmod +x /usr/bin/kubectl

        # Initial installation
        systemctl preset kube-apiserver kube-scheduler kube-controller-manager >/dev/null 2>&1 || :
fi
