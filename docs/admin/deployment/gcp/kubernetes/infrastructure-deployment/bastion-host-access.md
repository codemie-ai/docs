---
id: infrastructure-bastion-host-access
title: Bastion Host Access Configuration
sidebar_label: Bastion Host Access (Optional)
sidebar_position: 3
pagination_prev: admin/deployment/gcp/kubernetes/infrastructure-deployment/infrastructure-manual-deployment
pagination_next: admin/deployment/gcp/kubernetes/components-deployment/components-deployment-overview
---

# Bastion Host Access Configuration

:::warning Private Cluster Only
This section is only required if you deployed a **completely private GKE cluster** with private DNS. For public clusters or clusters with authorized networks configured, you can access the GKE API and CodeMie application directly from your workstation.
:::

The Bastion Host is a secure jump server that provides access to your private GKE cluster and applications running inside the VPC. This VM enables both command-line management (SSH) and browser-based access (RDP) to internal resources.

### Connection Methods Overview

| Connection Type | Use Case                                                      | Access Method         |
| --------------- | ------------------------------------------------------------- | --------------------- |
| **SSH**         | Deploy and manage Kubernetes workloads using kubectl and Helm | Terminal/SSH client   |
| **RDP**         | Access web UIs exposed via private DNS (Kibana, Keycloak)     | Remote Desktop client |

### Option 1: SSH Connection for Cluster Management

Use SSH to connect to the Bastion Host for deploying and managing Kubernetes resources.

1. Retrieve the SSH command from Terraform outputs and connect:

```bash
# Get the SSH connection command
terraform output bastion_ssh_command

# Example output:
# gcloud compute ssh bastion-vm --project=your-project --zone=europe-west3-a

# Use this command to connect
gcloud compute ssh bastion-vm --project=your-project --zone=europe-west3-a
```

:::tip IAM Permissions
Ensure your user account is listed in `bastion_members` variable from Phase 2 configuration. Only authorized users can SSH into the Bastion Host.
:::

#### Step 2: Set user password (Required for RDP)

After connecting via SSH, set a password for the `ubuntu` user for later RDP access:

```bash
# Set password for the ubuntu user (you'll be prompted to enter it twice)
sudo passwd ubuntu
```

:::info Save Your Password
The `ubuntu` user password you set here will be used to login via RDP. Make sure to remember it or store it securely.
:::

3. Fetch GKE cluster credentials to enable kubectl commands:

```bash
# Get the kubectl configuration command
terraform output get_kubectl_credentials_for_private_cluster

# Example output:
# gcloud container clusters get-credentials your-cluster-name --region=europe-west3 --project=your-project

# Run the command to configure kubectl
gcloud container clusters get-credentials your-cluster-name --region=europe-west3 --project=your-project
```

4. Transfer the Helm charts repository to the Bastion Host.

:::warning VPN Required for gitbud.epam.com
`gitbud.epam.com` is only accessible through VPN and is not reachable from the Bastion Host directly. Clone the repository on your local machine first, then transfer it using `gcloud scp`.
:::

On your **local machine** (with VPN active):

```bash
git clone https://gitbud.epam.com/epm-cdme/codemie-helm-charts.git
```

Then transfer the cloned directory to the Bastion Host:

```bash
gcloud compute scp --recurse ./codemie-helm-charts bastion-vm:~/ \
  --project=your-project --zone=europe-west3-a
```

On the **Bastion Host**, navigate to the transferred directory:

```bash
cd ~/codemie-helm-charts
```

You're now ready to proceed with [Components Deployment](../components-deployment/index.md).

### Option 2: RDP Connection for Web UI Access

Use RDP to access application web interfaces that are only available via private DNS (such as Kibana, Keycloak Admin Console).

:::tip When to Use RDP
RDP is useful when you need to access web-based administrative interfaces that aren't exposed publicly. For kubectl/Helm operations, SSH access is sufficient.
:::

1. Retrieve the RDP forwarding command from Terraform outputs and start the IAP tunnel:

```bash
# Get the RDP forwarding command
terraform output bastion_rdp_command

# Example output:
# gcloud compute start-iap-tunnel bastion-vm 3389 --local-host-port=localhost:3389 --zone=europe-west3-a --project=your-project
```

Run the command to create an IAP tunnel that forwards RDP traffic (keep this terminal open):

```bash
gcloud compute start-iap-tunnel bastion-vm 3389 \
  --local-host-port=localhost:3389 \
  --zone=europe-west3-a \
  --project=your-project
```

2. Open your Remote Desktop client and connect:

| Setting      | Value                      |
| ------------ | -------------------------- |
| **Computer** | `localhost:3389`           |
| **Username** | `ubuntu`                   |
| **Password** | Password set in SSH Step 2 |

### Tips for Using the Bastion Host

#### Pasting Commands into Terminal

Use the correct keyboard shortcut for pasting in Linux terminal:

```
Shift + Ctrl + V
```

(Regular `Ctrl + V` won't work in most Linux terminal applications)

#### File Transfer to/from Bastion

Transfer files between your local machine and Bastion using `gcloud scp`:

```bash
# Upload file to Bastion
gcloud compute scp local-file.txt bastion-vm:~/remote-file.txt \
  --project=your-project --zone=europe-west3-a

# Download file from Bastion
gcloud compute scp bastion-vm:~/remote-file.txt ./local-file.txt \
  --project=your-project --zone=europe-west3-a
```
