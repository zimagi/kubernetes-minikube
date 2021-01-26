# Upload a helm chart
This shell script uploads a helm chart into a specified artifactory.

## Software requirements
- curl
- helm client

## Confiugre
You can set the next parameters in file `config.sh`:
| VARIABLE | DESCRIPTION | DEFAULT VALUE | EXAMPLE |
| -------- | ----------- | ------------- | ------- |
| ARTIFACTORY_USER_NAME | Username of the artifactory | "" | apple@garden.up |
| ARTIFACTORY_PASSWORD | Password of the artifactory user | "" | eightstars |
| ARTIFACTORY_HELM_REPOSITORY_URL | The url of the helm repository. The url must include the scheme. | "" | https://artifactory.io/helm |
| HELM_CHART_DIRECTORY_PATH | The path of the helm chart directory | /home/helm/magic/chart |

## Usage
First, you have to set variables in file `config.sh` then run:
```
./upload_package.sh
```
