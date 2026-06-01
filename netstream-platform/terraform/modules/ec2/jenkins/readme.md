# 💻 Amazon EC2 Jenkins Compute Module

## 📌 Overview
This module provisions the compute topology for the **NetStream** CI/CD platform. It deploys a single, publicly accessible Jenkins Master orchestrator node alongside an extensible cluster of private Jenkins Build Agents (Workers). 

The module is engineered to separate concerns completely, applying distinct firewall states, identity tokens, and scaling lifecycles to each node type.

---

## 🏗️ Compute Topology & Traffic Layout

```text
                                  ┌────────────────────────┐
                                  │   DEVELOPER BOUNDARY   │
                                  └───────────┬────────────┘
                                              │ Inbound port 8080 
                                              │ (Whitelisted via allowed_admin_cidr)
                                              ▼
┌────────────────────────────────────────────────────────────────────────────────────────┐
│ PUBLIC SUBNET [10.0.1.0/24] (Public Tier)                                              │
│                                                                                        │
│   ┌───────────────────────────────────┐                                                │
│   │    Jenkins Master Node            │                                                │
│   │    - Type: var.instance_type      │                                                │
│   │    - Subnet Index: [0]            │                                                │
│   │    - Profile: Master IAM Profile  │                                                │
│   └─────────────────┬─────────────────┘                                                │
└─────────────────────┼──────────────────────────────────────────────────────────────────┘
                      │
                      │ Secure internal network tunnel (JNLP Port 50000 / SSH)
                      ▼
┌────────────────────────────────────────────────────────────────────────────────────────┐
│ PRIVATE SUBNETS [10.0.11.0/24 - 10.0.13.0/24] (Private Tier)                            │
│                                                                                        │
│   ┌───────────────────────────────────┐     ┌───────────────────────────────────┐      │
│   │    Jenkins Agent Node 1           │     │    Jenkins Agent Node 2 (Future)  │      │
│   │    - Subnet Index: [0] (AZ-A)     │     │    - Subnet Index: [1] (AZ-B)     │      │
│   │    - Profile: Agent IAM Profile   │     │    - Profile: Agent IAM Profile   │      │
│   └───────────────────────────────────┘     └───────────────────────────────────┘      │
└────────────────────────────────────────────────────────────────────────────────────────┘
```

---

## 🔍 Deep Dive: Core Engineering Decisions

### 1. Master/Agent Network Separation
* **Jenkins Master**: Deployed directly in the Public Subnet tier (`var.public_subnet_ids[0]`). This allows developers to securely access the management console on port `8080` from outside the VPC while ensuring it remains bounded by security group whitelists.
* **Jenkins Agents**: Deployed exclusively inside the Private Subnet tier. Build jobs, unit tests, and compilation steps run hidden from the public internet. This significantly reduces the vector footprint for unauthorized code execution.

### 2. Automated Modulo Subnet Balancing (`count.index`)
The agent resource block is future-proofed using programmatic subnet mapping:
```hcl
subnet_id = var.private_subnet_ids[count.index % length(var.private_subnet_ids)]
```
* **Why:** If the infrastructure requires scaling out from 1 agent to 3, 6, or more nodes, you only need to change the `count` attribute. 
* **How it works:** Terraform automatically evaluates the modulo math. It cycles the nodes sequentially across your private subnets (`AZ-A`, `AZ-B`, `AZ-C`), ensuring your build workloads are balanced evenly across independent physical data centers.

### 3. Dynamic Tag Indexing
The worker instances feature an automated tracking index in their metadata configuration:
```hcl
Name = "\${var.project_name}-\({var.environment}-jenkins-agent-\){count.index + 1}"
```
This produces clean, incremental naming strings (e.g., `netstream-dev-jenkins-agent-1`) inside the AWS Management Console, making resource tracking, monitoring, and operations grouping seamless.

### 4. Identity Isolation (IAM Roles)
* **Master Profile** (`jenkins_master_iam_instance_profile_name`): Granted distinct permissions like snapshotting, cluster orchestration, or backup interaction.
* **Agent Profile** (`jenkins_agent_iam_instance_profile_name`): Limited to assuming temporary deployment roles or pulling images from Amazon ECR. This strict boundary ensures that if a build job running on an agent is compromised, the attacker cannot steal master-level management keys.

---

## ⚙️ Module Input Reference

These variables represent the inputs that must be passed down from your root orchestrator context into this compute folder. **No default environment values are hardcoded here.**


| Name | Type | Description | Required |
| :--- | :--- | :--- | :--- |
| `project_name` | `string` | Base project prefix used for uniform resource naming tags | **Yes** |
| `environment` | `string` | Operational tier designation (e.g., dev, staging, prod) | **Yes** |
| `aws_region` | `string` | The targeted AWS region used to validate AMI lookup mapping | **Yes** |
| `instance_type` | `string` | The system compute sizing template (e.g., `t3.medium`) | **Yes** |
| `volume_size` | `number` | Size of the root gp3 storage disk allocated in Gigabytes | **Yes** |
| `public_subnet_ids` | `list(string)`| Clean list array of public subnet IDs passed from the VPC | **Yes** |
| `private_subnet_ids`| `list(string)`| Clean list array of private subnet IDs passed from the VPC | **Yes** |
| `jenkins_master_sg_id` | `string` | Firewall ID restricting input traffic to the Master node | **Yes** |
| `jenkins_agent_sg_id` | `string` | Firewall ID restricting internal network traffic to the Workers | **Yes** |
| `jenkins_master_iam_instance_profile_name` | `string` | IAM instance profile string attached to the Master node | **Yes** |
| `jenkins_agent_iam_instance_profile_name` | `string` | IAM instance profile string attached to the Agent workers | **Yes** |
| `ami_map` | `map(string)` | Regional dictionary containing Canonical Ubuntu 24.04 LTS AMIs | No (Defaults provided) |

---

## 📤 Module Output Reference

These elements expose the running states of your infrastructure back up to your root ecosystem:

* `jenkins_master_instance_id`: The distinct AWS tracking string of the Master server.
* `jenkins_master_public_ip`: The address used by whitelisted developers to connect to the UI dashboard.
* `jenkins_master_private_ip`: The internal VPC network address used by agents to check in.
* `jenkins_agent_instance_ids`: An aggregated array list tracking all deployed worker machine IDs.
* `jenkins_agent_private_ips`: The internal network array tracking where workers reside inside the subnets.
