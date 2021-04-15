#!/usr/bin/dumb-init /bin/bash
# shellcheck shell=bash
set -euo pipefail

FDB_CONNECTION_STRING=${FDB_CONNECTION_STRING:?"FDB_CONNECTION_STRING env variable is required"}
export FDB_CLUSTER_FILE=${FDB_CLUSTER_FILE:-"/etc/foundationdb/fdb.cluster"}

echo "FDB_CONNECTION_STRING=${FDB_CONNECTION_STRING}"
echo "FDB_CLUSTER_FILE=${FDB_CLUSTER_FILE}"

mkdir -p "$(dirname "${FDB_CLUSTER_FILE}")"
echo "${FDB_CONNECTION_STRING}" > "${FDB_CLUSTER_FILE}"

fdb-prometheus-exporter
