# Provision AKS cluster with Terraform

This folder contains Terraform configuration to deploy or destroy aks cluster.

> This Terraform configuration require a remote backend. The version with [github actions](/aks/docs/provision_aks_with_actions.md) creates the remote backend automatically.
## Setup

Install base dependencies:

Requirements:
- Terraform == 0.12.23
- azcli
- Azure subscription


## Create remote backend

This code snippet creates a blob storage for terraform state file. This state file is locked when someonne is running the terraform configuration. This storage is placed a another resource group than the aks cluster.

```bash
LOCATION=westeurope
PREFIX=zimagi
RESOURCE_GROUP_NAME=${PREFIX}-azure-tf
STORAGE_ACCOUNT_NAME=${PREFIX}azuretf
az login
az group create -g $RESOURCE_GROUP_NAME -l $LOCATION
az storage account create -n $STORAGE_ACCOUNT_NAME -g $RESOURCE_GROUP_NAME -l $LOCATION --sku Standard_LRS
az storage container create -n terraform-state --account-name $STORAGE_ACCOUNT_NAME
```

## Provision AKS cluster

Provision script will deploy aks cluster from scratch. There is no need any predeployed resources. To install cluster run the following scripts:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

## Teardown AKS cluster

Destroy configuration destroy all the related service or resource which was created during the provision.

```bash
terraform destroy
```