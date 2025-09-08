# Azure Sentinel Scale 🛡️

> Enterprise-grade Azure Virtual Machine Scale Set with Automated Security Validation, Cost Optimization, and Compliance Monitoring

[![Terraform](https://img.shields.io/badge/Terraform-1.0+-7B42BC.svg?logo=terraform)](https://www.terraform.io)
[![Azure](https://img.shields.io/badge/Azure-Cloud-0078D4.svg?logo=microsoft-azure)](https://azure.microsoft.com)
[![TFSec](https://img.shields.io/badge/Security-TFSec-green.svg)](https://github.com/aquasecurity/tfsec)
[![Infracost](https://img.shields.io/badge/Cost-Infracost-orange.svg)](https://www.infracost.io)
[![TFLint](https://img.shields.io/badge/Linting-TFLint-blue.svg)](https://github.com/terraform-linters/tflint)

## 📊 Overview

Azure Sentinel Scale is a comprehensive infrastructure-as-code solution that deploys a secure, cost-optimized Azure VM Scale Set with built-in security validation, compliance checking, and cost management. This isn't just another VMSS deployment—it's a complete DevOps workflow with enterprise-grade safeguards.

## 🚀 Features

### 🔒 Security First
- **Automated Security Scanning**: Integrated TFSec with custom rules
- **Network Security Groups**: Pre-configured with minimal required rules
- **Compliance Ready**: Built-in checklists and validation workflows
- **Custom Security Rules**: Extensible security policy framework

### 💰 Cost Optimized
- **Real-time Cost Estimation**: Infracost integration for immediate cost visibility
- **Auto-scaling**: CPU-based scaling to optimize resource utilization
- **Cost Reporting**: Detailed breakdowns and optimization recommendations
- **Budget Awareness**: Monthly cost tracking and alerts

### 🛠️ DevOps Ready
- **Infrastructure as Code**: Complete Terraform configuration
- **Validation Pipeline**: Automated testing and security scanning
- **Code Quality**: TFLint integration for best practices
- **Documentation**: Comprehensive guides and checklists

## 📁 Project Structure

```
azure-sentinel-scale/
├── infrastructure/          # Terraform configurations
│   ├── main.tf             # Primary VM Scale Set configuration
│   ├── variables.tf        # Input variables
│   ├── outputs.tf          # Output values
│   ├── providers.tf        # Terraform providers
│   ├── network.tf          # Network infrastructure
│   ├── loadbalancer.tf     # Load balancer configuration
│   ├── autoscale.tf        # Auto-scaling rules
│   ├── security.tf         # Network security group
│   ├── tflint.hcl          # TFLint configuration
│   └── terraform.lock.hcl  # Provider version lock
├── security/               # Security scanning & reports
│   ├── .tfsec.yml          # Custom TFSec rules
│   ├── tfsec-report.sarif  # Default security report
│   └── tfsec-custom-report.sarif  # Custom rules report
├── cost-optimization/      # Cost analysis & reports
│   └── infracost-breakdown.txt  # Cost estimation report
├── scripts/                # Automation scripts
│   ├── install_nginx.sh    # VM initialization script
│   ├── validate.sh         # Comprehensive validation script
│   └── validate-v2.sh      # Alternative validation script
├── docs/                   # Documentation
├── compliance/             # Compliance checklists
├── .gitignore             # Git ignore rules
└── README.md              # This file
```

## ⚡ Quick Start

### Prerequisites
- **Terraform** >= 1.0
- **Azure CLI** (authenticated)
- **TFSec**, **TFLint**, **Infracost**
- Azure subscription with sufficient permissions

### Deployment

```bash
# Clone the repository
git clone https://github.com/your-username/azure-sentinel-scale.git
cd azure-sentinel-scale

# Initialize and deploy
cd infrastructure
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

### Validation & Security Scanning

```bash
# Run comprehensive validation
cd scripts
./validate.sh

# Or run individual checks
tflint ../infrastructure/          # Code linting
tfsec ../infrastructure/           # Security scanning
infracost breakdown --path ../infrastructure/  # Cost analysis
```

## 🛡️ Security Features

### Built-in Protection
- **SSH Access Control**: Secure SSH configuration on port 22
- **HTTP Security**: Controlled web access on port 80
- **Network Security Groups**: Minimal required inbound rules
- **Standard Load Balancer**: Enhanced security features

### Automated Scanning
```bash
# Default security checks
tfsec ../infrastructure/ --format sarif > security/tfsec-report.sarif

# Custom compliance rules  
tfsec ../infrastructure/ --config-file security/.tfsec.yml --format sarif > security/tfsec-custom-report.sarif
```

## 💵 Cost Management

### Estimated Monthly Cost: ~$29
- **VM Instances**: $15.18
- **Storage**: $3.07
- **Load Balancer**: $7.30
- **Public IP**: $3.65

### Cost Optimization
- Auto-scaling (2-5 instances based on CPU utilization)
- Regular cost reporting via Infracost
- Budget monitoring recommendations
- Resource tagging for cost tracking

## ⚙️ Configuration

### Key Variables
```hcl
variable "admin_password" {
  description = "Admin password for the VMs"
  type        = string
  sensitive   = true
}

variable "vm_sku" {
  description = "VM size"
  default     = "Standard_B2s"
}

variable "instance_count" {
  description = "Initial number of instances"
  default     = 2
}
```

### Auto-scaling Rules
- **Scale Out**: CPU > 75% for 5 minutes
- **Scale In**: CPU < 25% for 5 minutes
- **Cooldown**: 1 minute between scaling operations

## 📊 Outputs

```hcl
output "loadbalancer_public_ip" {
  value = azurerm_public_ip.main.ip_address
}

output "loadbalancer_dns_name" {
  value = azurerm_public_ip.main.domain_name_label
}

output "vmss_id" {
  value = azurerm_linux_virtual_machine_scale_set.main.id
}
```

## 🔧 Customization

### Modify VM Size
```hcl
# In terraform.tfvars
vm_sku = "Standard_B2ms"
```

### Adjust Scaling
Edit `infrastructure/autoscale.tf` to modify:
- CPU thresholds
- Instance limits
- Cooldown periods

### Add Applications
Update the custom data script in `scripts/install_nginx.sh` to deploy your applications.

## 🧹 Cleanup

```bash
# Destroy all resources
cd infrastructure
terraform destroy

# Remove local files
rm -rf .terraform terraform.tfstate*
```

## 📝 Compliance Checklist

See `compliance/CHECKLIST.md` for:
- [ ] Security validation passed
- [ ] Cost within budget limits
- [ ] Auto-scaling properly configured
- [ ] Documentation complete
- [ ] Backup procedures defined

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⚠️ Important Notes

- **Security**: Never commit `terraform.tfvars` with secrets
- **Cost**: Monitor auto-scaling to avoid unexpected charges
- **Testing**: Always validate in non-production environment first
- **Backups**: Implement proper backup strategies for production use

## 📞 Support

- [Azure Documentation](https://docs.microsoft.com/en-us/azure/)
- [Terraform Documentation](https://www.terraform.io/docs/)
- [TFSec Documentation](https://github.com/aquasecurity/tfsec)
- [Infracost Documentation](https://www.infracost.io/docs/)

---

