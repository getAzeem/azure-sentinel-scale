#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Starting Infrastructure as Code Validation...${NC}"

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

# 2. TFSec (Default Checks)
echo -e "\n${YELLOW}=== Running TFSec (Default Checks) ===${NC}"
if tfsec . --format sarif > tfsec-report.sarif; then
    echo -e "${GREEN}TFSec default scan completed. Report saved to tfsec-report.sarif.${NC}"
else
    echo -e "${YELLOW}TFSec found issues. Report saved to tfsec-report.sarif.${NC}"
fi

# 3. TFSec (Custom Checks)
echo -e "\n${YELLOW}=== Running TFSec (Custom Checks) ===${NC}"
if tfsec . --config-file .tfsec.yml --format sarif > tfsec-custom-report.sarif; then
    echo -e "${GREEN}TFSec custom scan completed. Report saved to tfsec-custom-report.sarif.${NC}"
else
    echo -e "${YELLOW}TFSec custom checks found issues. Report saved to tfsec-custom-report.sarif.${NC}"
fi

# 4. Infracost Breakdown (Cost Estimation)
echo -e "\n${YELLOW}=== Running Infracost Breakdown ===${NC}"
if [ ! -f .infracost/terraform.tfstate ]; then
    echo "Running 'infracost breakdown'..."
    infracost breakdown --path . --format table --out-file infracost-breakdown.txt
    echo -e "${GREEN}Infracost breakdown report saved to infracost-breakdown.txt${NC}"
else
    echo "Existing state found. Running 'infracost diff'..."
    infracost diff --path . --format table --out-file infracost-diff.txt
    echo -e "${GREEN}Infracost diff report saved to infracost-diff.txt${NC}"
fi

# 5. Terraform Plan
echo -e "\n${YELLOW}=== Running Terraform Plan ===${NC}"
terraform plan -out=tfplan.binary
terraform show -json tfplan.binary > tfplan.json

echo -e "\n${GREEN}All validation steps completed! Check the generated reports.${NC}"
echo -e "Reports generated:"
echo -e "  - TFSec (default): tfsec-report.sarif"
echo -e "  - TFSec (custom): tfsec-custom-report.sarif"
echo -e "  - Infracost: infracost-breakdown.txt or infracost-diff.txt"
echo -e "  - Terraform plan: tfplan.json"
