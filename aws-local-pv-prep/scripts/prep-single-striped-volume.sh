#!/usr/bin/env bash
set -euo pipefail

PV_MOUNT_PATH=${PV_MOUNT_PATH:?"PV_MOUNT_PATH environment variable is not set"}
ON_COMPLETE_LABEL_NODE_NAME=${ON_COMPLETE_LABEL_NODE_NAME:?"ON_COMPLETE_LABEL_NODE_NAME environment variable is not set"}
ON_COMPLETE_LABEL=${ON_COMPLETE_LABEL:?"ON_COMPLETE_LABEL environment variable is not set"}

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
nsenter -t 1 -m -u -n -i bash < "${DIR}/nsenter-prep-single-striped-volume.sh"

# Confirm mountpoint indeed exists at this point
if ! nsenter -t 1 -m -u -n -i mountpoint "${PV_MOUNT_PATH}"; then
  echo "Mountpoint '${PV_MOUNT_PATH}' does not exist but prior script completed with 0 exit code!"
  exit 1
fi

echo "All done! Going to label node ${ON_COMPLETE_LABEL_NODE_NAME} with ${ON_COMPLETE_LABEL}=true"
kubectl label --overwrite node "${ON_COMPLETE_LABEL_NODE_NAME}" "${ON_COMPLETE_LABEL}"='true'

