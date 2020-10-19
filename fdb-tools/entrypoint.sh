#!/usr/bin/dumb-init /bin/bash
# shellcheck shell=bash
set -euo pipefail

FDB_EXPECTED_CONNECTION_STRING=${FDB_EXPECTED_CONNECTION_STRING:?"FDB_EXPECTED_CONNECTION_STRING env variable is required"}
export FDB_CLUSTER_FILE=${FDB_CLUSTER_FILE:-"/etc/foundationdb/fdb.cluster"}

CONNECTION_STRING=${FDB_LATEST_CONNECTION_STRING:-""}
if [[ "${CONNECTION_STRING}" == "" ]]; then
  CONNECTION_STRING="${FDB_EXPECTED_CONNECTION_STRING}"
fi

echo "CONNECTION_STRING=${CONNECTION_STRING}"
echo "FDB_CLUSTER_FILE=${FDB_CLUSTER_FILE}"
echo "${CONNECTION_STRING}" > "${FDB_CLUSTER_FILE}"

trap : TERM INT
sleep infinity&
wait
