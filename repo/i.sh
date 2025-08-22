#!/bin/bash

rpm -ivh $(pwd)/*.rpm

CURRENT_DIR=$(pwd)
cp -f $CURRENT_DIR/local.repo /etc/yum.repos.d/local.repo

# 替换baseurl中的local为当前目录
# 匹配格式如: baseurl=file:///local/packages/
sed -i "s|file:///local/|file://$CURRENT_DIR/|g" /etc/yum.repos.d/local.repo

rm -fr $PWD/packages/repodata
 # 为镜像目录生成元数据（递归处理子目录）
sudo createrepo --database $PWD/packages/

REPO_FILE="/etc/yum.repos.d/openEuler.repo"
# 检查文件是否存在
if [ -f "$REPO_FILE" ]; then
    # 定义新的文件名，添加.bak后缀作为备份
    NEW_FILE="${REPO_FILE}.bak"
    # 执行重命名操作
    sudo mv -f "$REPO_FILE" "$NEW_FILE"
 fi

sudo yum clean all
sudo yum makecache
yum repolist