#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Starting Infrastructure as Code Validation...${NC}"

# Change to infrastructure directory for Terraform operations
cd ../infrastructure

# Initialize Terraform
echo -e "\n${YELLOW}=== Initializing Terraform ===${NC}"
terraform init

# 1. TFLint
echo -e "\n${YELLOW}=== Running TFLint ===${NC}"
tflint --init
if tflint; then
    echo -e "${GREEN}TFLint passed successfully.${NC}"
else
    echo -e "${RED}TFLint found issues!${NC}"
    exit 1
fi

# Return to scripts directory for other operations
cd ../scripts

# 2. TFSec (Default Checks)
echo -e "\n${YELLOW}=== Running TFSec (Default Checks) ===${NC}"
if tfsec ../infrastructure/ --format sarif > ../security/tfsec-report.sarif; then
    echo -e "${GREEN}TFSec default scan completed. Report saved to ../security/tfsec-report.sarif.${NC}"
else
    echo -e "${YELLOW}TFSec found issues. Report saved to ../security/tfsec-report.sarif.${NC}"
fi

# 3. TFSec (Custom Checks)
echo -e "\n${YELLOW}=== Running TFSec (Custom Checks) ===${NC}"
if tfsec ../infrastructure/ --config-file ../security/.tfsec.yml --format sarif > ../security/tfsec-custom-report.sarif; then
    echo -e "${GREEN}TFSec custom scan completed. Report saved to ../security/tfsec-custom-report.sarif.${NC}"
else
    echo -e "${YELLOW}TFSec custom checks found issues. Report saved to ../security/tfsec-custom-report.sarif.${NC}"
fi

# 4. Infracost Breakdown (Cost Estimation)
echo -e "\n${YELLOW}=== Running Infracost Breakdown ===${NC}"
if [ ! -f ../infrastructure/.infracost/terraform.tfstate ]; then
    echo "Running 'infracost breakdown'..."
    infracost breakdown --path ../infrastructure/ --format table --out-file ../cost-optimization/infracost-breakdown.txt
    echo -e "${GREEN}Infracost breakdown report saved to ../cost-optimization/infracost-breakdown.txt${NC}"
else
    echo "Existing state found. Running 'infracost diff'..."
    infracost diff --path ../infrastructure/ --format table --out-file ../cost-optimization/infracost-diff.txt
    echo -e "${GREEN}Infracost diff report saved to ../cost-optimization/infracost-diff.txt${NC}"
fi

# 5. Terraform Plan
echo -e "\n${YELLOW}=== Running Terraform Plan ===${NC}"
cd ../infrastructure
terraform plan -out=tfplan.binary
terraform show -json tfplan.binary > tfplan.json
cd ../scripts

echo -e "\n${GREEN}All validation steps completed! Check the generated reports.${NC}"
echo -e "Reports generated:"
echo -e "  - TFSec (default): ../security/tfsec-report.sarif"
echo -e "  - TFSec (custom): ../security/tfsec-custom-report.sarif"
echo -e "  - Infracost: ../cost-optimization/infracost-breakdown.txt or ../cost-optimization/infracost-diff.txt"
echo -e "  - Terraform plan: ../infrastructure/tfplan.json"
