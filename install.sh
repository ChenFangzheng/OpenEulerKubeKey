#!/bin/bash

# 禁用 Swap
swapoff -a
sed -i '/swap/s/^/#/' /etc/fstab

# 关闭防火墙
systemctl stop firewalld
systemctl disable firewalld

# 关闭 SELinux 脚本
setenforce 0

ansible-playbook -i hosts.ini install_k8s.yml