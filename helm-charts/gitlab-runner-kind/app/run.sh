#!/usr/bin/env bash
set -euo pipefail

JOB_ID="${CUSTOM_ENV_CI_PROJECT_PATH_SLUG}-${CUSTOM_ENV_CI_JOB_ID}"
POD_NAME=$(kubectl get po -n "${GITLAB_RUNNER_JOB_NAMESPACE}" -l "job-name=${JOB_ID}" -o=name)

kubectl exec -i -n "${GITLAB_RUNNER_JOB_NAMESPACE}" "${POD_NAME}" -- bash < "${1}"
