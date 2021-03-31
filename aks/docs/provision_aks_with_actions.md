# Provision cluster with Github Actions CI

## Github Actions

Github Actions enables you to create custom software development lifecycle workflows directly in your Github repository. These workflows are made out of different tasks so-called actions that can be run automatically on certain events.

This enables you to include Continues Integration (CI) and continuous deployment (CD) capabilities and many other features directly in your repository.

### Cost

Actions are completely free for every open-source repository and include 2000 free build minutes per month for all your private repositories which is comparable with most CI/CD free plans. If that is not enough for your needs you can pick another plan or go the self-hosted route.

## Setup

There is no software dependencies required.

Requirements:
- Azure subscription
- Azure service principal
- Github secrets
- Workflow yaml file

## Deploy service principal

Service principal will interact Azure cloud services. After we create it we will upload its credentials as a secret in Github. Run the following commands:

```bash
az login
SUBSCRIPTION_ID=$(az account show --query id -o tsv)
az ad sp create-for-rbac --role contributor --scopes /subscriptions/${SUBSCRIPTION_ID} --sdk-auth
```

The command should output a JSON object:

```json
{
    "clientId": "<GUID>",
    "clientSecret": "<GUID>",
    "subscriptionId": "<GUID>",
    "tenantId": "<GUID>",
    ...
}
```

open GitHub repository page, and click Settings tab. Open Secrets menu, and click Add a new secret:

![create_github_secret](/aks/docs/images/provision_with_github_actions/create_github_secret.png)

Set the secret name to AZURE_CREDENTIALS and its value to the JSON string that you found under the heading Set up your GitHub repository and authenticate.

![create_secret_azure_credentials](/aks/docs/images/provision_with_github_actions/create_credential.png)

Terraform github action modul uses a different approach for authenticate against azure cloud. It needs other secrets than `AZURE_CREDENTIALS`. Create the following secrets:

| NAME | VALUE |
|------|-------|
| TF_VAR_AGENT_CLIENT_ID | value of `clientId` from output json |
| TF_VAR_AGENT_CLIENT_SECRET | value of `clientSecret` from output json | TF_VAR_SUBSCRIPTION_ID | value of `subscriptionId` from output json |
| TF_VAR_TENANT_ID | value of `tenantId` from output json |

## Provision with Github actions

Action can be triggered manually:

![run_workflow](/aks/docs/images/provision_with_github_actions/run_workflow.png)