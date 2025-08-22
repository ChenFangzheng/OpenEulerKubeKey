#!/bin/bash

# 禁用 Swap
swapoff -a
sed -i '/swap/s/^/#/' /etc/fstab

# 关闭防火墙
systemctl stop firewalld
systemctl disable firewalld


# 关闭 SELinux 脚本
setenforce 0

# 永久关闭 SELinux（需重启生效）
echo "配置永久关闭 SELinux..."
if [ -f /etc/selinux/config ]; then
    # 替换配置文件中的 SELINUX 选项
    sed -i 's/^SELINUX=enforcing$/SELINUX=disabled/' /etc/selinux/config
    sed -i 's/^SELINUX=permissive$/SELINUX=disabled/' /etc/selinux/config

    # 验证配置是否生效
    grep "^SELINUX=disabled$" /etc/selinux/config > /dev/null
    if [ $? -eq 0 ]; then
        echo "永久关闭配置成功，重启系统后生效"
    else
        echo "永久关闭配置失败，请手动检查 /etc/selinux/config"
    fi
else
    echo "/etc/selinux/config 文件不存在，无法配置永久关闭"
fi


#rpm -ivh $(pwd)/packages/*.rpm --force --nodeps

ansible-playbook -i hosts.ini install_k8s.yml