#!/bin/bash
echo "Installing Docker"
echo `wget -qO- https://get.docker.com/ | sh`

echo "Installing node $K8S_VERSION locally"
dpkg -P kubernetes-node
echo `dpkg -i /kubernetes/kubernetes/builds/systemd/kubernetes-node_"$K8S_VERSION".0_amd64.deb`

apt-get clean
sleep 3

echo "Running Services"
echo "service kube-proxy start ..."
echo `service kube-proxy start`

echo "service kubelet start ..."
echo `service kubelet start`

echo "service status with"
echo `service --status-all`

sleep 5
echo "Testing api server with curl http://192.168.200.2:8080/api/v1/nodes"
echo `curl http://192.168.200.2:8080/api/v1/nodes`

sleep 1
echo "Testing api server pod.."
echo `curl -X POST -d @/kubernetes/kubernetes/source/kubernetes/v"$K8S_VERSION"/kubernetes/examples/guestbook-go/redis-master-controller.json http://192.168.200.2:8080/api/v1/namespaces/default/replicationcontrollers --header "Content-Type:application/json"`
echo `curl -X POST -d @/kubernetes/kubernetes/source/kubernetes/v"$K8S_VERSION"/kubernetes/examples/guestbook-go/redis-master-service.json http://192.168.200.2:8080/api/v1/namespaces/default/services --header "Content-Type:application/json"`
