#!/usr/bin/env bash
set -euo pipefail
#env

mkdir -p /jobs

JOB_ID="${CUSTOM_ENV_CI_PROJECT_PATH_SLUG}-${CUSTOM_ENV_CI_JOB_ID}"
JOB_FILE="/jobs/${JOB_ID}.yaml"

/app/job-template.sh "${JOB_ID}" "${GITLAB_RUNNER_JOB_NAMESPACE}" > "${JOB_FILE}"
kubectl create -f "${JOB_FILE}"

until kubectl wait pod -n "${GITLAB_RUNNER_JOB_NAMESPACE}" -l "job-name=${JOB_ID}" --for=condition=ready --timeout=2m; do
  echo "Waiting for job ${JOB_ID} to be ready"
  sleep 1
done

echo "Job ${JOB_ID} is ready"

POD_NAME=$(kubectl get po -n "${GITLAB_RUNNER_JOB_NAMESPACE}" -l "job-name=${JOB_ID}" -o=name)

kubectl exec -i -n "${GITLAB_RUNNER_JOB_NAMESPACE}" "${POD_NAME}" -- bash < /app/k8s-start.sh
