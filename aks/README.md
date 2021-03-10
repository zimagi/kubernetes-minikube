# Provision an AKS Cluster with Terraform

## Software requirements
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- Azure CLI

### Configure azcli
After installing the Azure CLI. Configure it to use your credentials.

```shell
$ az login
```
After installing the Azure CLI and logging in. Create an Active Directory service principal account.

```shell
$ az ad sp create-for-rbac --skip-assignment
```
Then, replace terraform.tfvars values with your appId and password. Terraform will use these values to provision resources on Azure.

## Provision Manually
### Provision AKS cluster
```shell
$ terraform init
$ terraform plan
$ terraform apply
```

### Teardown AKS cluster
```shell
terraform destroy
```

### Configure kubectl
```shell
$ az aks get-credentials --resource-group zimagi-rg --name zimagi-aks;
```

## Provision with Github actions

### Setup requirements

Create a service account which will interact with azure cloud:
```bash
az login
SUBSCRIPTION_ID=$(az account show --query id -o tsv)
az ad sp create-for-rbac --role contributor --scopes /subscriptions/${SUBSCRIPTION_ID} --sdk-auth
```
Upload the result of command as a new secret in github with name AZURE_CREDENTIALS. You can find [here](https://docs.microsoft.com/en-us/azure/spring-cloud/spring-cloud-howto-github-actions?pivots=programming-language-java) the detailed steps. You can run the github action in Actions tab.

```bash
LOCATION=westeurope
PREFIX=zimagi
RESOURCE_GROUP_NAME=${PREFIX}-azure-tf
STORAGE_ACCOUNT_NAME=${PREFIX}azuretf
az group create -g $RESOURCE_GROUP_NAME -l $LOCATION
az storage account create -n $STORAGE_ACCOUNT_NAME -g $RESOURCE_GROUP_NAME -l $LOCATION --sku Standard_LRS
az storage container create -n terraform-state --account-name $STORAGE_ACCOUNT_NAME
```