# 🚀 Homelab Production Roadmap: "Zero to GitOps"

This document outlines the end-to-end strategy for building a professional-grade, automated homelab using a 4-node Proxmox cluster (1 x Management Tower, 3 x Mini-PC Compute Nodes).

#### Basic Overview
1. Configure Unifi with Terraform
2. Bootstrap bare metal using netbootxyz
3. Configure proxmox template with Packer
4. Create ansible vm using Terraform using the Packer template
5. Configure Proxmox Cluster with Ansible
6. Stand up k3s vm's using Packer
7. Setup k3s cluster using Ansible


---

## 🏗️ Stage 1: The Hardware Foundation
*Goal: Convert raw metal into an automated fleet.*

1. **Manual Install:** Flash Proxmox VE onto all 4 nodes.
2. **Networking:**
    - Set up `vmbr0` (Bridge) and required VLANs.
    - **Tower Special:** Configure a **Linux Bond (LACP)** for the 4x2.5GbE ports to maximize storage throughput.
3. **Ansible "First Strike":** Run a bootstrap playbook from your local machine to:
    - Install `proxmoxer` (required for Proxmox API interaction).
    - Remove "No Subscription" nag and enable `pve-no-subscription` repos.
    - Execute `apt update && apt upgrade -y`.
    - Install base tools: `vim`, `tmux`, `fail2ban`, `htop`.
    - Inject your SSH Public Key for passwordless `root` access.

---

## 🎮 Stage 2: The "Control Room" (Management Host)
*Goal: Build the "Brain" on the high-resource Tower.*

1. **Storage & Backups:** Provision a **TrueNAS** VM and a **Proxmox Backup Server (PBS)** LXC/VM.
2. **The Management VM:** A dedicated Ubuntu/Debian instance hosting:
    - **Semaphore UI:** Central web engine to trigger Ansible tasks.
    - **BIND9:** Authoritative DNS for internal domains (e.g., `lab.yourdomain.com`).
    - **Gitea:** Local Git "Source of Truth" (mirrored to GitHub).
3. **DNS Chaining:** - **Router:** Points to **AdGuard Home** (filtering).
    - **AdGuard Home:** Forwards local queries to **BIND9** for internal resolution.

---

## ☁️ Stage 3: The "Compute" Provisioning (IaC)
*Goal: Use Code to spawn your cluster nodes.*

1. **Terraform/OpenTofu:** Use a script to provision three identical VMs across your Mini-PCs.
2. **Cloud-Init:** Automatically inject usernames, SSH keys, and static IP settings upon first boot.
3. **Ansible RKE2/K3s Install:** Trigger a Semaphore task to:
    - Install **RKE2** (Enterprise-grade Kubernetes).
    - Assign "Server" (Master) and "Agent" (Worker) roles.
    - Export the `kubeconfig` to your Management VM.

---

## ⚓ Stage 4: The "GitOps" Bootstrap
*Goal: Make the cluster self-healing and code-driven.*

1. **ArgoCD:** Deploy ArgoCD to the cluster. This becomes the "Auto-Deployer."
2. **The "App-of-Apps" Pattern:** Point ArgoCD to your GitHub repo. It will automatically deploy:
    - **Cilium:** eBPF-based high-performance networking.
    - **Longhorn:** Distributed storage across Mini-PC NVMe drives.
    - **Cert-Manager:** Automated SSL via Let's Encrypt.
3. **Sealed Secrets:** Deploy the Sealed Secrets controller to safely commit encrypted passwords to your public Git repo.

---

## 🚀 Stage 5: The Application Layer
*Goal: Deploy services with zero manual clicking.*

1. **The Migration:** Deploy Mealie, Immich, Gatus, etc., via Helm charts managed by ArgoCD.
2. **External-DNS:** Automate DNS creation; as soon as an app is added to Git, **External-DNS** creates the record in **BIND9**.
3. **Hardware Passthrough:** - Configure RKE2 nodes to utilize the **Intel Arc GPU** on the Tower for transcoding.
    - Utilize **Remote ML** for Immich to offload AI tasks to the Tower.

---

## 🛠️ Stage 6: Observability & Maintenance
*Goal: Hands-off maintenance and monitoring.*

1. **Monitoring:** Deploy **Grafana Alloy** via ArgoCD to aggregate logs/metrics into central dashboards.
2. **Security:** Use Ansible to deploy **Wazuh agents** to all hosts to monitor for threats.
3. **Auto-Updates:** Schedule a Semaphore task to:
    - Patch OS on all nodes every Sunday.
    - Perform a rolling reboot of the RKE2 cluster.
    - Validate health via Gatus alerts.

---

## 🏆 The "Production" Outcome
**Scenario:** A Mini-PC physically fails.
1. **Replace:** Plug in a new Mini-PC.
2. **OS:** Install Proxmox (Manual).
3. **Bootstrap:** Run **Ansible** "First Strike."
4. **Provision:** Run **Terraform** script.
5. **Recovery:** **ArgoCD** detects the new node and automatically redeploys apps and data.
