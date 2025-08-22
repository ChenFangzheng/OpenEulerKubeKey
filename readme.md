这个仓库是一个基于Ansible的自动化部署工具，主要用于在openEuler 22.03 LTS 系统上部署Kubernetes（k8s）1.29版本集群。以下是其关键信息介绍：

### 核心结构
- **核心配置文件**：包含`ansible.cfg`（Ansible配置文件）、`hosts.ini`（主机清单）、`install_k8s.yml`（主部署剧本）。
- **角色（roles）目录**：实现核心功能，包含多个子角色：
  - `cluster`：负责Kubernetes集群相关操作，如安装kubeadm、kubelet、kubectl，初始化集群，添加主节点和工作节点，安装Helm和Calico CNI等。
  - `docker`：安装和配置容器运行时docker，包括下载安装包、生成配置、设置沙箱镜像等。
  - `init`：进行系统初始化操作，如检查操作系统版本、配置yum源、安装基础软件包、设置NTP、禁用SELinux、关闭防火墙、禁用swap等。
  - `lb`：负责负载均衡相关配置，安装keepalived和haproxy，生成对应的配置文件并启动服务，为Kubernetes API Server等提供负载均衡。
  - `test`：包含一些测试任务，用于部署过程中的测试验证。
- **其他文件**：包括各类安装包（如`docker-25.0.0.tgz`、`helm-v3.15.0-linux-amd64.tar.gz`等）、仓库配置文件（`openEuler.repo`）、部署脚本（`install.sh`）及说明文档（`install.md`、`readme.md`）等。

### 主要功能
1. **环境准备**：通过`init`角色对目标主机进行系统环境初始化，确保满足Kubernetes部署的前提条件。
2. **容器运行时部署**：可通过`docker`角色安装和配置对应的容器运行时。
3. **负载均衡配置**：通过`lb`角色部署haproxy和keepalived，实现Kubernetes控制平面的负载均衡和高可用。
4. **Kubernetes集群部署**：通过`cluster`角色完成Kubernetes集群的初始化，包括安装相关组件、初始化主节点、添加其他节点，以及安装网络插件和包管理工具等。

### 部署相关
- **主机清单配置**：`hosts.ini`文件定义了集群的主机信息，包括k8s节点（区分主节点和工作节点）、负载均衡节点（lb）和测试节点（test），并指定了相关属性。
- **部署步骤**：克隆仓库到Ansible控制节点，配置`hosts.ini`，运行`install_k8s.yml`剧本即可按照预设的角色和任务流程自动化部署集群。

通过该仓库，能够提高在openEuler系统上部署Kubernetes集群的效率和一致性。