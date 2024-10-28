#!/usr/bin/env bash
set -e

# set paths
TARGET_DIR="ops/manifests/.generated"

# overwrite project name
CI_PROJECT_NAME="rovbots"

# mimic environment slug setup
CI_ENVIRONMENT_SLUG="prd"
CI_COMMIT_BRANCH="main"
if [ "${CI_COMMIT_BRANCH}" = "dev" ]
then
    CI_ENVIRONMENT_SLUG="dev"
elif [ "${CI_COMMIT_BRANCH}" = "stage" ]
then
    CI_ENVIRONMENT_SLUG="tst"
fi

echo "kubectl --namespace=${CI_PROJECT_NAME}-${CI_ENVIRONMENT_SLUG} apply -f ${TARGET_DIR}"
kubectl --namespace=${CI_PROJECT_NAME}-${CI_ENVIRONMENT_SLUG} scale deployment rovbots-websock --replicas=0
# apply manifests
kubectl --namespace=${CI_PROJECT_NAME}-${CI_ENVIRONMENT_SLUG} apply -f ${TARGET_DIR}
# scale up
kubectl --namespace=${CI_PROJECT_NAME}-${CI_ENVIRONMENT_SLUG} scale deployment rovbots-websock --replicas=1
# execute info log
kubectl --namespace=${CI_PROJECT_NAME}-${CI_ENVIRONMENT_SLUG} get all
