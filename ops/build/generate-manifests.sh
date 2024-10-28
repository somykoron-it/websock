#!/usr/bin/env bash
set -e

# set paths
TARGET_DIR="ops/manifests/.generated"
BASE_DIR="${TARGET_DIR}/../.."
MANIFESTS_DIR="${TARGET_DIR}/.."
MANIFEST_FILE_PATTERN=${MANIFEST_FILE_PATTERN:-*.yml}

# build environments
CI_ENVIRONMENT_SLUG="prd"
CI_COMMIT_BRANCH="main" #todo: fetch it from env
CI_PROJECT_NAME="rovbots"
# mimic environment slug setup
if [ "${CI_COMMIT_BRANCH}" = "dev" ]
then
    CI_ENVIRONMENT_SLUG="dev"
elif [ "${CI_COMMIT_BRANCH}" = "stage" ]
then
    CI_ENVIRONMENT_SLUG="tst"
fi

# generate manifests
mkdir -p ${TARGET_DIR}
for f in ${MANIFESTS_DIR}/${MANIFEST_FILE_PATTERN}
do
  jinja2 $f ${BASE_DIR}/variables/${CI_ENVIRONMENT_SLUG}.yml --format=yml --strict \
    -D CI_ENVIRONMENT_SLUG=${CI_ENVIRONMENT_SLUG} \
    -D CI_PROJECT_NAME=${CI_PROJECT_NAME} \
    -D IMAGE_URI=${IMAGE_URI} \
    -D AWS_ECR=${AWS_ECR} \
    > "${TARGET_DIR}/$(basename ${f/.manual/})"
done
# check manifests using checkov
for f in ${TARGET_DIR}/*.yml
do
  checkov -f $f --compact --soft-fail
done
