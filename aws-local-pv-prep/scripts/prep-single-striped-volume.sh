#!/usr/bin/env bash
set -euo pipefail

ON_COMPLETE_LABEL_NODE_NAME=${ON_COMPLETE_LABEL_NODE_NAME:?"ON_COMPLETE_LABEL_NODE_NAME environment variable is not set"}
ON_COMPLETE_LABEL=${ON_COMPLETE_LABEL:?"ON_COMPLETE_LABEL environment variable is not set"}

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
nsenter -t 1 -m -u -n -i bash < "${DIR}/nsenter-prep-single-striped-volume.sh"
echo "All done! Going to label node ${ON_COMPLETE_LABEL_NODE_NAME} with ${ON_COMPLETE_LABEL}=true"
kubectl label --overwrite node "${ON_COMPLETE_LABEL_NODE_NAME}" "${ON_COMPLETE_LABEL}"='true'

