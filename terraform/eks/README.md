# Provision an EKS Cluster with Terraform

## Software requirements
- awscli
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [AWS IAM Authenticator](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html)

### Configure awscli
After installing the AWS CLI. Configure it to use your credentials.

```shell
$ aws configure
AWS Access Key ID [None]: <YOUR_AWS_ACCESS_KEY_ID>
AWS Secret Access Key [None]: <YOUR_AWS_SECRET_ACCESS_KEY>
Default region name [None]: <YOUR_AWS_REGION>
Default output format [None]: json
```
This enables Terraform access to the configuration file and performs operations on your behalf with these security credentials.

## Provision EKS cluster
```shell
$ terraform init
$ terraform plan
$ terraform apply
```

## Teardown EKS cluster
```shell
$ terraform destroy
```