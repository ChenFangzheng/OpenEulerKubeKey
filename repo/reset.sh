#!/bin/bash

LOCAL_REPO_FILE="/etc/yum.repos.d/local.repo"
if [ -f "$RLOCAL_REPO_FILE" ]; then
    sudo rm -fr "$LOCAL_REPO_FILE"
fi

REPO_FILE="/etc/yum.repos.d/openEuler.repo"
REPO_BAK_FILE="/etc/yum.repos.d/openEuler.repo.bak"
# 检查文件是否存在
if [ ! -f "$REPO_FILE" ]; then
    if [ -f "$REPO_BAK_FILE" ]; then
      # 执行重命名操作
      sudo mv -f "$REPO_BAK_FILE" "$REPO_FILE"
    fi
 fi


sudo yum clean all
sudo yum makecache
yum repolist