# AWS Two-Tier Web Application using Terraform

Provision a basic two-tier AWS architecture using Terraform. The project separates the public application tier from the private database tier.

> **Project status:** Infrastructure starter. The EC2 instance serves a simple HTML test page. Flask application and database integration are planned next steps, not included yet.

## Architecture

```text
                         Internet
                            |
                     Internet Gateway
                            |
                 Public Route Table
                            |
                    Public Subnet
                     EC2 (Amazon Linux)
                    HTTP : 80 / SSH : 22
                            |
                 Application SG allowed
                            |
                 Private Database Subnets
                    Amazon RDS MySQL
                       TCP : 3306
```

### AWS resources

- VPC with DNS support and hostnames
- One public subnet and two private subnets in separate Availability Zones
- Internet Gateway and public route table
- EC2 instance running Amazon Linux 2023
- RDS MySQL instance with a DB subnet group
- Security groups restricting SSH and database access
- Encrypted EC2 root volume and RDS storage

## Repository structure

```text
aws-two-tier-web-app-terraform/
├── terraform/
│   ├── provider.tf
│   ├── variables.tf
│   ├── vpc.tf
│   ├── security-groups.tf
│   ├── ec2.tf
│   ├── rds.tf
│   ├── outputs.tf
│   └── terraform.tfvars.example
├── .gitignore
└── README.md
```

## Prerequisites

1. An AWS account with permission to create VPC, EC2, security groups, and RDS resources.
2. AWS CLI configured with credentials (`aws configure`) or another supported AWS credential method.
3. Terraform CLI 1.5 or later.
4. Git.
5. Your public IPv4 address for restricting SSH access.

Check the tools:

```bash
aws --version
terraform version
git --version
```

## Deploy

Run the following commands from the `terraform/` directory.

### 1. Configure variables

Copy the example file:

**Linux/macOS:**
```bash
cp terraform.tfvars.example terraform.tfvars
```

**Windows PowerShell:**
```powershell
Copy-Item terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` and replace `admin_cidr` with your public IP followed by `/32`, for example `198.51.100.25/32`.

Set the database password as an environment variable. Do not commit it.

**Linux/macOS:**
```bash
export TF_VAR_db_password='ReplaceWithAStrongPassword!'
```

**Windows PowerShell:**
```powershell
$env:TF_VAR_db_password = "ReplaceWithAStrongPassword!"
```

Use a strong RDS-compatible password and avoid shell history exposure when working on shared systems.

### 2. Initialize and validate

```bash
terraform init
terraform fmt -recursive
terraform validate
```

### 3. Review and deploy

```bash
terraform plan
terraform apply
```

Review the plan and type `yes` only if the proposed resources and costs are acceptable.

### 4. Test the web tier

After deployment, Terraform prints `web_application_url`. Open that URL in a browser. You should see the initial EC2 test page.

The RDS endpoint is private. Connect to it from the application tier or another appropriately connected host; it is not intended to be opened directly from your laptop over the public internet.

## Security notes

- SSH is restricted to the IP address configured in `admin_cidr`. Do not use `0.0.0.0/0` for SSH.
- RDS is configured with `publicly_accessible = false`.
- The database security group permits MySQL port 3306 only from the EC2 security group.
- The database password is supplied using `TF_VAR_db_password`, but Terraform may still store it in state. Treat state files as secrets.
- The local state file is excluded from Git. For a team or longer-lived project, configure a secured remote state backend with encryption and appropriate access controls.
- This starter does not configure a NAT Gateway. The private subnets have no internet egress route.
- The EC2 user-data script is a basic HTTP test server, not a production web server.

## Cost and cleanup

EC2, RDS, public IPv4 addresses, storage, and data transfer may incur charges. Free Tier eligibility depends on your account, resource configuration, and current AWS pricing. Check the AWS Pricing Calculator and your Billing dashboard before deployment.

When finished, destroy the resources:

```bash
terraform destroy
```

Review the destroy plan and type `yes` to confirm. Verify in the AWS Console that the resources have been removed and check for any remaining billable resources.

## Roadmap

- [x] Provision VPC and subnet layout
- [x] Configure Internet Gateway and public routing
- [x] Provision EC2 web tier
- [x] Provision private RDS MySQL tier
- [x] Restrict traffic with security groups
- [ ] Deploy a Flask application
- [ ] Connect Flask to RDS and implement database operations
- [ ] Add monitoring and logging with CloudWatch
- [ ] Configure remote Terraform state
- [ ] Refactor infrastructure into reusable Terraform modules
- [ ] Add CI/CD pipeline

## Learning outcomes

This project demonstrates foundational AWS networking, EC2 provisioning, RDS isolation, security group design, Terraform variables, data sources, resource dependencies, outputs, and infrastructure lifecycle management.
