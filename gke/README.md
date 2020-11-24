# Provision an GKE Cluster with Terraform

## Software requirements
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- google cloud CLI

### Configure azcli
After you've installed the gcloud SDK, initialize it by running the following command.

```shell
$ gcloud init
```
This will authorize the SDK to access GCP using your user account credentials and add the SDK to your PATH. This steps requires you to login and select the project you want to work in. Finally, add your account to the Application Default Credentials (ADC). This will allow Terraform to access these credentials to provision resources on GCloud.

```shell
$ gcloud auth application-default login
```
Then, replace terraform.tfvars values with your project_id.
```shell
gcloud config get-value project
```

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
gcloud container clusters get-credentials $(terraform output kubernetes_cluster_name) --region $(terraform output region)
```