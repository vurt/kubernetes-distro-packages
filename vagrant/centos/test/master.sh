echo "Installing etcd locally"
echo `yum -y --nogpgcheck localinstall /kubernetes/etcd/builds/etcd-2.0.11-1.x86_64.rpm`
echo "systemctl start etcd..."
echo `systemctl start etcd`

echo "Installing master $K8S_VERSION locally"
echo `yum -y --nogpgcheck localinstall /kubernetes/kubernetes/builds/kubernetes-master-"$K8S_VERSION"-1.x86_64.rpm`

yum clean expire-cache

echo "Running Services"
echo "systemctl start kube-apiserver..."
echo `systemctl start kube-apiserver`

echo "systemctl start kube-scheduler..."
echo `systemctl start kube-scheduler`

echo "systemctl start kube-controller-manager..."
echo `systemctl start kube-controller-manager`

echo "systemctl start kubelet..."
echo `systemctl start kubelet`

echo "service status with"
echo `systemctl list-units -t service`

echo "waiting 5s for service start"
sleep 5

echo "Testing api server with curl http://localhost:8080/version"
echo `curl http://localhost:8080/version`
