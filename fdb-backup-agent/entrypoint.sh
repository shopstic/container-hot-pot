#!/usr/bin/dumb-init /bin/bash
# shellcheck shell=bash
set -euo pipefail

FDB_EXPECTED_CONNECTION_STRING=${FDB_EXPECTED_CONNECTION_STRING:?"FDB_EXPECTED_CONNECTION_STRING env variable is required"}
export FDB_CLUSTER_FILE=${FDB_CLUSTER_FILE:-"/app/fdb.cluster"}

CONNECTION_STRING=${FDB_LATEST_CONNECTION_STRING:-""}
if [[ "${CONNECTION_STRING}" == "" ]]; then
  CONNECTION_STRING="${FDB_EXPECTED_CONNECTION_STRING}"
fi

echo "CONNECTION_STRING=${CONNECTION_STRING}"
echo "FDB_CLUSTER_FILE=${FDB_CLUSTER_FILE}"
echo "${CONNECTION_STRING}" > "${FDB_CLUSTER_FILE}"

FDB_PROCESS_LOG_DIR=${FDB_PROCESS_LOG_DIR:-"/app/data/log"}

mkdir -p "${FDB_PROCESS_LOG_DIR}"

/usr/bin/backup_agent \
  -C "${FDB_CLUSTER_FILE}" \
  --log \
  --logdir "${FDB_PROCESS_LOG_DIR}"
