#!/bin/bash
TEMPLATE_ID="$1"
set -e

SRC_DIR="/src/${TEMPLATE_ID}"
echo "publish pre-built image"

devcontainer build --workspace-folder "${SRC_DIR}" --push true --"${TEMPLATE_ID}" dev-container-"${TEMPLATE_ID}":latest

# Clean up
docker rm -f $(docker container ls -f "label=${TEMPLATE_ID}" -q)