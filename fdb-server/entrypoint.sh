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

FDB_PROCESS_PORT=${FDB_PROCESS_PORT:?"FDB_PROCESS_PORT env variable is required"}
FDB_PROCESS_CLASS=${FDB_PROCESS_CLASS:?"FDB_PROCESS_CLASS env variable is required"}

FDB_PROCESS_DATA_DIR=${FDB_PROCESS_DATA_DIR:-"/app/data/data/${FDB_PROCESS_PORT}"}
FDB_PROCESS_LOG_DIR=${FDB_PROCESS_LOG_DIR:-"/app/data/log"}

mkdir -p "${FDB_PROCESS_DATA_DIR}" "${FDB_PROCESS_LOG_DIR}"

FDB_MACHINE_ID=${FDB_MACHINE_ID:-$(hostname)}
echo "FDB_MACHINE_ID=${FDB_MACHINE_ID}"

AVAILABILITY_ZONE=${AVAILABILITY_ZONE:-""}

if [[ "${AVAILABILITY_ZONE}" == "" ]]; then
  AVAILABILITY_ZONE=$(kubectl get no ${FDB_MACHINE_ID} -o json | jq -r '.metadata.labels["failure-domain.beta.kubernetes.io/zone"]')
fi

if [[ "${AVAILABILITY_ZONE}" == "null" ]]; then
  AVAILABILITY_ZONE=$(kubectl get no ${FDB_MACHINE_ID} -o json | jq -r '.metadata.labels["topology.kubernetes.io/zone"]')
fi

if [[ "${AVAILABILITY_ZONE}" == "null" ]]; then
  AVAILABILITY_ZONE=${FDB_MACHINE_ID}
fi

FDB_ZONE_ID=${FDB_ZONE_ID:-"${AVAILABILITY_ZONE}"}
FDB_DATA_HALL=${FDB_DATA_HALL:-"${AVAILABILITY_ZONE}"}

echo "FDB_ZONE_ID=${FDB_ZONE_ID}"
echo "FDB_DATA_HALL=${FDB_DATA_HALL}"

FDB_PUBLIC_IP=${FDB_PUBLIC_IP:-$(grep `hostname` /etc/hosts | sed -e "s/\s *`hostname`.*//")}

echo "FDB_PUBLIC_IP=${FDB_PUBLIC_IP}"

/usr/bin/fdbserver \
  --class "${FDB_PROCESS_CLASS}" \
  --cluster_file "${FDB_CLUSTER_FILE}" \
  --datadir "${FDB_PROCESS_DATA_DIR}" \
  --listen_address "0.0.0.0:${FDB_PROCESS_PORT}" \
  --locality_machineid "${FDB_MACHINE_ID}" \
  --locality_zoneid "${FDB_ZONE_ID}" \
  --locality_data_hall "${FDB_DATA_HALL}" \
  --logdir "${FDB_PROCESS_LOG_DIR}" \
  --public_address "${FDB_PUBLIC_IP}:${FDB_PROCESS_PORT}"
