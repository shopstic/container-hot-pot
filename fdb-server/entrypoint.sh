#!/usr/bin/dumb-init /bin/bash
set -euo pipefail

FDB_PROCESS_PORT=${FDB_PROCESS_PORT:?"FDB_PROCESS_PORT env variable is required"}
FDB_PROCESS_CLASS=${FDB_PROCESS_CLASS:?"FDB_PROCESS_CLASS env variable is required"}

FDB_PROCESS_DATA_DIR=${FDB_PROCESS_DATA_DIR:-"/app/data/data/${FDB_PROCESS_PORT}"}
FDB_PROCESS_LOG_DIR=${FDB_PROCESS_LOG_DIR:-"/app/data/log"}

mkdir -p "${FDB_PROCESS_DATA_DIR}" "${FDB_PROCESS_LOG_DIR}"

FDB_MACHINE_ID=${FDB_MACHINE_ID:-$(hostname)}
echo "FDB_MACHINE_ID=${FDB_MACHINE_ID}"

FDB_ZONE_ID=${FDB_ZONE_ID:-""}

if [[ "${FDB_ZONE_ID}" == "" ]]; then
  FDB_ZONE_ID=$(kubectl get no ${FDB_MACHINE_ID} -o json | jq -r '.metadata.labels["failure-domain.beta.kubernetes.io/zone"]')
fi

if [[ "${FDB_ZONE_ID}" == "null" ]]; then
  FDB_ZONE_ID=$(kubectl get no ${FDB_MACHINE_ID} -o json | jq -r '.metadata.labels["topology.kubernetes.io/zone"]')
fi

if [[ "${FDB_ZONE_ID}" == "null" ]]; then
  FDB_ZONE_ID=${FDB_MACHINE_ID}
fi

echo "FDB_ZONE_ID=${FDB_ZONE_ID}"

FDB_PUBLIC_IP=${FDB_PUBLIC_IP:-$(grep `hostname` /etc/hosts | sed -e "s/\s *`hostname`.*//")}

echo "FDB_PUBLIC_IP=${FDB_PUBLIC_IP}"

/usr/bin/fdbserver \
  --class "${FDB_PROCESS_CLASS}" \
  --cluster_file /app/fdb.cluster \
  --datadir "${FDB_PROCESS_DATA_DIR}" \
  --listen_address "0.0.0.0:${FDB_PROCESS_PORT}" \
  --locality_machineid "${FDB_MACHINE_ID}" \
  --locality_zoneid "${FDB_ZONE_ID}" \
  --logdir "${FDB_PROCESS_LOG_DIR}" \
  --public_address "${FDB_PUBLIC_IP}:${FDB_PROCESS_PORT}"