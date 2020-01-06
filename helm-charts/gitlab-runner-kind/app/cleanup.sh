#!/usr/bin/env bash
set -euo pipefail

JOB_ID="${CUSTOM_ENV_CI_PROJECT_PATH_SLUG}-${CUSTOM_ENV_CI_JOB_ID}"
JOB_FILE="/jobs/${JOB_ID}.yaml"

if test -f "${JOB_FILE}"; then
  echo "Cleaning up job file ${JOB_FILE}"
  kubectl delete -f "${JOB_FILE}"
  rm -f "${JOB_FILE}"
fi
