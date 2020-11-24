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

## Provision AKS cluster
```shell
$ terraform init
$ terraform plan
$ terraform apply
```

## Teardown AKS cluster
```shell
terraform destroy
```

## Configure kubectl
```shell
$ az aks get-credentials --resource-group zimagi-rg --name zimagi-aks;
```