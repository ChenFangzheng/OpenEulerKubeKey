使用该仓库部署Kubernetes集群的步骤如下（基于提供的配置和文件结构）：

### 前提条件
1. 确保目标主机均为 **openEuler 22.03 (LTS-SP4)** 系统（通过`00_check_os_version.yml`验证）。
2. 准备好Ansible控制节点，确保能通过SSH无密码访问所有目标主机（`hosts.ini`中定义的节点）。
3. 确保`hosts.ini`中配置的IP地址、角色参数（如`is_master`、`is_init`等）与实际环境一致。


### 部署步骤

#### 1. 准备仓库
将仓库克隆到Ansible控制节点，并进入仓库目录：
```bash
git clone <仓库地址> ansible-openeuler-k8s129
cd ansible-openeuler-k8s129
```


#### 2. 配置主机清单（已提供`hosts.ini`）
确认`hosts.ini`中的节点配置：
- `[k8s]`：Kubernetes集群节点，包含主节点（`is_master=1`）和工作节点（`is_worker=1`），其中`is_init=1`的节点为初始化节点（第一个主节点）。
- `[lb]`：负载均衡节点，通过keepalived和haproxy实现高可用，`lb_master=1`为MASTER角色，`lb_master=0`为BACKUP角色。
- `[test]`：测试节点（可选，用于执行测试任务）。


#### 3. 执行部署剧本
运行主部署剧本`install_k8s.yml`，该剧本会按顺序部署负载均衡、系统初始化、容器运行时和Kubernetes集群：
```bash
ansible-playbook -i hosts.ini install_k8s.yml
```

剧本执行流程说明：
1. **部署负载均衡（`[lb]`节点）**：
   - 安装haproxy和keepalived（`lb/01_install_pkgs.yml`）。
   - 配置haproxy转发Kubernetes API Server流量（`lb/02_haproxy.yml`）。
   - 配置keepalived实现VIP（虚拟IP）高可用（`lb/03_keepalived.yml`）。

2. **初始化系统环境（`[k8s]`节点）**：
   - 检查操作系统版本、配置yum源、安装基础依赖（`init`角色的系列任务）。
   - 禁用SELinux、防火墙、Swap，配置NTP时间同步、主机DNS和IPVS规则。
   - 修复openEuler系统特定bug（如sysctl配置、tmp.mount屏蔽）。

3. **安装容器运行时（`[k8s]`节点）**：
   - 部署containerd（`containerd`角色），配置系统d cgroup驱动和沙箱镜像。

4. **部署Kubernetes集群（`[k8s]`节点）**：
   - 安装kubeadm、kubelet、kubectl（`cluster/01_install_pkgs.yml`）。
   - 初始化集群（`cluster/02_init_cluster.yml`，仅`is_init=1`节点执行）。
   - 加入其他主节点（`cluster/03_add_master.yml`）和工作节点（`cluster/04_add_worker.yml`）。
   - 安装Helm工具（`cluster/05_install_helm.yml`）和Calico网络插件（`cluster/06_install_cni_calico.yml`）。


#### 4. 验证部署结果
在任意主节点（`is_master=1`）执行以下命令，确认集群状态：
```bash
# 查看节点状态
kubectl get nodes

# 查看系统组件状态
kubectl get pods -n kube-system

# 查看Calico网络插件状态
kubectl get pods -n calico-system
```


### 注意事项
- 若需调整集群参数（如Pod/Service CIDR、Kubernetes版本），可修改`roles/cluster/vars/main.yml`。
- 负载均衡的VIP（`192.168.161.29`）和节点IP在`roles/lb/vars/main.yml`中定义，需与实际网络环境匹配。
- 部署过程中若出现错误，可查看Ansible输出日志或目标节点上的临时日志文件（如`/tmp/kubeadm-init.log`）排查问题。