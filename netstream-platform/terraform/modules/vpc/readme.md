# 🚀 NetStream Jenkins CI/CD Infrastructure Platform

## 📌 Overview
This repository manages the cloud-native infrastructure automation for the **NetStream** platform. It implements a fully modular, reusable, and secure network hierarchy on AWS tailored specifically to run an isolated, high-availability Jenkins orchestrator engine with dynamic build agent workers.

---

## 📂 Core Repository Architecture

The platform separates **generic infrastructure blueprints (Modules)** from **real-world environment deployments (Environments)**.

```text
terraform/
 ├── environments/
 │    └── dev/
 │         ├── main.tf            # Root Module: Orchestrates and wires modules together
 │         ├── variables.tf       # Source of Truth: Absolute environment-specific data values
 │         └── outputs.tf         # Environment Output Gate: Prints IPs & endpoints on terminal
 └── modules/
      ├── vpc/
      │    ├── main.tf            # Isolates network boundaries, subnets, and gateways
      │    └── variables.tf       # Pure Contract: Declares expected parameters (Zero defaults)
      └── ec2/
           ├── main.tf            # Provisions Master & dynamic Agent compute blocks
           └── variables.tf       # Pure Contract: Declares compute inputs (Zero defaults)
```

---

## 🔄 Core Engineering Pattern: Modular Data Flow

To ensure this codebase can scale to `staging` and `production` environments without modification, **all hardcoded defaults have been completely stripped out of the underlying modules.** 

Data flows sequentially downward from your root file to the resource blocks:

```text
┌────────────────────────────────────────────────────────┐
│ 1. CONFIG LAYER (environments/dev/variables.tf)        │
│    Declares actual values: project_name = "netstream"  │
└───────────────────────────┬────────────────────────────┘
                            │ Pipes value into
                            ▼
┌────────────────────────────────────────────────────────┐
│ 2. ORCHESTRATION BRIDGE (environments/dev/main.tf)     │
│    Maps value parameter: project_name = var.project_name│
└───────────────────────────┬────────────────────────────┘
                            │ Liquidates value into
                            ▼
┌────────────────────────────────────────────────────────┐
│ 3. BLUEPRINT CONTAINER (modules/ec2/variables.tf)      │
│    Stands ready with blank input slots to receive data │
└───────────────────────────┬────────────────────────────┘
                            │ Executes configuration
                            ▼
┌────────────────────────────────────────────────────────┐
│ 4. RESOURCE INSTANCE (modules/ec2/main.tf)             │
│    Applies strings: Name = "netstream-dev-master"      │
└────────────────────────────────────────────────────────┘
```

---

## 🌐 Network Module Blueprint (VPC Deep Dive)

The VPC network carves up a parent `/16` network array into dedicated, isolated sub-tiers across three distinct Availability Zones (AZs) for high availability (`us-east-1a`, `us-east-1b`, `us-east-1c`).

```text
VPC CIDR Boundary: 10.0.0.0/16 (65,536 Addresses)
 ├── PUBLIC TIER   (10.0.1.0/24  - 10.0.3.0/24)  --> Internet Gateway (Public UI/Ingress Gate)
 │    └── [GAP]    (10.0.4.0/24  - 10.0.10.0/24) --> Padding Reserved for Future Expansion
 ├── PRIVATE TIER  (10.0.11.0/24 - 10.0.13.0/24) --> NAT Gateway (Secure Agent Execution Space)
 │    └── [GAP]    (10.0.14.0/24 - 10.0.20.0/24) --> Padding Reserved for Future Expansion
 └── DATABASE TIER (10.0.21.0/24 - 10.0.23.0/24) --> Zero Internet Access (Isolated Stateful Tier)
```

### Why We Built the Network This Way
* **Subnet Masking (`newbits = 8`)**: Extending the `/16` parent network mask by `8` bits yields localized **`/24` subnets**. This caps each network tier at **256 raw IPs** (251 usable due to AWS reserving the first 4 and final 1 IP mapping).
* **Strategic Padding Gaps (`+1`, `+11`, `+21`)**: Subnets are deliberately non-contiguous. If the topology requires expanding the Public Tier to a 4th or 5th availability zone later, those subnets can scale cleanly into slots 4 through 10 without causing catastrophic overlapping subnet address collisions with your private blocks.
* **NAT Gateway Architecture**: Deployed securely inside **Public Subnet 1**. This grants your private Jenkins Build Agents the ability to establish *outbound requests* to download code packages (npm, pip, maven) or system updates, while completely blocking unauthorized *inbound* traffic from hitting your build workloads.

---

## 💻 Compute Module Blueprint (EC2 Deep Dive)

The compute layers instantiate the discrete nodes tasked with handling pipeline execution orchestration.

```text
                                  ┌────────────────────────┐
                                  │   DEVELOPER BOUNDARY   │
                                  └───────────┬────────────┘
                                              │ Inbound port 8080 
                                              │ (Whitelisted via allowed_admin_cidr)
                                              ▼
┌────────────────────────────────────────────────────────────────────────────────────────┐
│ PUBLIC SUBNET [10.0.1.0/24]                                                            │
│                                                                                        │
│   ┌───────────────────────────────────┐                                                │
│   │    Jenkins Master Node            │                                                │
│   │    - Type: t3.medium              │                                                │
│   │    - Storage: 30GB gp3 (Encrypted)│                                                │
│   └─────────────────┬─────────────────┘                                                │
└─────────────────────┼──────────────────────────────────────────────────────────────────┘
                      │
                      │ Secure internal communication tunnel (JNLP/SSH)
                      ▼
┌────────────────────────────────────────────────────────────────────────────────────────┐
│ PRIVATE SUBNET [10.0.11.0/24]                                                          │
│                                                                                        │
│   ┌───────────────────────────────────┐                                                │
│   │    Jenkins Build Agent (Node 1)   │                                                │
│   │    - Type: t3.medium              │                                                │
│   │    - Subnet: Modulo balanced      │                                                │
│   └───────────────────────────────────┘                                                │
└────────────────────────────────────────────────────────────────────────────────────────┘
```

### Why We Built the Compute This Way
* **VPC-Compliant Security Bindings**: Compute structures utilize **`vpc_security_group_ids`** natively. This guarantees stable, drift-free deployments inside custom VPC parameters, preventing resource recreation loops caused by default-VPC fallback options.
* **Modulo Subnet Load Balancing**: The Agent profile leverages automated array index math: `var.private_subnet_ids[count.index % length(var.private_subnet_ids)]`. If you scale the cluster size up from 1 to 5 agents, Terraform mathematically distributes the instances across your available private network Availability Zones completely automatically.
* **Identity Isolation**: Master and Agent blocks maintain independent IAM profiles (`jenkins_master_iam_instance_profile_name` vs `jenkins_agent_iam_instance_profile_name`). This prevents build scripts executing on the agent machines from possessing master-level configuration keys or management rights over the AWS host platform.

---

## 🔒 Security Parameter Controls

### The `allowed_admin_cidr` Variable
The architecture relies on the `allowed_admin_cidr` block passed from the root variable manifest straight into your security group controllers. This ensures that the main administrative portal (Port `8080`) is locked down to your corporate proxy or domestic IP space, shielding the automation controller from continuous public-internet brute-force vectors.

---

## ⚙️ Module Interface References

### Unified Input Controls

| Parameter Name | Target Scope | Description | Required |
| :--- | :--- | :--- | :--- |
| `project_name` | Global | Common core naming token string used across all tags | **Yes** |
| `environment` | Global | Active deployment stage identifier string (dev, staging, prod) | **Yes** |
| `aws_region` | Global | Explicit AWS Region targeted for provider execution | **Yes** |
| `cidr_block` | VPC Module | Base IPv4 CIDR allocation block for core VPC network | **Yes** |
| `availability_zones`| VPC Module | List array of targeted AZ zones for subnet distribution | **Yes** |
| `allowed_admin_cidr`| Security/VPC | Secure network whitelist block permitted to access UI portals | **Yes** |
| `instance_type` | EC2 Module | AWS Compute size template configuration code for nodes | **Yes** |
| `volume_size` | EC2 Module | Numerical capacity target in GB assigned for root gp3 disks | **Yes** |

### Platform Outputs
* `jenkins_master_management_url`: Directly constructs the `http://<public_ip>:8080` entry string inside the root level outputs for immediate platform operations management access.
* `jenkins_agent_private_ips`: Aggregates the internal private IP addresses of all multi-AZ worker nodes dynamically into a clean array list using splat (`[*]`) resource reference patterns.
