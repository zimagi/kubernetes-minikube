#!/usr/bin/env bash

set -ex
set -o nounset
set -o errtrace
set -o pipefail

source config.sh

_BASE_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
_CONFIG_FILE_PATH="$_BASE_PATH"/config.sh
_HELM_CHART_DIRECTORY_PATH="$HELM_CHART_DIRECTORY_PATH"
_HELM_PACKAGE_DESTINATION_PATH="$_BASE_PATH"/package
_HELM=$(command -v helm)
_CURL=$(command -v curl)

function package_helm_chart() {
  cleanup_package_directory

  # Create folder for the package
  mkdir -p "$_HELM_PACKAGE_DESTINATION_PATH"

  "$_HELM" package "$_HELM_CHART_DIRECTORY_PATH" --destination "$_HELM_PACKAGE_DESTINATION_PATH"
}

function deploy_package_with_curl() {
  _PACKAGE_NAME=$(ls "$_HELM_PACKAGE_DESTINATION_PATH")
  if [ -f "$_HELM_PACKAGE_DESTINATION_PATH"/"$_PACKAGE_NAME" ]; then
    echo "Upload package into artifactory"
    "$_CURL" -u"$ARTIFACTORY_USER_NAME":"$ARTIFACTORY_PASSWORD" -T "$_HELM_PACKAGE_DESTINATION_PATH"/"$_PACKAGE_NAME" "$ARTIFACTORY_HELM_REPOSITORY_URL"/"$_PACKAGE_NAME"
  else
    echo -e "Helm package in folder \"$_HELM_PACKAGE_DESTINATION_PATH\" not found"
    exit 1
  fi
  echo
}

function cleanup_package_directory() {
  # Remove previously packages
  echo "Clean up previous packges"
  rm -rf "$_HELM_PACKAGE_DESTINATION_PATH"
}

package_helm_chart
deploy_package_with_curl
cleanup_package_directory