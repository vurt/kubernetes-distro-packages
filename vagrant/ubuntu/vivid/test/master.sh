#!/bin/bash
echo "Installing Docker"
# echo `wget -qO- https://get.docker.com/ | sh`

echo "Installing etcd locally"
echo `dpkg -i /kubernetes/etcd/builds/systemd/etcd_2.0.11.0_amd64.deb`

sleep 1
echo "service etcd start..."
echo `service etcd start`

echo "Installing master $K8S_VERSION locally"
dpkg -P kubernetes-master
sleep 1
echo `dpkg -i /kubernetes/kubernetes/builds/systemd/kubernetes-master_"$K8S_VERSION".0_amd64.deb`

apt-get clean

echo "Running Services"
sleep 1
echo `service --status-all`

echo "service kube-apiserver start..."
echo `service kube-apiserver start`

echo "service kube-scheduler start..."
echo `service kube-scheduler start`

echo "service kube-controller-manager start..."
echo `service kube-controller-manager start`

echo "service kubelet start..."
echo `service kubelet start`

echo "service status with"
echo `service --status-all`
# service docker status

echo "waiting 5s for service start"
sleep 10

echo "Testing api server with curl http://localhost:8080/version"
echo `curl http://localhost:8080/version`