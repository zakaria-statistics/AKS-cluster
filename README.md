# AKS Low-Cost Terraform Setup

This Terraform config deploys a minimal-cost AKS cluster:

- 1× `Standard_B2s` system node
- Azure CNI with Calico
- Monitoring off by default (toggleable)
- VNet + subnet sized for small labs

## Files

- `providers.tf` – Terraform + AzureRM provider config
- `variables.tf` – Inputs (auth, cluster, network, tags)
- `main.tf` – RG, VNet/subnet, optional Log Analytics, AKS cluster
- `outputs.tf` – Handy outputs (FQDN, kubeconfig command)
- `terraform.tfvars` – Sample values (do not commit secrets)

## Prereqs

- Terraform >= 1.5
- Azure CLI
- Service principal with `Contributor` on the target subscription
- SSH public key (OpenSSH `.pub`)

## Auth options

- **Service principal (recommended for automation)**: set `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_TENANT_ID`, `ARM_SUBSCRIPTION_ID` or fill `terraform.tfvars`.
- **CLI user**: `az login` + `az account set --subscription "<id>"`, leave SP vars blank.

## Usage

```bash
terraform init -upgrade
terraform plan
terraform apply
```
