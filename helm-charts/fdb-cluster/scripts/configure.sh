#!/usr/bin/dumb-init /bin/bash
set -euo pipefail

STATUS_JSON=$(timeout 10 fdbcli --exec "status json")
DATABASE_AVAILABLE="$(echo "${STATUS_JSON}" | jq -r '.client.database_status.available')"

configure_database() {
  NEW=${1:-""}
  echo "Configuring database with the following settings:"
  echo "--------------------------------------"
  cat /app/fdb.json
  echo ""
  echo "--------------------------------------"
  RESOLVERS="$(jq -r '.resolvers' < /app/fdb.json)"
  PROXIES="$(jq -r '.proxies' < /app/fdb.json)"
  LOGS="$(jq -r '.logs' < /app/fdb.json)"
  REDUNDANCY="$(jq -r '.redundancy_mode' < /app/fdb.json)"
  ENGINE="$(jq -r '.storage_engine' < /app/fdb.json)"
  timeout 10 fdbcli --exec "configure ${NEW} ${REDUNDANCY} ${ENGINE} resolvers=${RESOLVERS} proxies=${PROXIES} logs=${LOGS}"
# fileconfigure does not support ssd-redwood-experimental yet
#  timeout 10 fdbcli --exec "fileconfigure ${NEW} /app/fdb.json"
}

if [[ "${DATABASE_AVAILABLE}" == "true" ]]; then
  CURRENT_CONFIGURATION=$(echo "${STATUS_JSON}" | jq '.cluster.configuration | {resolvers: .resolvers, proxies: .proxies, logs: .logs, redundancy_mode: .redundancy_mode, storage_engine: .storage_engine}')

  if diff <(echo "${CURRENT_CONFIGURATION}" | jq -S .) <(jq -S . /app/fdb.json); then
    echo "No configuration change detected, nothing to do."
    exit 0
  else
    configure_database
  fi

else
  RECOVERY_STATE_NAME="$(echo "${STATUS_JSON}" | jq -r '.cluster.recovery_state.name')"
  RECOVERY_STATE_DESCRIPTION="$(echo "${STATUS_JSON}" | jq -r '.cluster.recovery_state.description')"

  if [[ "${RECOVERY_STATE_NAME}" == "configuration_never_created" ]]; then
    configure_database new
  else
    echo "Failed configuring database!"
    echo "Recovery state name: ${RECOVERY_STATE_NAME}"
    echo "Recovery state description: ${RECOVERY_STATE_DESCRIPTION}"
    echo "Fetching status details..."
    timeout 10 fdbcli --exec "status details"
    exit 1
  fi
fi

exit 0
