#!/usr/bin/dumb-init /bin/bash
set -euo pipefail

CURRENT_CLUSTER_FILE_CONFIGMAP=$(kubectl get configmap "${FDB_CLUSTER_FILE_CONFIGMAP_NAME}" -n "${FDB_CLUSTER_NAMESPACE}" -o json)
CURRENT_CLUSTER_FILE_CONTENT=$(echo "${CURRENT_CLUSTER_FILE_CONFIGMAP}" | jq -r '.data.clusterFile')

if [[ "${CURRENT_CLUSTER_FILE_CONTENT}" == "" ]]; then
  FDB_COORDINATOR_NODE_LABEL=${FDB_COORDINATOR_NODE_LABEL:?"FDB_COORDINATOR_NODE_LABEL env variable is required"}
  echo "Raw FDB_COORDINATOR_NODE_LABEL=${FDB_COORDINATOR_NODE_LABEL}"
  FDB_COORDINATOR_NODE_LABEL=$(echo "${FDB_COORDINATOR_NODE_LABEL}" | jq -r 'to_entries | map(.key + "=" + .value) | join(",")')

  echo "FDB_COORDINATOR_NODE_LABEL=${FDB_COORDINATOR_NODE_LABEL}"

  if [[ "${FDB_COORDINATOR_NODE_LABEL}" == "" ]]; then
    echo "No node label provided"
    exit 1
  fi

  COORDINATOR_ADDRESSES=$(kubectl get nodes -l "${FDB_COORDINATOR_NODE_LABEL}" -o json | jq -r '.items[].status.addresses[] | select(.type=="InternalIP") | .address' | xargs -I{} printf "{}:4500\n" | tr '\n' ',' | sed s/,$//)

  if [[ "${COORDINATOR_ADDRESSES}" == "" ]]; then
    echo "Could not determine coordinator addresses, check FDB_COORDINATOR_NODE_LABEL environment value and make sure there are nodes matching that label."
    exit 1
  fi

  FDB_CLUSTER_ID=${FDB_CLUSTER_ID:-$(mktemp -u XXXXXXXX)}
  FDB_CLUSTER_DESCRIPTION=${FDB_CLUSTER_DESCRIPTION:-$(mktemp -u XXXXXXXX)}
  CLUSTER_FILE_CONTENT="${FDB_CLUSTER_DESCRIPTION}:${FDB_CLUSTER_ID}@${COORDINATOR_ADDRESSES}"

  echo "Generated clusterFile content: ${CLUSTER_FILE_CONTENT}"
  echo "${CURRENT_CLUSTER_FILE_CONFIGMAP}" | jq -M --arg newValue "${CLUSTER_FILE_CONTENT}" '.data.clusterFile = $newValue' | kubectl replace -f -
  echo "Replaced fdb-cluster-file configmap"
else
  echo "Current clusterFile content: ${CURRENT_CLUSTER_FILE_CONTENT}"
fi
