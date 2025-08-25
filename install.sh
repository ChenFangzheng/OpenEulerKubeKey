#!/bin/bash

# 禁用 Swap
swapoff -a
sed -i '/swap/s/^/#/' /etc/fstab

# 关闭防火墙
systemctl stop firewalld
systemctl disable firewalld

# 关闭 SELinux 脚本
setenforce 0

if [ ! -f "images/kube-apiserver-v1.29.3.tar" ]; then
  cat $PWD/images/images.zip.001 $PWD/images/images.zip.002 $PWD/images/images.zip.003 $PWD/images/images.zip.004 $PWD/images/images.zip.005 > $PWD/images/images.zip
  unzip $PWD/images/images.zip -d $PWD/images/
  rm -fr $PWD/images/images.zip
fi

ansible-playbook -i hosts.ini install_k8s.yml