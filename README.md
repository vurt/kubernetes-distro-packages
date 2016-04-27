# Kubernetes Linux Distribution Packages Builder (RedHat 7, CentOS 7)

## 编译

### 编译环境依赖

Kubernetes编译依赖`rpm-build`和`fpm`

```shell
  # 安装rpm-build
  yum install rpm-build
  # 安装fpm
  yum install ruby-devel gcc make
  gem install fpm 
  # 如果安装报https相关错误，可以使用 gem install fpm --source http://rubygems.org
```

### 准备kubernetes源码

由于墙的存在，脚本内置的release包下载可能会出各种问题，可以通过其他姿势下载后按`build_kubernetes.sh`中的相关脚本调整源码位置

### 编译之

```shell
  K8S_VERSION=1.2.3 ./build_kubernetes.sh
```
rpm包会生成在kubernetes/builds目录下

### Vagrant Smoke tests
- CentOS
```
$ cd vagrant/centos; vagrant destroy && vagrant up
$ vagrant ssh master
$ sudo K8S_VERSION=1.2.3 /vagrant/test/master.sh
$ vagrant ssh node
$ sudo K8S_VERSION=1.2.3 /vagrant/test/node.sh
```

## 安装

* 安装配置etcd、docker、网络组件
* Master： `yum localinstall kubernetes-master-1.2.3-1.x86_64.rpm`
* Minion： `yum localinstall kubernetes-node-1.2.3-1.x86_64.rpm`
