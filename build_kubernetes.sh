#!/bin/bash

K8S_VERSION=${K8S_VERSION:-1.2.3}
rm -rf kubernetes/source/kubernetes/v$K8S_VERSION
rm -f kubernetes/master/kubernetes-master-$K8S_VERSION-1.x86_64.rpm
rm -f kubernetes/master/kubernetes-node-$K8S_VERSION-1.x86_64.rpm

# 有墙存在，源码下载可能会出各种问题，可以自己直接下载源码后替换这段脚本
mkdir -p kubernetes/source/kubernetes/v$K8S_VERSION
cd kubernetes/source/kubernetes/v$K8S_VERSION
curl -L https://github.com/kubernetes/kubernetes/releases/download/v$K8S_VERSION/kubernetes.tar.gz | tar xvz
tar xfvz kubernetes/server/kubernetes-server-linux-amd64.tar.gz
cd ../../../../

# build_rpm_master
    # rpm
    # /lib/systemd/system

fpm -s dir -n "kubernetes-master" \
-p kubernetes/builds \
-C ./kubernetes/master -v $K8S_VERSION \
-d 'docker-engine >= 1.7.0' \
-t rpm --rpm-os linux \
-a x86_64 \
--after-install kubernetes/master/scripts/rpm/after-install.sh \
--before-install kubernetes/master/scripts/rpm/before-install.sh \
--after-remove kubernetes/master/scripts/rpm/after-remove.sh \
--before-remove kubernetes/master/scripts/rpm/before-remove.sh \
--config-files etc/kubernetes/master \
--license "Apache Software License 2.0" \
--maintainer "Chinacreator, Inc. <yilin.yan@chinacreator.com>" \
--vendor "Chinacreator, Inc." \
--description "Kubernetes master binaries and services" \
--url "http://www.c2cloud.cn" \
../source/kubernetes/v$K8S_VERSION/kubernetes/server/bin/kube-apiserver=/usr/bin/kube-apiserver \
../source/kubernetes/v$K8S_VERSION/kubernetes/server/bin/kube-controller-manager=/usr/bin/kube-controller-manager \
../source/kubernetes/v$K8S_VERSION/kubernetes/server/bin/kube-scheduler=/usr/bin/kube-scheduler \
../source/kubernetes/v$K8S_VERSION/kubernetes/server/bin/kubectl=/usr/bin/kubectl \
services/systemd/kube-apiserver.service=/lib/systemd/system/kube-apiserver.service \
services/systemd/kube-controller-manager.service=/lib/systemd/system/kube-controller-manager.service \
services/systemd/kube-scheduler.service=/lib/systemd/system/kube-scheduler.service \
etc/kubernetes/master/apiserver.conf \
etc/kubernetes/master/config.conf \
etc/kubernetes/master/controller-manager.conf \
etc/kubernetes/master/scheduler.conf \
etc/kubernetes/manifests


fpm -s dir -n "kubernetes-node" \
-p kubernetes/builds \
-C ./kubernetes/node -v $K8S_VERSION \
-d 'docker-engine >= 1.7.0' \
-a x86_64 \
-t rpm --rpm-os linux \
--after-install kubernetes/node/scripts/rpm/after-install.sh \
--before-install kubernetes/node/scripts/rpm/before-install.sh \
--after-remove kubernetes/node/scripts/rpm/after-remove.sh \
--before-remove kubernetes/node/scripts/rpm/before-remove.sh \
--config-files etc/kubernetes/node \
--license "Apache Software License 2.0" \
--maintainer "Chinacreator, Inc. <yilin.yan@chinacreator.com>" \
--vendor "Chinacreator, Inc." \
--description "Kubernetes node binaries and services" \
--url "http://www.c2cloud.cn" \
etc/kubernetes/node/config.conf \
etc/kubernetes/node/kubelet.conf \
etc/kubernetes/node/kube-proxy.conf \
services/systemd/kubelet.service=/lib/systemd/system/kubelet.service \
services/systemd/kube-proxy.service=/lib/systemd/system/kube-proxy.service \
../source/kubernetes/v$K8S_VERSION/kubernetes/server/bin/kubelet=/usr/bin/kubelet \
../source/kubernetes/v$K8S_VERSION/kubernetes/server/bin/kube-proxy=/usr/bin/kube-proxy \
etc/kubernetes/manifests
